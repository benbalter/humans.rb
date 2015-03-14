class HumansRb::Parser < Parslet::Parser
    rule(:space)       { str(" ") }
    rule(:space?)      { space.repeat }
    rule(:tab)         { match("[\t]").repeat(1) }
    rule(:tab?)        { match("[\t]").repeat }
    rule(:whitespace)  { (space | tab).repeat(1) }
    rule(:whitespace?) { (space | tab).repeat }

    rule(:newline)  { match("[\n]") >> whitespace? }
    rule(:newline?) { newline.maybe }

    rule(:slash_star) { str("/*") }
    rule(:star_slash) { str("*/") }
    rule(:heading_name) { newline.absent? >> space.absent? >> match("[A-Z]").repeat(1) }
    rule(:heading) { slash_star >> space >> heading_name.as(:heading) >> space >> star_slash >> newline }

    rule(:colon) { str(":") }
    rule(:key) { slash_star.absent? >> newline.absent? >> match("[^:\n]").repeat.as(:key) >> colon }
    rule(:value) { newline.absent? >> match("[^\n]").repeat.as(:value) }
    rule(:key_value_pair) { whitespace? >> key >> space >> value >> newline }
    rule(:key_value_pairs) { key_value_pair.repeat(1).as(:values) }

    rule(:name) { slash_star.absent? >> match("[^\t\n:]").repeat(1).as(:name) >> newline }
    rule(:team_member) { whitespace? >> name.maybe >> key_value_pair.repeat(1) >> newline? >> newline? }
    rule(:team_members) { team_member.as(:member).repeat(2).as(:members) }

    rule(:section) { heading >> newline? >> (team_members | key_value_pairs) >> newline? }
    rule(:document) { section.repeat(1).as(:sections) }

    root :document
end
