# encoding: utf-8
require "logstash/namespace"
require "logstash/outputs/base"

require "airbrake"
require "zlib"

# This output lets you send logs to Airbrake.
class LogStash::Outputs::Airbrake < LogStash::Outputs::Base
  milestone 1

  config_name "airbrake"

  # The API Key to use to send notifications to Airbrake.
  config :api_key, :validate => :string, :required => true

  # The error type to use when sending notifications.
  # Defaults to "RuntimeError"
  config :error_type, :validate => :string, :default => "RuntimeError"

  # The environment name.
  # Defaults to "logstash"
  config :environment, :validate => :string, :default => "logstash"

  # Host of the Airbrake server.
  config :host, :validate => :string

  # Port of the Airbrake server.
  config :port, :validate => :number

  public
  def register
    Airbrake.configure do |c|
      c.api_key          = @api_key
      c.environment_name = @environment

      c.host   = @host if @host
      c.port   = @port if @port
      c.secure = @port.to_i == 443
    end
  end # def register

  public
  def receive(event)
    return unless output?(event)

    send_notice(build_notice(event))
  end # def receive

  private
  def build_notice(event)
    opts = {
      :error_class   => @error_type,
      :error_message => event['message'],
      :host          => event['host'],
      :parameters    => event.to_hash
    }

    LogStash::Outputs::Airbrake::Notice.new(
      Airbrake.configuration.merge(opts)
    )
  end # def build_notice

  private
  def send_notice(notice)
    configuration = Airbrake.configuration
    sender = Airbrake.sender

    return unless configuration.configured? && configuration.public?

    if configuration.async?
      configuration.async.call(notice)
      nil # make sure we never set env["airbrake.error_id"] for async notices
    else
      sender.send_to_airbrake(notice)
    end
  end

end # class LogStash::Outputs::Airbrake

class LogStash::Outputs::Airbrake::Notice < Airbrake::Notice
  def initialize(opts = {})
    super(opts)

    @hostname  = opts[:host] || 'unknown'

    # Airbrake uses the backtrace to aggregate notifications so we cheat and
    # create a dummy backtrace
    error_crc32 = Zlib::crc32(opts[:error_message])
    @backtrace = Airbrake::Backtrace.parse("#{error_crc32}:42:in `#{opts[:error_message]}'")
  end
end
