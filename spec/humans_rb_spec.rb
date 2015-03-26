require "spec_helper"

describe "humans.rb" do

  before do
    @humans = HumansRb.new load_fixture("humans.txt")
  end

  it "should return the string if passed" do
    expect(HumansRb.new("foo").body).to eql("foo\n")
  end

  it "should return the body if a URL is passed" do
    stub_request(:get, "http://ben.balter.com/humans.txt").
      to_return(:status => 200, :body => "foo", :headers => {})

    expect(HumansRb.new("http://ben.balter.com/humans.txt").body).to eql("foo\n")
  end

  it "should return headings" do
    output = @humans.parse
    expect(output.count).to eql(2)
  end

  it "should parse the humanstxt.org humans.txt file" do
    humans = HumansRb.new(load_fixture("humansorg.txt")).parse
    expect(humans).to_not be_nil
    expect(humans[:team]).to_not be_nil
  end

  it "should parse the GitHub's humans.txt file" do
    humans = HumansRb.new(load_fixture("github-humans.txt")).parse
    expect(humans).to_not be_nil
    expect(humans[:team]).to_not be_nil
  end
end
