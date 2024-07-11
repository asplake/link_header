require "link_header/version"
require "strscan"

#
# Represents an HTTP link header of the form described in the Web Linking spec:
# https://datatracker.ietf.org/doc/html/rfc8288
# It is simply a list of LinkHeader::Link objects and some conversion functions.
#
class LinkHeader
  # An array of Link objects
  attr_reader :links

  #
  # Initialize from a collection of LinkHeader::Link objects or other data...
  #
  # From a list of LinkHeader::Link objects:
  #
  #   LinkHeader.new([
  #     LinkHeader::Link.new("http://example.com/foo", [%w[rel self]]),
  #     LinkHeader::Link.new("http://example.com/", [%w[rel up]])
  #   ])
  #
  # From the equivalent JSON-friendly raw data:
  #
  #   LinkHeader.new([
  #     ["http://example.com/foo", [%w[rel self]]],
  #     ["http://example.com/", [%w[rel up]]]
  #   ]).to_s
  #
  # See also LinkHeader.parse
  #
  def initialize(links = [])
    @links = Array(links).map { |link| link.is_a?(Link) ? link : Link.new(*link) }
  end

  def <<(link)
    link = link.is_a?(Link) ? link : Link.new(*link)
    @links << link
  end

  #
  # Convert to a JSON-friendly array
  #
  #   LinkHeader.parse(
  #     '<http://example.com/foo>; rel="self", <http://example.com/>; rel = "up"'
  #   ).to_a
  #   #=> [["http://example.com/foo", [["rel", "self"]]],
  #        ["http://example.com/", [["rel", "up"]]]]
  #
  def to_a
    links.map(&:to_a)
  end

  #
  # Convert to a string representation as per the link header spec
  #
  #   LinkHeader.new([
  #     ["http://example.com/foo", [["rel", "self"]]],
  #     ["http://example.com/",    [["rel", "up"]]]
  #   ]).to_s
  #   #=> '<http://example.com/foo>; rel="self", <http://example.com/>; rel = "up"'
  #
  def to_s
    links.join(", ")
  end

  #
  # Regexes for link header parsing.  TOKEN and QUOTED conform to RFC2616.
  #
  # QUOTED regexp based on http://stackoverflow.com/questions/249791/regexp-for-quoted-string-with-escaping-quotes/249937#249937
  #
  HREF = / *< *([^>]*) *> *;? */                # :nodoc: note: no attempt to check URI validity
  TOKEN = /([^()<>@,;:\"\[\]?={}\s]+)/          # :nodoc: non-empty sequence of non-separator characters
  QUOTED = /"((?:[^"\\]|\\.)*)"/                # :nodoc: double-quoted strings with backslash-escaped double quotes
  ATTR = /#{TOKEN} *= *(#{TOKEN}|#{QUOTED}) */  # :nodoc:
  SEMI = /; */                                  # :nodoc:
  COMMA = /, */                                 # :nodoc:

  #
  # Parse a link header, returning a new LinkHeader object
  #
  #   LinkHeader.parse(
  #     '<http://example.com/foo>; rel="self", <http://example.com/>; rel = "up"'
  #   ).to_a
  #   #=> [["http://example.com/foo", [["rel", "self"]]],
  #        ["http://example.com/", [["rel", "up"]]]]
  #
  def self.parse(link_header)
    return new unless link_header

    scanner = StringScanner.new(link_header)
    links = []
    while scanner.scan(HREF)
      href = scanner[1]
      attrs = []
      while scanner.scan(ATTR)
        attr_name, token, quoted = scanner[1], scanner[3], scanner[4]
        attrs.push([attr_name, token || quoted.gsub('\\"', '"')])
        break unless scanner.scan(SEMI)
      end
      links.push(Link.new(href, attrs))
      break unless scanner.scan(COMMA)
    end

    new(links)
  end

  #
  # Find a member link that has the given attributes
  #
  def find_link(*attr_pairs)
    links.detect do |link|
      !attr_pairs.detect do |pair|
        !link.attr_pairs.include?(pair)
      end
    end
  end

  #
  # Render as a list of HTML link elements
  #
  def to_html(separator = "\n")
    links.map { |link| link.to_html }.join(separator)
  end

  #
  # Represents a link - an href and a list of attributes (key value pairs)
  #
  #   LinkHeader::Link.new(
  #     "http://example.com/foo", [%w[rel self]]
  #   ).to_s
  #   => '<http://example.com/foo>; rel="self"'
  #
  class Link
    #
    # The link's URI string
    #
    #   LinkHeader::Link.new(
    #     "http://example.com/foo", [%w[rel self]]
    #   ).href
    #   => 'http://example.com/foo>'
    #
    attr_reader :href

    #
    # The link's attributes, an array of key-value pairs
    #
    #   LinkHeader::Link.new(
    #     "http://example.com/foo", [%w[rel self], %w[rel canonical]]
    #   ).attr_pairs
    #   => [["rel", "self"], ["rel", "canonical"]]
    #
    attr_reader :attr_pairs

    #
    # Initialize a Link from an href and attribute list
    #
    #   LinkHeader::Link.new(
    #     "http://example.com/foo", [%w[rel self]]
    #   ).to_s
    #   => '<http://example.com/foo>; rel="self"'
    #
    def initialize(href, attr_pairs)
      @href, @attr_pairs = href, attr_pairs
    end

    #
    # Lazily convert the attribute list to a Hash
    #
    # Beware repeated attribute names (it's safer to use #attr_pairs if this is risk):
    #
    #   LinkHeader::Link.new(
    #     "http://example.com/foo", [%[rel self], %w[rel canonical]]
    #   ).attrs
    #   => {"rel" =>"canonical"}
    #
    def attrs
      @attrs ||= Hash[*attr_pairs.flatten]
    end

    #
    # Access #attrs by key
    #
    def [](key)
      attrs[key]
    end

    #
    # Convert to a JSON-friendly Array
    #
    #   LinkHeader::Link.new(
    #     "http://example.com/foo", [%w[rel self], %w[rel canonical]]
    #   ).to_a
    #   => ["http://example.com/foo", [["rel", "self"], ["rel", "canonical"]]]
    #
    def to_a
      [href, attr_pairs]
    end

    #
    # Convert to string representation as per the link header spec.
    # Includes backspace-escaping doublequote characters in quoted attribute values.
    #
    # Convert to string representation as per the link header spec
    #
    #   LinkHeader::Link.new(
    #     ["http://example.com/foo", [%w[rel self]]]
    #   ).to_s
    #   #=> '<http://example.com/foo>; rel="self"'
    #
    def to_s
      (["<#{href}>"] + escaped_attr_pairs).join("; ")
    end

    #
    # Render as an HTML link element
    #
    #   LinkHeader::Link.new(
    #     ["http://example.com/foo", [%w[rel self]]]
    #   ).to_html
    #   #=> '<link href="http://example.com/foo" rel="self">'
    def to_html
      ([%(<link href="#{href}")] + escaped_attr_pairs).join(" ") + ">"
    end

    #
    # Check equality of href and attr pairs values
    #
    def ==(other)
      self.class == other.class &&
        href == other.href &&
        attr_pairs.sort == other.attr_pairs.sort
    end

    private

    def escaped_attr_pairs
      attr_pairs.map { |k, v| "#{k}=\"#{v.gsub('"', '\"')}\"" }
    end
  end
end
