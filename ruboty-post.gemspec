lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruboty/post/version"

Gem::Specification.new do |spec|
  spec.name          = "ruboty-post"
  spec.version       = Ruboty::Post::VERSION
  spec.authors       = ["cBouse"]
  spec.email         = ["tyokoreito_oisiiyo@yahoo.co.jp"]

  spec.summary       = "Ruboty handler to post message to other channel by using Incoming Webhook."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/cBouse/ruboty-post"
  spec.license       = "MIT"
  
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'ruboty'
  
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
