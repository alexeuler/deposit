require 'ostruct'

module App
  class << self
    attr_accessor :config
  end
end

App.config = OpenStruct.new

App.config.db = OpenStruct.new
App.config.db.name = File.expand_path('../../db/db.sqlite3', __FILE__)
App.config.db.host = 'localhost'
App.config.db.adapter = 'sqlite3'