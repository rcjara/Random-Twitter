require File.expand_path(File.dirname(__FILE__) + '/MarkovWord')

class MarkovLanguage
  def initialize
    @words = {:begin => MarkovWord.new(:begin, nil)}
  end
  
  def words
    @words.keys.select{|word| word.is_a?(String)}
  end
  
  def num_words
    @words.length - 1
  end
  
  def add_snippet(snippet)
    pieces = (snippet + " ").scan(/\S+\b|\.\s|\?\s|\!\s|\S/u)
    
    handle_word_pair(:begin, pieces[0])
    
    pieces.each_cons(2) do |word_pair|
      handle_word_pair(word_pair[0], word_pair[1])
    end
    
    @words[pieces[-1].downcase].add_child(nil)
  end
  
  def gen_snippet
    sentence = ""
    current_word = @words[:begin]
    new_sentence = true
    while current_word = @words[current_word.get_random_child]
      sentence << current_word.display(new_sentence)
      new_sentence = current_word.sentence_end?
    end
    sentence.strip
  end
  
  def fetch_word(ident)
    return nil unless ident
    if ident.is_a?(Symbol)
      @words[ident]
    else
      @words[ident.downcase]
    end
  end

  private
  
  def handle_word_pair(first_word, second_word)
    first_markov_word = fetch_word(first_word)
    second_markov_word = fetch_word(second_word)
    raise "Warning: This word really should exist by now" unless first_markov_word
    first_markov_word.add_child(second_word)
    
    if second_markov_word
      second_markov_word.add_parent(first_word, second_word)
    else 
      @words[second_word.downcase] = MarkovWord.new(second_word, first_word)
    end
  end
  
  
  
end