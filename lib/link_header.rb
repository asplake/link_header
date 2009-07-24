require "strscan"

class LinkHeader
  VERSION = "0.0.3"
  
  # an array of Link objects
  attr_reader :links
  
  #
  # Initialize from array of Link objects or the data from which said Link objects can be created
  #
  def initialize(links=[])
    @links= links.map{|l| l.kind_of?(Link) ? l : Link.new(*l)}
  end
  
  #
  # Convert to a JSON-friendly array
  #
  def to_a
    links.map{|l| l.to_a}
  end
  
  #
  # Convert to string representation as per the link header spec
  #
  def to_s
    links.join(', ')
  end
  
  #
  # Regexes for link header parsing.  TOKEN and QUOTED in particular should conform to RFC2616.
  #
  # Acknowledgement: The QUOTED regexp is based on
  # http://stackoverflow.com/questions/249791/regexp-for-quoted-string-with-escaping-quotes/249937#249937
  #
  HREF   = / *< *([^>]*) *> *;? */                  # note: no attempt to check URI validity
  TOKEN  = /([^()<>@,;:\"\[\]?={}\s]+)/             # non-empty sequence of non-separator characters
  QUOTED = /"((?:[^"\\]|\\.)*)"/                    # double-quoted strings with backslash-escaped double quotes
  ATTR   = /#{TOKEN} *= *(#{TOKEN}|#{QUOTED}) */
  SEMI   = /; */
  COMMA  = /, */

  #
  # Parse a link header, returning a new LinkHeader object
  #
  def self.parse(link_header)
    return new unless link_header
    
    scanner = StringScanner.new(link_header)
    links = []
    while scanner.scan(HREF)
      href = scanner[1]
      attrs = []
      while scanner.scan(ATTR)
        attr_name, token, quoted = scanner[1], scanner[3], scanner[4].gsub(/\\"/, '"')
        attrs.push([attr_name, token || quoted])
        break unless scanner.scan(SEMI)
      end
      links.push(Link.new(href, attrs))
      break unless scanner.scan(COMMA)
    end

    new(links)
  end
    
  #
  # Represents a link - an href and a list of attributes (key value pairs)
  #
  class Link
    # The Link's href (a URI string)
    attr_reader :href
    
    # The link's attributes, an array of key-value pairs
    attr_reader :attr_pairs
    
    #
    # Initialize a Link from an href and attribute list
    #
    def initialize(href, attr_pairs)
      @href, @attr_pairs = href, attr_pairs
    end
    
    #
    # Lazily convert the attribute list to a Hash
    #
    def attrs
      @attrs ||= Hash[*attr_pairs.flatten]
    end
    
    #
    # Access an attribute by key
    #
    def [](key)
      attrs[key]
    end
    
    #
    # Convert to a JSON-friendly Array
    #
    def to_a
      [href, attr_pairs]
    end
    
    #
    # Convert to string representation as per the link header spec
    #
    def to_s
      (["<#{href}>"] + attr_pairs.map{|k, v| "#{k}=\"#{v.gsub(/"/, '\"')}\""}).join('; ')
    end
  end
end
