require 'cucumber/rake/task'
require 'fileutils'
require 'pathname'

class BuildFailure < Exception;
  def initialize(message = nil)
    message ||= "Build failed"
    super(message)
  end
end;

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "-r features/ --format progress --out reports/progress.out --format html --out reports/report.html --format json --out reports/cucumber.json"
end

desc "Create log and reports folder in current directory"
task :create_log_report_folders do
  log_path = File.join(Dir.pwd, 'logs')
  report_path = File.join(Dir.pwd,'reports')

  unless File.directory?(log_path)
    FileUtils.mkdir_p(log_path)
  end

  unless File.directory?(report_path)
    FileUtils.mkdir_p(report_path)
  end
end


task :cleanup do
  puts '============    Deleting old logs and reports   ==============='
  puts "PLEASE DON'T USE THIS TASK IN CI SERVER, USE CI OPTIONS INSTEAD"
  puts '=====  USE THIS ONLY FOR DEVELOPMENT IN YOUR OWN MACHINE  ====='

  log_path = File.join(Dir.pwd, 'logs')
  report_path = File.join(Dir.pwd,'reports')

  FileUtils.rm_rf(log_path)
  FileUtils.rm_rf(report_path)
  Rake::Task['create_log_report_folders'].invoke
end



namespace :features do
  desc "Run finished features"
  Cucumber::Rake::Task.new(:finished) do |t|
    t.cucumber_opts = "-r features/ --format progress --out reports/progress.out --format html --out reports/report.html --format json --out reports/cucumber.json --tags ~@wip"
  end

  desc "Run in-progress features"
  Cucumber::Rake::Task.new(:in_progress) do |t|
    t.cucumber_opts = "-r features/ --require formatters/ --format progress --out reports/progress.out --format html --out reports/report.html --format json --out reports/cucumber.json --tags @wip"
  end


  desc 'Run features with given tags - OR joining'
  task :run_with_tags, [:tags] do |t,args|
    if args[:tags].is_a?(String)
      tags_line = args[:tags]
    else
      tags_line = args[:tags].join(',')
    end
    Cucumber::Rake::Task.new(t) do |c|
      c.cucumber_opts = "-r features/ --format progress --out reports/progress.out --format html --out reports/report.html  --format json --out reports/cucumber.json --tags #{tags_line}"
    end
  end
end


desc 'Run specific feature file'
task :run_cucumber_feature, [:feature_name] do |t,args|
  if File.extname(:feature_name).empty?
    filename = "#{:feature_name}.feature"
  else
    filename = :feature_name.to_s
  end

  #if we only give filename, no paths behind
 if File.dirname(filename).empty?
   filepath = File.join(Dir.pwd, 'features', filename)
 else
   # we shoud extract each pathname and process it
   filefolders = File.dirname(filename).split(File::SEPARATOR)
   filepath = File.join(Dir.pwd, 'features')

   filefolders.each do |folder|
     filepath = File.join(filepath,folder)
   end
   filepath = File.join(filename.basename)
 end

  Cucumber::Rake::Task.new(t) do |c|
    c.cucumber_opts = "-r #{filepath} --format progress --out reports/progress.out --format html --out reports/report.html  --format json --out reports/cucumber.json"
  end


end

desc 'Run complete feature build'
task :cruise do
  finished_successful = run_and_check_for_exception('finished')
  in_progress_successful = run_and_check_for_exception('in_progress')

  unless finished_successful && in_progress_successful
    puts
    puts('Finished features had failing steps') unless finished_successful
    puts('In-progress Scenario/s passed when they should fail or be pending') unless in_progress_successful
    puts
    raise BuildFailure
  end
end

def run_and_check_for_exception(task_name)
  puts "*** Running #{task_name} features ***"
  begin
    Rake::Task["features:#{task_name}"].invoke
  rescue StandardError
    return false
  end
  true
end
