# TODO: 
# Seperate classes to make more modular
# Add database support
# Add error handling
# Fix bundler 
# Add configuration options (OptionParser, require 'optparse')

require "rubygems"
require "bundler/setup"
require "pry" # remove for production
Bundler.require

class DeviceAlert
  attr_reader :agent, :mailer, :hostlist, :devices
  def initialize
    @mailer = Mailer.new
    read_hostlist
    create_instances_of_devices
  end

  def read_hostlist
    @hostlist = []
    File.open(File.dirname(__FILE__) + '/hostlist') do |file|
      file.each_line do |line|
        @hostlist << line.chomp
      end
    end
  end

  def create_instances_of_devices
    @devices = []
    @hostlist.each do |host|
      @devices << Device.new(host) 
    end
  end

  def cycle(devices) # Need to break this up
    devices.each do |device|
      puts "Checking device: #{device.host} on port #{device.port}"
      sleep 10
      if device.pinger.ping?
        puts "#{device.host} responded successfully."
        device.last_seen = Time.now
      else
        puts "Host #{device.host} not found. Logging to file."
        @mailer.log_to_file(device)
        # @mailer.report(device) # Mailer should maybe be a module, why am I create new ones
        # Maybe I should initialize one then check if exists
        puts "Logged."
      end
    end
    cycle(devices)
  end
end

class Device
  attr_accessor :host, :port, :type, :pinger, :last_seen
  def initialize(host, port = 80, type = "camera")
    @host = host
    @port = port
    @type = type
    @pinger = Net::Ping::TCP.new(@host, @port)
    @last_seen = "Never" 
  end
end

class Mailer < DeviceAlert
  require "active_support/core_ext/string" # Not sure why Bundle.require isn't loading this
  require "net/smtp"
  attr_reader :root_path
  def initialize
    @header = <<-EOF.strip_heredoc
      From: phil@sheffieldlive.org
      To: phil@sheffieldlive.org
      Subject: Device Not Responding

    EOF
    @root_path = File.expand_path(File.dirname(__FILE__))
  end

  def log_to_file(device)
    File.open(logfile, 'a+') do |file|
      file.puts(report(device))
    end
  end

  def report(device) 
    t = Time.now.strftime('%Y/%m/%d %H:%M:%S -')
    "#{t} Device: #{device.host} (last seen: #{device.last_seen}) is not responding to ping request."
  end

  def logfile
    t = Time.now.strftime('%Y%m%d-device-alert.log')
    @root_path + "/logs/#{t}" # Make configurable
  end

  def alert(device) # currently broken as not the correct smtp settings?
    message = @header + report(device)
    Net::SMTP.start('webmail.sheffieldlive.org',
                    '2095',
                    'localhost',
                    ENV['webmail_username'],
                    ENV['webmail_password'],
                    :login) do |smtp| 
                    smtp.send_message message, ENV['webmail_email'], ENV['webmail_email']
    end
  end
end

if ARGV[0] === 'start'
  app = DeviceAlert.new
  app.read_hostlist
  app.create_instances_of_devices
  puts app.devices
  puts app.mailer.logfile
  app.cycle(app.devices)
end
