class ImportsController < ApplicationController
  before_action :authenticate_user!

    def index
    @imports = current_user.imports.order(created_at: :desc)
    end


  def new
    @import = Import.new
  end

  def create
    @import = current_user.imports.new(status: :on_hold)
    @import.file.attach(params[:import][:file])

    if @import.save
      ProcessCsvJob.perform_later(@import.id)
      redirect_to imports_path, notice: "Archivo cargado correctamente. Procesando..."
    else
      flash.now[:alert] = "No se pudo cargar el archivo."
      render :new
    end
  end

  def show
    @import = current_user.imports.find(params[:id])
    @contacts = @import.contact_users.page(params[:page]).per(10)
    @errors = @import.import_errors.page(params[:page]).per(10)
  end
end
