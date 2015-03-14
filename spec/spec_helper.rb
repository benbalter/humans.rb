require "bundler/setup"
require "parslet/rig/rspec"

ENV['RACK_ENV'] = 'test'
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'webmock/rspec'

require_relative "../lib/humans"

WebMock.disable_net_connect!

def fixtures_dir
  File.expand_path("./fixtures", File.dirname(__FILE__))
end

def load_fixture(fixture)
  path = File.expand_path(fixture, fixtures_dir)
  File.open(path).read
end
