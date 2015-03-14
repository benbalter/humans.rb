class HumansRb
  class Transform < Parslet::Transform
    rule(:heading => simple(:heading), :values => subtree(:values)) do |dict|
      { dict[:heading].to_s.downcase.to_sym => dict[:values].reduce(Hash.new, :merge) }
    end

    rule(:member => subtree(:member)) do |dict|
      dict[:member].reduce(Hash.new, :merge)
    end

    rule(:heading => simple(:heading), :members => subtree(:values)) do |dict|
      { dict[:heading].to_s.downcase.to_sym => dict[:values] }
    end

    rule(:key => simple(:key), :value => subtree(:value)) do
      { key.to_s.downcase.to_sym => value.to_s }
    end
  end
end
