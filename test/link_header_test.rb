require_relative "test_helper"

class LinkHeaderTest < Test::Unit::TestCase
  LINK_HEADER_STRING_ARRAY = [
    '<http://example.com/>; rel="up"; meta="bar"',
    '<http://example.com/foo>; rel="self"',
    "<http://example.com/>"
  ].freeze
  LINK_HEADER_STRING = LINK_HEADER_STRING_ARRAY.join(", ").freeze

  LINK_HEADER_ARRAY = [
    ["http://example.com/", [%w[rel up], %w[meta bar]]],
    ["http://example.com/foo", [%w[rel self]]],
    ["http://example.com/", []]
  ].freeze

  LINK_HEADER_HTML_ARRAY = [
    '<link href="http://example.com/" rel="up" meta="bar">',
    '<link href="http://example.com/foo" rel="self">',
    '<link href="http://example.com/">'
  ].freeze

  def test_initialization
    assert_equal(LINK_HEADER_ARRAY.length, link_header_from_array.links.length)

    link = link_header_from_array.links.first
    assert_equal("http://example.com/", link.href)
    assert_equal([%w[rel up], %w[meta bar]], link.attr_pairs)
    assert_equal({"rel" => "up", "meta" => "bar"}, link.attrs)
  end

  def test_initialization_with_nil
    links = LinkHeader.new(nil)
    assert_equal([], links.to_a)
  end

  def test_to_a
    assert_equal(LINK_HEADER_ARRAY, link_header_from_array.to_a)
  end

  def test_to_s
    assert_equal(LINK_HEADER_STRING, link_header_from_array.to_s)
  end

  def test_parse_string
    assert_equal(LINK_HEADER_ARRAY, LinkHeader.parse(LINK_HEADER_STRING).to_a)
  end

  def test_parse_nil
    assert_equal(0, LinkHeader.parse(nil).links.size)
  end

  def test_parse_token
    link = LinkHeader.parse("</foo>; rel=self").links.first
    assert_equal("/foo", link.href)
    assert_equal([%w[rel self]], link.attr_pairs)
  end

  def test_parse_href
    assert_equal("any old stuff!", LinkHeader.parse("<any old stuff!>").links.first.href)
  end

  def test_parse_attribute
    assert_equal(["a-token", 'escaped "'], LinkHeader.parse('<any old stuff!> ;a-token="escaped \""').links.first.attr_pairs.first)
  end

  def test_format_attribute
    assert_equal('<any old stuff!>; a-token="escaped \""', LinkHeader.new([["any old stuff!", [["a-token", 'escaped "']]]]).to_s)
  end

  def test_find_link
    link_header = link_header_from_array
    assert_equal([%w[rel self]], link_header.find_link(%w[rel self]).attr_pairs)
  end

  def test_to_html
    assert_equal(LINK_HEADER_HTML_ARRAY.join("\n"), link_header_from_array.to_html)
  end

  def test_to_html_with_separator
    assert_equal(LINK_HEADER_HTML_ARRAY.join("🔗"), link_header_from_array.to_html("🔗"))
  end

  def test_array_push_with_link
    links = LinkHeader.new
    assert_equal([], links.to_a)

    link = LinkHeader::Link.new("http://example.com/foo", [%w[rel self]])
    links << link
    assert_equal(link.to_a, links.to_a.first)
  end

  def test_array_push_with_value
    links = LinkHeader.new
    assert_equal([], links.to_a)

    link = LinkHeader::Link.new("http://example.com/foo", [%w[rel self]])
    links << ["http://example.com/foo", [%w[rel self]]]
    assert_equal(link.to_a, links.to_a.first)
  end

  private

  def link_header_from_array
    @link_header_from_array ||= LinkHeader.new(LINK_HEADER_ARRAY)
  end
end
