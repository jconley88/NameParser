require File.expand_path(File.join(File.dirname(__FILE__), "../name_parser"))
require 'ruby-debug'

describe NameParser do
  before :each do
    @parsed = NameParser.new(name)
  end

  context "when name is blank" do
    let(:name){""}

    it "all attributes should be nil" do
      @parsed.prefix.should be_nil
      @parsed.first.should be_nil
      @parsed.middle.should be_nil
      @parsed.last.should be_nil
      @parsed.suffix.should be_nil
    end
  end

  context "when name is 'Jon Conley'" do
    let(:name){'Jon Conley'}

    it "should parse out the first name" do
      @parsed.first.should == "Jon"
    end

    it "should parse out last name" do
      @parsed.last.should == "Conley"
    end
  end

  context "when name is 'Jon Joe Conley'" do
    let(:name){ 'Jon Joe Conley'}

    it "should parse out first name" do
      @parsed.first.should == "Jon"
    end

    it "should parse out middle name" do
      @parsed.middle.should == "Joe"
    end

    it "should parse out last name" do
      @parsed.last.should == "Conley"
    end
  end

  context "when name is 'Jon Joe Jingle Hiemer Schmidt Conley'" do
    let(:name){ 'Jon Joe Jingle Hiemer Schmidt Conley'}

    it "should parse out first name" do
      @parsed.first.should == "Jon"
    end

    it "should parse out middle name" do
      @parsed.middle.should == "Joe Jingle Hiemer Schmidt"
    end

    it "should parse out last name" do
      @parsed.last.should == "Conley"
    end
  end

  context "when name is 'Mr. Jon Joe Conley jr'" do
    let(:name){"Mr. Jon Joe Conley jr"}

    it "should parse out the prefix" do
      @parsed.prefix.should == "Mr."
    end

    it "should parse out the suffix" do
      @parsed.suffix.should == "jr"
    end

    it "should parse out first name" do
      @parsed.first.should == "Jon"
    end

    it "should parse out middle name" do
      @parsed.middle.should == "Joe"
    end

    it "should parse out last name" do
      @parsed.last.should == "Conley"
    end
  end

  context "when name is 'Jon   Joe\tConley'" do
    let(:name){"Jon   Joe\tConley"}

    it "should parse out first name" do
      @parsed.first.should == "Jon"
    end

    it "should parse out middle name" do
      @parsed.middle.should == "Joe"
    end

    it "should parse out last name" do
      @parsed.last.should == "Conley"
    end
  end

  context "when name is 'Conley, Jon'" do
    let(:name) { 'Conley, Jon' }

    it "should parse out the first name" do
      @parsed.first.should == "Jon"
    end

    it "should parse out last name" do
      @parsed.last.should == "Conley"
    end

    it "should leave middle name set to nil" do
      @parsed.middle.should be_nil
    end
  end

  context "when name is 'Conley, Jon Joe'" do
    let(:name) { 'Conley, Jon Joe' }

    it "should parse out first name" do
      @parsed.first.should == "Jon"
    end

    it "should parse out middle name" do
      @parsed.middle.should == "Joe"
    end

    it "should parse out last name" do
      @parsed.last.should == "Conley"
    end
  end

  context "when name is 'Conley, Jon Joe Jingle Hiemer Schmidt'" do
    let(:name) { 'Conley, Jon Joe Jingle Hiemer Schmidt' }

    it "should parse out first name" do
      @parsed.first.should == "Jon"
    end

    it "should parse out middle name" do
      @parsed.middle.should == "Joe Jingle Hiemer Schmidt"
    end

    it "should parse out last name" do
      @parsed.last.should == "Conley"
    end
  end

  context "when name is 'Conley JR., mR Jon Joe'" do
    let(:name) { "Conley JR., mR Jon Joe" }

    it "should parse out the prefix" do
      @parsed.prefix.should == "mR"
    end

    it "should parse out the suffix" do
      @parsed.suffix.should == "JR."
    end

    it "should parse out first name" do
      @parsed.first.should == "Jon"
    end

    it "should parse out middle name" do
      @parsed.middle.should == "Joe"
    end

    it "should parse out last name" do
      @parsed.last.should == "Conley"
    end
  end
end
