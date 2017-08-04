require 'set'

class WordChainer

  def self.get_dictionary(dictionary_file_name)
    result = Set.new
    File.new(dictionary_file_name).each do |word|
      result.add(word.chomp)
    end
    result
  end

  def initialize(dictionary_file_name='dictionary.txt')
    @dictionary = WordChainer.get_dictionary(dictionary_file_name)
    @current_words = []
    @all_seen_words = {}
  end

  def adjacent_words(word)
    @dictionary.select do |dictionary_word|
      is_adjacent?(word, dictionary_word)
    end

  end

  def is_adjacent?(word1, word2)
    equal_length = word1.length == word2.length
    unmatched_letters = word1.chars.reject.with_index do |char, idx|
      char == word2[idx]
    end

    equal_length && unmatched_letters.length == 1
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = {source => nil}

    while @current_words.length >= 1 && !@all_seen_words.include?(target)
      explore_current_words
    end

    path = build_path(target)
    puts path.empty? ? "Can't find a path!" : path
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        next if @all_seen_words.include?(adjacent_word)
        new_current_words << adjacent_word
        @all_seen_words[adjacent_word] = current_word
      end
    end
    new_current_words.each {|new_current| puts "#{new_current} < #{@all_seen_words[new_current]}"}
    puts "---"
    @current_words = new_current_words
  end

  def build_path(target)
    path = []
    until target.nil?
      path << target
      target = @all_seen_words[target]
    end
    path.reverse
  end
end


if __FILE__ == $0
  chainer = WordChainer.new('/Users/appacademy/Desktop/W1D3/word-chain/dictionary.txt')
  #puts chainer.adjacent_words('duck')
  chainer.run("salter","carder")
end
