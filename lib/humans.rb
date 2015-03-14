require 'typhoeus'
require 'parslet'
require "humans/version"
require "humans/parser"
require "humans/transform"

class HumansRb
  def initialize(url_or_string)
    @url_or_string = url_or_string
  end

  def body
    if @url_or_string =~ /^http/
      @url_or_string << "/humans.txt" if !(@url_or_string =~ /humans\.txt$/)
      @url_or_string = Typhoeus.get(@url_or_string, accept_encoding: "gzip").body.
      encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
    else
      @url_or_string
    end
  end

  def parse
    Transform.new.apply(Parser.new.parse(body))
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree
  end
end
