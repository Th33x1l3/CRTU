require 'rubygems'
require 'singleton'
require 'fileutils'
require 'log4r'
include Log4r

GLOBAL_LOGGER_FOLDER = File.join(Dir.pwd, 'logs')
GLOBAL_LOGGER_LOG_FILE = File.join(GLOBAL_LOGGER_FOLDER, 'logfile.log')

class GlobalLogger
  include Singleton

  attr_reader :global_console_logger
  attr_reader :global_file_logger
  attr_reader :global_mix_logger

  def initialize

    # Chech if folder exists
    # that way it creates the logs folder beforehand

    dirname = File.dirname(GLOBAL_LOGGER_FOLDER)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(GLOBAL_LOGGER_FOLDER)
    end

    @global_console_logger= Log4r::Logger.new("GlobalLoggerConsole")
    @global_file_logger = Log4r::Logger.new("GlobalLoggerFile")
    @global_mix_logger = Log4r::Logger.new("GlobalLoggerConsoleAndFile")

    pf = PatternFormatter.new(:pattern => "[%l] @ %d : %M")

    so = StdoutOutputter.new("console", :formatter => pf)
    @global_console_logger.outputters << so
    @global_console_logger.level = DEBUG

    fo = FileOutputter.new("f1", :filename => GLOBAL_LOGGER_LOG_FILE, :trunc => false, :formatter => pf)
    @global_file_logger.outputters << fo
    @global_file_logger.level = DEBUG

    @global_mix_logger.outputters << so
    @global_mix_logger.outputters << fo
    @global_mix_logger.level = DEBUG

  end
end


#add instance to kernel so we have global acess to them
module Kernel
  # Console only log 
  def console_logger
    GlobalLogger.instance.global_console_logger
  end

  # File only log
  def file_logger
    GlobalLogger.instance.global_file_logger
  end

  # Console and File log
  def all_logger
    GlobalLogger.instance.global_mix_logger
  end
end

## Local, class wide logger. Should have include LocalLogger added to the class, logger is used
## In cucumber remenber to add teh Utils module to the world
## Usage sample:
## class A
## include LocalLogger
## def method
## mix_logger.debug "Logging to console and File: myHash: #{myHash}"
## end
## end
##
## It is currently implements three functions:
## console_logger() - logging to STDOUT
## file_logger() - logging to FILE
## mix_logger() - logging to both STDOUT and FILE
##
## if LOCAL_LOGGER_LOG_FILE not specified, "/tmp/" + self.class.to_s + "./log" will be used
##

LOCAL_LOGGER_LOG_FILE = File.join(Dir.pwd, 'logs', 'local_logfile.log')
module Utils
  module LocalLogger

    # Class console logger. The messages only go to the stdout
    # No message is saved to file
    def console_logger
      @logger = Log4r::Logger.new("LocalLoggerConsole")
      pf = PatternFormatter.new(:pattern => "[%l] : #{self.class} @ %d : %M")

      so = StdoutOutputter.new("console", :formatter => pf)
      @logger.outputters << so
      @logger.level = DEBUG
      @logger
    end

    # Class simple file logger. Message is stored in file, but
    # it does not appear on stdout
    def file_logger
      log_file = (LOCAL_LOGGER_LOG_FILE.nil?) ? "/tmp/" + self.class.to_s + ".log" : LOCAL_LOGGER_LOG_FILE
      @logger = Log4r::Logger.new("LocalLoggerFile")
      pf = PatternFormatter.new(:pattern => "[%l] : #{self.class} @ %d : %M")

      fo = FileOutputter.new("f1", :filename => log_file, :trunc => false, :formatter => pf)
      @logger.outputters << fo
      @logger.level = DEBUG
      @logger
    end


    # Class wide console and file logger. Message appears on console output and it's stored on file
    def all_logger
      log_file = (LOCAL_LOGGER_LOG_FILE.nil?) ? "/tmp/" + self.class.to_s + ".log" : LOCAL_LOGGER_LOG_FILE
      @logger = Log4r::Logger.new("LocalLoggerConsoleAndFile")
      pf = PatternFormatter.new(:pattern => "[%l] : #{self.class} @ %d : %M")

      so = StdoutOutputter.new("console", :formatter => pf)
      fo = FileOutputter.new("f1", :filename => log_file, :trunc => false, :formatter => pf)

      @logger.outputters << so
      @logger.outputters << fo
      @logger.level = DEBUG
      @logger
    end
  end
end
