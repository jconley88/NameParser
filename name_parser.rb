class NameParser
  class << self
    attr_reader :prefixes, :suffixes
  end
  attr_reader :original, :prefix, :first, :middle, :last, :suffix

  @prefixes = [
    'mr',
    'ms',
    'miss',
    'mrs',
    'sir',
    'prof',
    'professor',
    'md',
    'dr'
  ]

  @suffixes = [
    'ii',
    'iii',
    'iv',
    'v',
    'jr',
    'sr'
  ]

  def initialize(string)
    @original = string
    parse(@original)
  end

  private
  def parse(original)
    name_parts = normalize_and_split(original)

    if is_prefix? name_parts.first
      @prefix = name_parts.shift
    end
    if is_suffix? name_parts.last
      @suffix = name_parts.pop
    end
    @first = name_parts.shift
    @last = name_parts.pop
    @middle = (name_parts.length > 0 ? name_parts.join(" ") : nil)
  end

  def normalize_and_split(original)
    comma_count = original.count(",")
    raise "Unparseable" if comma_count > 1
    split = []
    if comma_count == 1
      split = split_last_comma_first_middle(original)
    else
      split = split_first_middle_last(original)
    end
    split
  end

  def split_last_comma_first_middle(string)
    match = string.match(",")
    normalized = ""
    if match
      normalized = [match.post_match.strip, match.pre_match.strip].join(" ")
    end
    normalized.split(" ")
  end

  def split_first_middle_last(string)
    string.split(" ")
  end

  def is_prefix?(string)
    is_ix?(NameParser.prefixes, string)
  end

  def is_suffix?(string)
    is_ix?(NameParser.suffixes, string)
  end

  def is_ix?(kind, string)
    return false if string.nil? || string == ""
    kind.any?{|k| string.downcase.match(/^#{k}\.?$/)}
  end
end