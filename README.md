# link_header

Parse and format HTTP link headers as described in the draft spec http://tools.ietf.org/id/draft-nottingham-http-link-header-06.txt, also the equivalent HTML link elements.

## Description

Converts conforming link headers to and from text, LinkHeader objects and corresponding (JSON-friendly) Array representations, also HTML link elements.

## Installation

```ruby
gem install link_header
```
  
## Usage

```ruby
require "link_header"

LinkHeader.parse('<http://example.com/foo>; rel="self", <http://example.com/>; rel = "up"').to_a
#=> [["http://example.com/foo", [["rel", "self"]]], ["http://example.com/", [["rel", "up"]]]]

LinkHeader.new([
  ["http://example.com/foo", [["rel", "self"]]],
  ["http://example.com/",    [["rel", "up"]]]]).to_s
#=> '<http://example.com/foo>; rel="self", <http://example.com/>; rel="up"'
```

For more information see the LinkHeader and LinkHeader::Link classes (both defined in lib/link_header.rb).

## Author

Mike Burrows (asplake), email mjb@asplake.co.uk, website [positiveincline.com](http://positiveincline.com)
