class HumansRb::Parser < Parslet::Parser
    rule(:space)      { match("\s") }
    rule(:space?)     { space.maybe }

    rule(:newline)  { match("\n") }
    rule(:newline?) { newline.maybe }

    rule(:slash_star) { str("/*") }
    rule(:star_slash) { str("*/") }
    rule(:heading_name) { newline.absent? >> space.absent? >> match("[A-Z]").repeat(1) }
    rule(:heading) { slash_star >> space >> heading_name.as(:heading) >> space >> star_slash }

    rule(:colon) { str(":") }
    rule(:key) { newline.absent? >> match("[^:]").repeat.as(:key) >> colon }
    rule(:value) { newline.absent? >> match("[^\n]").repeat }
    rule(:key_value_pair) { newline? >> key >> space >> value.as(:value) >> newline? }

    rule(:section) { newline? >> heading >> newline >> newline? >> key_value_pair.repeat.as(:values) }
    rule(:document) { section.repeat }

    root :document
end
