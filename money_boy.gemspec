# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "money_boy/version"

Gem::Specification.new do |spec|
  spec.name          = "money_boy"
  spec.version       = MoneyBoy::VERSION
  spec.authors       = ["Jimmy Börjesson"]
  spec.email         = ["alcesleo@gmail.com"]

  spec.summary       = "A simple money unit/conversion gem"
  spec.homepage      = "https://github.com/alcesleo/money_boy"
  spec.license       = "MIT"

  spec.files         = Dir["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "{lib,test}/**/*", "money_boy.gemspec"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rubocop", "~> 0.48"
end
