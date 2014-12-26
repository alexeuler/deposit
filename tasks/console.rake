Helpers.require_dir(File.expand_path("../app/models",
                                     File.dirname(__FILE__)))
desc "Runs the console"
task :console do
  require "irb"
  ARGV.clear
  include Models
  IRB.start
end