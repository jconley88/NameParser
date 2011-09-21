require File.expand_path(File.join(File.dirname(__FILE__), "../name_parser"))
require 'ruby-debug'

describe NameParser do
  let(:opts){ {} }
  before :each do
    @parsed = NameParser.new(name, opts)
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

  context "when name is one word" do
    let(:name){"name"}

    it "all attributes should be nil" do
      @parsed.prefix.should be_nil
      @parsed.first.should be_nil
      @parsed.middle.should be_nil
      @parsed.last.should be_nil
      @parsed.suffix.should be_nil
    end
  end

  context "when name is one word with prefix and suffix" do
    let(:name){"Sir. Name iii"}

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

  context "when first word partially matches prefix" do
    let(:name) { "Drake Last" }

    it "should set first name to Drake" do
      @parsed.first.should == "Drake"
    end

    it "should set last name to Last" do
      @parsed.last.should == "Last"
    end

    it "should set prefix to nil" do
      @parsed.prefix.should be_nil
    end
  end

  context "when last word partially matches suffix" do
    let(:name) { "First Srov" }

    it "should set first name to First" do
      @parsed.first.should == "First"
    end

    it "should set last name to Srov" do
      @parsed.last.should == "Srov"
    end

    it "should set suffix to nil" do
      @parsed.suffix.should be_nil
    end
  end

  context "when floating_surname_name_prefix flag is set" do
    let(:opts) { {floating_last_name_prefix: true} }
    context "when name is 'Jon Mc Conley'" do
      let(:name) { "Jon Mc Conley" }
      it "should combine common last name prefixes with the last name" do
        @parsed.first.should == "Jon"
        @parsed.middle.should be_nil
        @parsed.last.should == "Mc Conley"
      end
    end

    context "when name is 'Jon De La Conley'" do
      let(:name) { "Jon De La Conley" }
      it "should combine common last name prefixes with the last name" do
        @parsed.first.should == "Jon"
        @parsed.middle.should be_nil
        @parsed.last.should == "De La Conley"
      end
    end
  end

  context "when floating_last_name_prefix flag is not set" do
    let(:name) { "Jon Mc Conley" }
    it "should NOT combine common last name prefixes with the last name" do
      @parsed.first.should == "Jon"
      @parsed.middle.should == "Mc"
      @parsed.last.should == "Conley"
    end
  end
end
