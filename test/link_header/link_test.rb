require_relative "../test_helper"

class LinkHeader::LinkTest < UnitTest
  def test_initialization
    assert_equal("http://example.com/", build_link.href)
    assert_equal([%w[rel up], %w[meta bar]], build_link.attr_pairs)
    assert_equal({"rel" => "up", "meta" => "bar"}, build_link.attrs)
  end

  def test_to_a
    assert_equal(["http://example.com/", [%w[rel up], %w[meta bar]]], build_link.to_a)
  end

  def test_to_s
    assert_equal('<http://example.com/>; rel="up"; meta="bar"', build_link.to_s)
  end

  def test_to_html
    assert_equal('<link href="http://example.com/" rel="up" meta="bar">', build_link.to_html)
  end

  def test_to_html_with_escaping
    link = build_link(
      attrs: [["context", 'using "scare quotes" sometimes!']]
    )
    assert_equal('<link href="http://example.com/" context="using \"scare quotes\" sometimes!">', link.to_html)
  end

  def test_hash_key_access
    assert_equal("up", build_link["rel"])
  end

  def test_equals
    reference = build_link(
      attrs: [%w[meta plus], %w[rel up]]
    )
    reordered = build_link(
      attrs: [%w[rel up], %w[meta plus]]
    )
    attr_different = build_link(
      attrs: [%w[rel down]]
    )
    wrong_class = {}

    assert_equal reference, reordered
    assert_not_equal reference, attr_different
    assert_not_equal reference, wrong_class
  end
end
