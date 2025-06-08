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

## Setup instructions

If you don't have Rails installed:

```bash
gem install rails -v 7.2.2.1
```

## Clone the project:
```bash
git clone https://github.com/your-username/csv-contact-importer.git
cd csv-contact-importer
```
## Install dependencies:
```bash
bundle install
```
## Set up the database:
```bash
rails db:setup
```
If you want to reset it later:
```bash
rails db:drop db:create db:migrate
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
bin/dev
```
