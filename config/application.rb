require 'ostruct'

module App
  class << self
    attr_accessor :config
  end
end

App.config = OpenStruct.new

App.config.db = OpenStruct.new
App.config.db.name = 'db/db.sqlite3'
App.config.db.host = 'localhost'
App.config.db.adapter = 'sqlite3'