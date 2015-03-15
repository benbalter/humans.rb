require 'typhoeus'
require 'parslet'
require_relative "humans_rb/version"
require_relative "humans_rb/parser"
require_relative "humans_rb/transform"

class HumansRb
  def initialize(url_or_string)
    @url_or_string = url_or_string
  end

  def body
    @body ||= if @url_or_string =~ /^http/
      @url_or_string << "/humans.txt" if !(@url_or_string =~ /humans\.txt$/)
      @url_or_string = Typhoeus.get(@url_or_string, accept_encoding: "gzip").body.
      encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
    else
      @url_or_string.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
    end
  end

  def parse
    Transform.new.apply(Parser.new.parse(body))
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree
  end
end
