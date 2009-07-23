require "test/unit"

LINK_HEADER_S_A = [
  %Q(<http://example.com/>; rel="up"; meta="bar"),
  %Q(<http://example.com/foo>; rel="self"),
  %Q(<http://example.com/>)
]
LINK_HEADER_S = LINK_HEADER_S_A.join(', ')

LINK_HEADER_A = [
  ["http://example.com/", [["rel", "up"], ["meta", "bar"]]],
  ["http://example.com/foo", [["rel", "self"]]],
  ["http://example.com/", []]
]

class TestLinkHeader < Test::Unit::TestCase
  def test_new_link
    link = LinkHeader::Link.new(*LINK_HEADER_A[0])
    assert_equal("http://example.com/", link.href)
    assert_equal([["rel", "up"], ["meta", "bar"]], link.attr_pairs)
    assert_equal({"rel"=>"up", "meta"=>"bar"}, link.attrs)
  end
  
  def test_link_to_a
    assert_equal(LINK_HEADER_A[0], LinkHeader::Link.new(*LINK_HEADER_A[0]).to_a)
  end
  
  def test_link_to_s
    assert_equal(LINK_HEADER_S_A[0], LinkHeader::Link.new(*LINK_HEADER_A[0]).to_s)
  end
  
  def test_new_link_header
    link_header = LinkHeader.new(LINK_HEADER_A)
    assert_equal(LINK_HEADER_A.length, link_header.links.length)
    link = link_header.links[0]
    assert_equal("http://example.com/", link.href)
    assert_equal([["rel", "up"], ["meta", "bar"]], link.attr_pairs)
    assert_equal({"rel"=>"up", "meta"=>"bar"}, link.attrs)
  end
  
  def test_link_header_to_a
    assert_equal(LINK_HEADER_A, LinkHeader.new(LINK_HEADER_A).to_a)
  end
  
  def test_parse_link_header
    assert_equal(LINK_HEADER_A, LinkHeader.parse(LINK_HEADER_S).to_a)
  end
  
  def test_link_header_to_s
    assert_equal(LINK_HEADER_S, LinkHeader.new(LINK_HEADER_A).to_s)
  end
end
