require_relative "lib/link_header/version"

Gem::Specification.new do |spec|
  spec.name = "link_header"
  spec.version = LinkHeader::VERSION
  spec.required_ruby_version = LinkHeader::MINIMUM_RUBY_VERSION
  spec.authors = ["Mike Burrows"]
  spec.email = ["mjb@asplake.co.uk"]
  spec.homepage = "https://github.com/asplake/link_header"

  spec.summary = "Process HTTP/HTML Web Linking data"
  spec.description = <<~DESC
    Converts conforming link headers (and HTML link elements) to and from text,
    LinkHeader objects and corresponding (JSON-friendly) Array representations.
  DESC

  spec.license = "MIT"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/asplake/link_header/blob/main/CHANGELOG.md"
  spec.metadata["wiki_uri"] = "https://github.com/asplake/link_header/wiki"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib}/**/*", "LICENSE", "Rakefile", "*.md"]
  end
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
