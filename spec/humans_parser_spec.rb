require "spec_helper"

describe HumansRb::Parser do
  let(:parser) { HumansRb::Parser.new }

  context "spaces" do
    let(:space_parser) { parser.space }
    it "can detect a space" do
      expect(space_parser).to parse(" ")
    end
  end

  context "newlines" do
    let(:newline_parser) { parser.newline }
    it "can detect a new line" do
      expect(newline_parser).to parse("\n")
    end
  end
  
  context "stars" do
    let(:star_slash_parser) { parser.star_slash }
    let(:slash_star_parser) { parser.slash_star }

    it "can detect a star slash" do
      expect(star_slash_parser).to parse("*/")
    end

    it "can detect a slash star" do
      expect(slash_star_parser).to parse("/*")
    end
  end

  context "heading parsing" do
    let(:heading_parser) { parser.heading }

    it "parses headings" do
      expect(heading_parser).to parse("/* TEST */")
    end
  end

  context "key/value parsing" do
    let(:key_value_parser) { parser.key_value_pair }

    it "parses key/value pairs" do
      expect(key_value_parser).to parse("foo: bar\n")
      expect(key_value_parser).to parse("foo: bar")
      expect(key_value_parser).to parse("foo foo: bar")
    end
  end

  context "section parsing" do
    let(:section_parser) { parser.section }

    it "parses sctions" do
      expect(section_parser).to parse("/* TEST */\nkey: value")
      expect(section_parser).to parse("/* TEST */\n\nkey: value")
    end
  end
end
