require "link_header"

#
# Create a `LinkHeader` from `Link` objects
#
link_header = LinkHeader.new(
  [
    LinkHeader::Link.new("http://example.com/foo", [%w[rel self]]),
    LinkHeader::Link.new("http://example.com/", [%w[rel up]])
  ]
)

puts link_header
#=> <http://example.com/foo>; rel="self", <http://example.com/>; rel="up"

link_header.links.map do |link|
  puts "href #{link.href.inspect}, attr_pairs #{link.attr_pairs.inspect}, attrs #{link.attrs.inspect}"
end
#=> href "http://example.com/foo", attr_pairs [["rel", "self"]], attrs {"rel"=>"self"}
#   href "http://example.com/", attr_pairs [["rel", "up"]], attrs {"rel"=>"up"}

#
# Create a LinkHeader from raw (JSON-friendly) data
#
puts LinkHeader.new(
  [
    ["http://example.com/foo", [%w[rel self]]],
    ["http://example.com/", [%w[rel up]]]
  ]
)
#=> <http://example.com/foo>; rel="self", <http://example.com/>; rel="up"

#
# Parse a link header string into a `LinkHeader` object and convert to `Array`
#
header_string = <<~HEADER
  <http://example.com/foo>; rel="self", <http://example.com/>; rel = "up"
HEADER

pp LinkHeader.parse(header_string).to_a
#=> [["http://example.com/foo", [["rel", "self"]]],
#    ["http://example.com/", [["rel", "up"]]]]
