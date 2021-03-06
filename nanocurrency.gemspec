lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nanocurrency/version"

Gem::Specification.new do |spec|
  spec.name          = "nanocurrency"
  spec.version       = Nanocurrency::VERSION
  spec.authors       = ["Elliott Minns"]
  spec.email         = ["elliott@nanotify.io"]

  spec.summary       = "A toolkit for the Nano cryptocurrency, allowing you to derive keys, generate seeds, hashes, signatures, proofs of work and blocks."
  spec.description   = "A toolkit for the Nano cryptocurrency, allowing you to derive keys, generate seeds, hashes, signatures, proofs of work and blocks."
  spec.homepage      = "https://gitlab.com/Nanotify/ruby/nanocurrency"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://gitlab.com/Nanotify/ruby/nanocurrency"
    spec.metadata["changelog_uri"] = "https://gitlab.com/Nanotify/ruby/nanocurrency"
    spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/nanocurrency"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = %w[ext/nanocurrency_ext/extconf.rb]

  spec.add_dependency "blake2b"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake-compiler", "~> 1.0"
end
