unless ENV['CI']
  begin
    require 'simplecov'
    SimpleCov.start do
      add_filter 'test'
      add_filter '/bundle/'
    end
  rescue LoadError
  end
end

require 'test/unit'
require 'stringio'

if ENV['LEFTRIGHT']
  begin
    require 'leftright'
  rescue LoadError
    puts "Run `gem install leftright` to install leftright."
  end
end

require File.expand_path('../../lib/faraday', __FILE__)

require 'stringio'
require 'uri'

module Faraday
  class TestCase < Test::Unit::TestCase
    LIVE_SERVER = case ENV['LIVE']
      when /^http/ then ENV['LIVE']
      when nil     then nil
      else 'http://127.0.0.1:4567'
    end

    def test_default
      assert true
    end unless defined? ::MiniTest

    def capture_warnings
      old, $stderr = $stderr, StringIO.new
      begin
        yield
        $stderr.string
      ensure
        $stderr = old
      end
    end

    def self.jruby?
      defined? RUBY_ENGINE and 'jruby' == RUBY_ENGINE
    end

    def self.rbx?
      defined? RUBY_ENGINE and 'rbx' == RUBY_ENGINE
    end

    def self.ssl_mode?
      ENV['SSL'] == 'yes'
    end
  end
end
