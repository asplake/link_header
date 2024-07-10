require "simplecov"
SimpleCov.start do
  enable_coverage :branch
  load_profile "test_frameworks"
end

require "stringio"
require "test/unit"
require File.dirname(__FILE__) + "/../lib/link_header"
