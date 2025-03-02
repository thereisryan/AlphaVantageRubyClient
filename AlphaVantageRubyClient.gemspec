lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = "alpha_vantage_ruby_client"
  s.version	    = "1.0.0"
  s.authors     = ["Ryan Jones"]
  s.email       = ["rjones.mis@gmail.com"]
  s.homepage    = "https://github.com/thereisryan/AlphaVantageRubyClient"
  s.license     = "MIT"
  s.summary     = "A gem for Alpha Vantage"
  s.description = "A ruby wrapper for Alpha Vantage's HTTP API"
  s.platform	   = Gem::Platform::RUBY
  s.require_paths = ["lib"]
  s.files         = ["lib/*", "spec/**/*", "AlphaVantageRubyClient.gemspec", "Gemfile", "LICENSE.md", "README.md"].map {|f| `git ls-files #{f}`.split("\n") }.to_a.flatten
  s.add_runtime_dependency "httparty", ">= 0.15.6"
  s.add_runtime_dependency "humanize", ">= 1.7.0"
  s.add_development_dependency "pry-byebug", '~> 0'
  s.add_development_dependency "rspec", "~>3.5", ">=3.5"
  s.add_development_dependency "awesome_print", "~>1.7", ">= 1.7"
end
