# frozen_string_literal: true

require_relative 'app'
require 'sinatra/activerecord/rake'
require 'sinatra/asset_pipeline/task'
require 'rake/testtask'
# require_all 'tasks'
require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new

Sinatra::AssetPipeline::Task.define! Sinatra::Application

desc 'Boot up a console with required context'
task :console do
  require 'pry'
  require_relative 'init'
  Pry.start
end
