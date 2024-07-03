require "simplecov"
SimpleCov.start do
  load_profile "test_frameworks"
end

require 'stringio'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/link_header'
