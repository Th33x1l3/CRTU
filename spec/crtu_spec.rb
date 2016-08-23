require 'spec_helper'

path = File.join(File.dirname(__FILE__),'..','lib','tasks','cucumber_tasks.rake')
puts "PATH: #{path}"
load path

describe Crtu do
  it 'has a version number' do
    expect(Crtu::VERSION).not_to be nil
  end

  it 'has loaded rake tasks' do
  	Rake::Task.define_task(:environment)
  	Rake::Task['create_log_report_folders'].invoke
  end

  it 'has a global logger' do

  	all_logger.debug "test string"
  end

 
end
