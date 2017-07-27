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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httpi"
  # Gotta use httpclient cos net_http don't like the __foo__ JSON keys
  spec.add_dependency "httpclient"
  spec.add_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
