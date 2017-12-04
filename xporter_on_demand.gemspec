# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xporter_on_demand/version"

Gem::Specification.new do |spec|
  spec.name          = "xporter_on_demand"
  spec.version       = XporterOnDemand::VERSION
  spec.authors       = ["Jordan Green"]
  spec.email         = ["jordan.green@meritec.co.uk"]

  spec.summary       = %q{Ruby client for the Xporter on Demand API.}
  spec.homepage      = "https://github.com/meritec/xporter_on_demand"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'httpi', '~> 2.4.2', '>= 2.4.2'
  # Gotta use httpclient cos net_http don't like the __foo__ JSON keys
  spec.add_runtime_dependency 'httpclient', '~> 2.8.3', '>= 2.8.3'
  spec.add_runtime_dependency 'activesupport', '~> 5.0.0.1', '>= 5.0.0.1'
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
