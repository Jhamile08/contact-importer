# CSV Contact Importer

This is a Ruby on Rails application that lets users upload CSV files to import contacts. Each contact is validated before saving, and if something is wrong (like a missing letter in a name or an invalid email), the error will be shown and the contact will not be saved.

The app uses:
- Ruby on Rails
- Active Job with Sidekiq for background processing
- Turbo for real-time updates without refreshing the page
- Devise for user authentication
- ActiveAdmin for the admin interface

## Requirements

- Ruby 3.2.2
- Rails 7.2.2.1
- Redis
- PostgreSQL

## 🌐 Live Demo

You can access the deployed application at:

👉 [https://contact-importer.onrender.com/](https://contact-importer.onrender.com/)

This is a working demo of the contact importer app, including file uploads, background processing with Sidekiq, and real-time updates using Turbo Streams.

## Setup instructions

## Clone the project:
```bash
git clone https://github.com/your-username/csv-contact-importer.git
cd contact-importer
```

If you don't have Rails installed:

```bash
# Update package list and install required build dependencies
sudo apt update
sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev build-essential libffi-dev libyaml-dev

# Install rbenv and ruby-build using the official installer script
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash

# Add rbenv to PATH and initialize it (for bash shell)
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc

# Install Ruby (example: version 3.2.2)
rbenv install 3.2.2
rbenv global 3.2.2

# Verify the installed Ruby version
ruby -v

# Install Bundler gem
gem install bundler
```
## Install dependencies:
```bash
bundle install
```
## Create .env for database configuration
```bash
RAILS_MASTER_KEY=cf797dcf5a49c0183358328cdd3958c2
REDIS_URL=rediss://default:AWgrAAIjcDEzMDc2ZDVjNTgxODQ0YzkxOTgyZDdjNmIxY2IyNjkwY3AxMA@certain-roughy-26667.upstash.io:6379
ACTION_CABLE_FRONTEND_URL=wss://your-app-name.onrender.com/cable
APP_HOST=https://contact-importer.onrender.com
```
Next step: configure your development database credentials in `config/database.yml`.  
Make sure it points to your local PostgreSQL database or use `ENV["DATABASE_URL"]`.
## Create and migrate database:
```bash
bin/rails db:create db:migrate
```
## Start Redis (required for Sidekiq):
If you have Redis installed:
```bash
sudo service redis-server start
```
If you don't have Redis, install it:
On Ubuntu:
```bash
sudo apt update
sudo apt install redis-server
```
## Enable Redis to start automatically:
```bash
sudo systemctl enable redis-server
```
## Start Sidekiq in a separate terminal:
```bash
bundle exec sidekiq
```
## Run the Rails server:
```bash
rails s
```
## Open http://localhost:3000 in your browser.
