Gem::Specification.new do |s|
  s.name            = "logstash-output-airbrake"
  s.version         = "0.2.1"
  s.licenses        = ["Apache License (2.0)"]
  s.summary         = "Logstash Output to Airbrake"
  s.description     = "Output events to Airbrake"
  s.authors         = ["TEA"]
  s.email           = 'technique@tea-ebook.com'
  s.homepage        = "https://github.com/TEA-ebook/logstash-output-airbrake"
  s.require_paths   = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core", ">= 1.4.0", "< 2.0.0"

  s.add_runtime_dependency "airbrake", ['~> 4.0']

  s.add_development_dependency "logstash-input-generator"
  s.add_development_dependency "logstash-devutils"
end
