require "logstash/devutils/rspec/spec_helper"

require "logstash/pipeline"
require "logstash/outputs/airbrake"

describe LogStash::Outputs::Airbrake do
  subject { klass.new(settings) }

  let(:klass) { LogStash::Outputs::Airbrake }

  let(:api_key) { "dummy api key" }
  let(:error_type) { "some error_type" }
  let(:environment) { "some environment" }
  let(:host) { "airbrake host" }
  let(:port) { 4242 }
  let(:settings) {
    {
      "api_key"     => api_key,
      "error_type"  => error_type,
      "environment" => environment,
      "host"        => host,
      "port"        => port
    }
  }

  before do
    allow(Airbrake).to receive(:configure)

    subject.register
  end

  describe "#register" do
    it "should create cleanly" do
      expect(subject).to be_a(klass)
    end

    it "should configure airbrake" do
      expect(Airbrake).to have_received(:configure).once
    end
  end

  describe "#receive" do
    let(:event) { LogStash::Event.new("foo" => "bar") }

    before do
      allow(Airbrake).to receive(:notify)

      subject.receive(event)
    end

    it "should forward the event to Airbrake" do
      expect(Airbrake).to have_received(:notify).once
    end
  end
end
