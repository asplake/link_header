# Link Header

Parse and format HTTP link headers (and equivalent HTML link elements) as
described in the [Web Linking] spec.

## Description

Converts conforming link headers or HTML link elements to and from text,
`LinkHeader` objects and corresponding (JSON-friendly) `Array` representations.

## Installation

```shell
bundle add link_header
```
  
## Usage

```ruby
require "link_header"

http_link_header = <<~HEADER
  <http://example.com/foo>; rel="self", <http://example.com/>; rel = "up"
HEADER

LinkHeader
  .parse(http_link_header)
  .to_a
#=> [["http://example.com/foo", [["rel", "self"]]], ["http://example.com/", [["rel", "up"]]]]

link_header = LinkHeader.new([
    ["http://example.com/foo", [%w[rel self]]],
    ["http://example.com/", [%w[rel up]]]
])

link_header.to_s
#=> '<http://example.com/foo>; rel="self", <http://example.com/>; rel="up"'

link_header.to_html
#=> '<link href="http://example.com/foo" rel="self">
#    <link href="http://example.com/" rel="up">'
```

For more see the `LinkHeader` and `LinkHeader::Link` classes or `example.rb`.

## Author

Mike Burrows (asplake), email mjb@asplake.co.uk, website [positiveincline.com].

[positiveincline.com]: http://positiveincline.com
[Web Linking]: https://datatracker.ietf.org/doc/html/rfc8288
