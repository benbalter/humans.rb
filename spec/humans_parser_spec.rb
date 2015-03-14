require "spec_helper"

describe HumansRb::Parser do
  let(:parser) { HumansRb::Parser.new }

  context "spaces" do
    let(:space_parser) { parser.space }
    it "can detect a space" do
      expect(space_parser).to parse(" ")
      expect(space_parser).to_not parse("\n")
    end
  end

  context "newlines" do
    let(:newline_parser) { parser.newline }
    it "can detect a new line" do
      expect(newline_parser).to parse("\n")
      expect(newline_parser).to_not parse(" ")
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
    let(:heading_name_parser) { parser.heading_name }

    it "parses the heading name" do
      expect(heading_name_parser).to parse("TEST")
      expect(heading_name_parser).to_not parse("TEST TEST")
    end

    it "parses headings" do
      expect(heading_parser).to parse("/* TEST */\n")
    end
  end

  context "key/value parsing" do
    let(:key_value_parser) { parser.key_value_pair }
    let(:colon_parser) { parser.colon }
    let(:key_parser) { parser.key }
    let(:value_parser) { parser.value }

    it "detects colons" do
      expect(colon_parser).to parse(":")
    end

    it "detects keys" do
      expect(key_parser).to parse("foo:")
      expect(key_parser).to parse("foo bar:")
      expect(key_parser).to_not parse("foo:\n")
      expect(key_parser).to_not parse("foo: ")
    end

    it "detects values" do
      expect(value_parser).to parse("foo bar")
      expect(value_parser).to_not parse("foo \nbar")
    end

    it "parses key/value pairs" do
      expect(key_value_parser).to parse("foo: bar\n")
      expect(key_value_parser).to parse("foo: bar\n")
      expect(key_value_parser).to parse("foo foo: bar\n")
    end

    it "parses key value pairs with leading whitespace" do
      expect(key_value_parser).to parse("  foo: bar\n")
      expect(key_value_parser).to parse("\tfoo: bar\n")
    end
  end

  context "teams" do
    let(:name_parser) { parser.name }
    let(:team_member_parser) { parser.team_member }
    let(:team_members_parser) { parser.team_members }

    it "detects a team member" do
      expect(team_member_parser).to parse("key: value\nkey2: value2\n\n")
    end

    it "detects GitHub-style names" do
      expect(name_parser).to parse("Ben Balter\n")
    end

    it "detects Github-style team members" do
      input = <<-text
  Jesse Newland
  Site: https://github.com/jnewland
  Location: San Francisco, CA

      text
      expect(team_member_parser).to parse(input)
    end

    it "detects teams" do
      input = <<-text
Name: benbalter
Site: https://github.com/benbalter

Name: balterbot
Site: https://github.com/balterbot
      text
      expect(team_members_parser).to parse(input)
    end

    it "detects GitHub-style humans.txt teams" do
      input = <<-text
  Jesse Newland
  Site: https://github.com/jnewland
  Location: San Francisco, CA

  Justin Palmer
  Site: https://github.com/Caged
  Location: Portland, OR

  Sonya Green
  Site: https://github.com/sundaykofax


  Lee Reilly
  Site: https://github.com/leereilly
  Location: San Francisco, CA
      text
      expect(team_members_parser).to parse(input)
    end
  end

  context "section parsing" do
    let(:section_parser) { parser.section }

    it "parses sctions" do
      expect(section_parser).to parse("/* TEST */\nkey: value\n")
      expect(section_parser).to parse("/* TEST */\n\nkey: value\n")
    end

    it "parses sctions with tabs" do
      expect(section_parser).to parse("/* TEST */\n\tkey: value\n")
      expect(section_parser).to parse("/* TEST */\n\n\tkey: value\n")
    end

    it "should parse a TEAM section" do
      input = <<-text
/* TEAM */
Name: benbalter
Site: https://github.com/benbalter

Name: balterbot
Site: https://github.com/balterbot
      text
      expect(section_parser).to parse(input)
    end
  end

  context "document" do
    let(:document_parser) { parser.document }

    it "parses multiple sections" do
      input = <<-text
/* SITE */
Last Updated: 2015/03/12
Standards: HTML5, CSS3

/* TEAM */
Name: benbalter
Site: https://github.com/benbalter

      text
      expect(document_parser).to parse(input)
    end

    it "should parse ben.balter.com's humans.txt" do
      input = <<-text
/* SITE */
Last Updated: 2015/03/12
Standards: HTML5, CSS3

/* TEAM */

Name: benbalter
Site: https://github.com/benbalter

Name: balterbot
Site: https://github.com/balterbot
      text
      expect(document_parser).to parse(input)
    end
  end
end
