require "simplecov"
SimpleCov.start do
  enable_coverage :branch
  load_profile "test_frameworks"
end

require "stringio"
require "test/unit"
require File.dirname(__FILE__) + "/../lib/link_header"

class UnitTest < Test::Unit::TestCase
  protected

  def build_link(href: "http://example.com/", attrs: [%w[rel up], %w[meta bar]])
    LinkHeader::Link.new(href, attrs)
  end
end
