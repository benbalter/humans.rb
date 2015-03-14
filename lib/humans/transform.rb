class HumansRb
  class Transform < Parslet::Transform
    rule(:heading => simple(:heading), :values => subtree(:values)) do |dict|
      { dict[:heading].to_sym => dict[:values].reduce(Hash.new, :merge) }
    end

    rule(:key => simple(:key), :value => subtree(:value)) do
      {key.to_sym => value}
    end
  end
end
