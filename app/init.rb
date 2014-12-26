require "rake"
require 'net/http'
require 'uri'
require 'nokogiri'
require_relative '../config/application'
require_relative '../config/db'
require_relative '../config/helpers'
path = File.expand_path("models", File.dirname(__FILE__))
Helpers.require_dir(File.expand_path("models",
                                     File.dirname(__FILE__)))
include Models