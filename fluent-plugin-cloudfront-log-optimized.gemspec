# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-cloudfront-log-optimized"
  spec.version       = "0.2.1"
  spec.authors       = ["kubihee", "lenfree", "kjwierenga"]
  spec.email         = ["kubihie@gmail.com", "lenfree.yeung@gmail.com", "k.j.wierenga@gmail.com"]

  spec.summary       = %q{AWS CloudFront log input plugin optimized for large log files. Credit to kubihie and lenfree.}
  spec.description   = %q{AWS CloudFront log input plugin for fluentd. Upstream appears to be unmaintained.}
  spec.homepage      = "https://github.com/kjwierenga/fluent-plugin-cloudfront-log-optimized"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fluentd", ">= 0.14.0", "< 2"
  spec.add_dependency "aws-sdk-s3", "~> 1"
  spec.add_dependency "aws-sdk-sqs", "~> 1"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12"
  spec.add_development_dependency 'test-unit', "~> 2"
end
