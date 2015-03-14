require "spec_helper"

describe HumansRb::Transform do
  let(:xform) { HumansRb::Transform.new }

  context "values" do
    it "transform the key/value pair values" do
      expected = { :foo => "bar" }
      expect(xform.apply({ :key => "foo", :value => "bar" })).to eq(expected)
    end

    it "merges the array of hashes into a single hash" do
      input = { :heading => "test", :values => [{ :foo => "bar"}, {:foo2 => "bar2" }] }
      expected = { :foo => "bar", :foo2 => "bar2" }
      expect(xform.apply(input)[:test]).to eq(expected)
    end
  end

  context "headings" do
    it "converts the heading" do
      input = { :heading => "test", :values => [{ :foo => "bar"}, {:foo2 => "bar2" }] }
      expect(xform.apply(input).keys.first).to eq(:test)
    end
  end
end
