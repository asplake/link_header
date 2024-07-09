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

LinkHeader.parse('<http://example.com/foo>; rel="self", <http://example.com/>; rel = "up"').to_a
#=> [["http://example.com/foo", [["rel", "self"]]], ["http://example.com/", [["rel", "up"]]]]

LinkHeader.new([
  ["http://example.com/foo", [["rel", "self"]]],
  ["http://example.com/",    [["rel", "up"]]]]).to_s
#=> '<http://example.com/foo>; rel="self", <http://example.com/>; rel="up"'
```

For more information see the `LinkHeader` and `LinkHeader::Link` classes
(defined in `lib/link_header.rb`) or look in `example.rb` for more usage.

## Author

Mike Burrows (asplake), email mjb@asplake.co.uk, website [positiveincline.com].

[positiveincline.com]: http://positiveincline.com
[Web Linking]: https://datatracker.ietf.org/doc/html/rfc8288
