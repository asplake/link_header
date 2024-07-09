lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'link_header/version'

Gem::Specification.new do |spec|
  spec.name          = "link_header"
  spec.version       = LinkHeader::VERSION
  spec.authors       = ["Mike Burrows"]
  spec.email         = ["mjb@asplake.co.uk"]
  spec.summary = "Process HTTP/HTML Web Linking data"
  spec.description = <<~DESC
  Converts conforming link headers (and HTML link elements) to and from text,
  LinkHeader objects and corresponding (JSON-friendly) Array representations.
  DESC
  spec.homepage      = "https://github.com/asplake/link_header"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
