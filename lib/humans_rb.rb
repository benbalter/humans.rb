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
    if @url_or_string =~ /^http/
      @url_or_string << "/humans.txt" if !(@url_or_string =~ /humans\.txt$/)
      @url_or_string = Typhoeus.get(@url_or_string, accept_encoding: "gzip").body
    end

    normalize_string(@url_or_string)
  end

  def parse
    Transform.new.apply(Parser.new.parse(body))
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree
  end

  private

  def normalize_string(string)
    string = string.force_encoding("UTF-8")
    string = string.encode("UTF-8", :invalid => :replace, :replace => "")
    string = string.gsub(/^\uFEFF/, "")
    string << "\n"
  end
end
