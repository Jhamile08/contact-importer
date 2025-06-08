class ImportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @imports = current_user.imports.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @import = Import.new
  end

  def create
    @import = current_user.imports.new(status: :on_hold)
    @import.file.attach(params[:import][:file])

    if @import.save
      redirect_to map_columns_import_path(@import), notice: "File uploaded. Map the columns to continue."
    else
      flash[:alert] = "File upload failed."
      render :new
    end
  end

  def map_columns
    @import = current_user.imports.find(params[:id])
    csv = CSV.parse(@import.file.download, headers: true)
    @headers = csv.headers
  end

def process_mapped
  @import = current_user.imports.find(params[:id])
  mapping = params[:mapping]
  @import.update(column_mapping: mapping)

  ProcessCsvJob.perform_later(@import.id) 

  redirect_to import_path(@import), notice: "Processing file..."
end

  def show
    @import = current_user.imports.find(params[:id])
    @contacts = @import.contact_users.page(params[:page]).per(10)
    @errors = @import.import_errors.page(params[:page]).per(10)
  end
end
