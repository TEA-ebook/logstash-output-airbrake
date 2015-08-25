# encoding: utf-8
require "logstash/namespace"
require "logstash/outputs/base"

require "airbrake"

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
  config :port, :validate => :int

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

    puts event.to_hash.inspect
    return

    Airbrake.notify(
      :error_class   => @error_type,
      :error_message => event['message'],
      :parameters    => event.to_hash
    )
  end # def receive

end # class LogStash::Outputs::Airbrake
