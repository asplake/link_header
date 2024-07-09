require_relative "../test_helper"

class LinkHeader::LinkTest < Test::Unit::TestCase
  def test_initialization
    assert_equal("http://example.com/", link_header_link.href)
    assert_equal([%w[rel up], %w[meta bar]], link_header_link.attr_pairs)
    assert_equal({"rel" => "up", "meta" => "bar"}, link_header_link.attrs)
  end

  def test_to_a
    assert_equal(["http://example.com/", [%w[rel up], %w[meta bar]]], link_header_link.to_a)
  end

  def test_to_s
    assert_equal('<http://example.com/>; rel="up"; meta="bar"', link_header_link.to_s)
  end

  def test_hash_key_access
    assert_equal("up", link_header_link["rel"])
  end

  private

  def link_header_link
    @link_header_link ||= LinkHeader::Link.new(
      "http://example.com/",
      [%w[rel up], %w[meta bar]]
    )
  end
end
