require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'active_support/all'
require 'sequel'
require 'byebug'

Dotenv.load
DB = Sequel.connect ENV["DATABASE_URL"]
DB.extension :pg_json
