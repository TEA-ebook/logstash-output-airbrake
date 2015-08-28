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
    allow(subject).to receive(:send_notice)

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
    let(:event) { LogStash::Event.new("message" => "bar") }

    before do
      subject.receive(event)
    end

    it "should forward the event to Airbrake" do
      expect(subject).to have_received(:send_notice).once
    end
  end
end
