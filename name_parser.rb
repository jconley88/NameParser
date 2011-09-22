class NameParser
  class << self
    attr_reader :prefixes, :suffixes, :last_prefixes
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

  @last_prefixes = [
    'al',
    'de',
    'del',
    'el',
    'st',
    'di',
    'da',
    'la',
    'mc',
    'von',
    'van'
  ]

  def initialize(string, opts ={})
    @floating_last_name_prefix = opts[:floating_last_name_prefix] || false
    @original = string
    parse(@original)
  end

  def self.header_array
    %w{prefix, first, middle, last, suffix}
  end

  def to_array
    [@prefix, @first, @middle, @last, @suffix]
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
    if name_parts.length < 2
      @prefix = nil
      @suffix = nil
    else
      @first = name_parts.shift
      @last, remaining_parts = extract_last_name(name_parts)
      @middle = (remaining_parts.length > 0 ? remaining_parts.join(" ") : nil)
    end
  end

  def extract_last_name(name_parts)
    last = []
    last << name_parts.pop
    if @floating_last_name_prefix
      prefix = true
      while name_parts.length > 0 && prefix == true
        if is_last_name_prefix?(name_parts.last)
          last.unshift(name_parts.pop)
          prefix = true
        else
          prefix = false
        end
      end
    end
    [last.join(" "), name_parts]
  end

  def normalize_and_split(original)
    comma_count = original.count(",")
    raise "Unparseable" if comma_count > 1
    if comma_count == 1
      split_last_comma_first_middle(original)
    else
      split_first_middle_last(original)
    end
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

  def is_last_name_prefix?(string)
    return false if string.nil? || string == ""
    NameParser.last_prefixes.any? { |p| string.downcase.match(/^#{p}$/) }
  end

  def is_ix?(kind, string)
    return false if string.nil? || string == ""
    kind.any?{|k| string.downcase.match(/^#{k}\.?$/)}
  end
end