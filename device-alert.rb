# TODO: 
# Make it work
# Seperate classes to make more modular
# Add database support

class DeviceAlert
  attr_reader :agent
  def initialize
    @agent = Pinger.new
  end

  def cycle(devices)
    devices.each do |device|
      sleep 5
      unless @agent.ping(host)
        Mailer::new::report(device) # Mailer should maybe be a module, why am I create new ones
        # Maybe I should initialize one the check if exists
      end
    end
  end
end
class Pinger
  require "net/ping"
  def initialize
  end

  def ping(host)
    puts Net::Ping::HTTP.new(host) # device.host
  end
end

class Device
  attr_accessor :name, :host, :port, :type, :last_seen
  def initialize(name, host, port, type)
    @name = name
    @host = host
    @port = port
    @type = type
    @last_seen = Time.now # incorrect but there for testing
  end
end

class Mailer
  # TODO: move gem requires to Gemfile

  def initialize
    @header = <<-EOF.strip_heredoc
      From: Device Alerter <phil@sheffieldlive.org>
      To: SLTV Staff <phil@sheffieldlive.org>
      Subject: Device Not Responding

    EOF
  end

  def report(device) 
    "Device: #{device.name} (last seen: #{device.last_seen}) is not responding to ping request."
  end

  def alert(device) # currently broken as not the correct smtp settings
    message = @header + report(device)
    Net::SMTP.start('localhost') do |smtp| 
      smtp.send_message message, "phil@sheffieldlive.org", "phil@sheffieldlive.org"
    end
  end

end
