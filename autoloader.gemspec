# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autoloader/version'

Gem::Specification.new do |spec|
  spec.name          = "autoloader"
  spec.version       = Autoloader::VERSION
  spec.authors       = ["Lukas_Skywalker"]
  spec.email         = ["lukas.diener@hotmail.com"]
  spec.description   = "DRY up controller actions"
  spec.summary       = "Automatically create and find model instances in controller actions"
  spec.homepage      = "http://lukasdiener.tk"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
