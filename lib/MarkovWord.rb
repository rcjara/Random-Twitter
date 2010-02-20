require 'Set'
require 'RJObjectMods'

class MarkovWord
  attr_reader :identifier, :count, :parents_count, :children_count, :shout_count
  bool_reader :proper, :shoutable, :speakable, :terminates, :punctuation, :sentence_end
  
  PUNCTUATION_REGEX = /[\.\,\:\;\!\?]/
  SENTENCE_END_REGEX = /\.\s|\?\s|\!\s/
  
  def initialize(identifier, parent)
    @identifier = MarkovWord.downcase(identifier)
    @punctuation = MarkovWord.is_punctuation_test?(identifier)
    @sentence_end = MarkovWord.is_sentence_end_test?(identifier)
    
    @count, @parents_count, @children_count, @shout_count = 0, 0, 0, 0
    @parents = Hash.new(0)
    @children = Hash.new(0)
    
    @proper = true
    @shoutable = false
    @speakable = false
    @terminates = false
    
    add_parent(parent, identifier)
  end
  
  def speak_count
    @count - @shout_count
  end
  
  def num_parents
    @parents.length
  end
  
  def num_children
    @children.length
  end
  
  def add_identifier(identifier = @identifier)
    @count += 1
    @proper &&= MarkovWord.proper_test? identifier
    if MarkovWord.shoutable_test?(identifier)
      @shoutable = true
      @shout_count += 1
    else 
      @speakable = true
    end
  end
  
  def add_parent(parent, identifier)
    parent = MarkovWord.downcase(parent)
    @parents_count += 1
    @parents[parent] = @parents[parent] + 1
    add_identifier(identifier)
  end
  
  def get_random_parent
    get_random_relative(@parents, @parents_count)
  end
  
  def add_child(child = nil)
    if child.nil?
      @terminates = true
    else
      child = MarkovWord.downcase(child)
    end
    @children_count += 1
    @children[child] = @children[child] + 1
  end
  
  def get_random_child
    get_random_relative(@children, @children_count)
  end
  
  def display(first = false)
    display_word = identifier.to_s
    display_word.capitalize! if first | proper?
    display_word = " " + display_word unless punctuation?
    return display_word unless shoutable?
    display_word.upcase! if rand(count) < shout_count
    display_word
  end
  
  
  class << self
    def downcase(identifier)
      if identifier.respond_to?(:downcase)
        identifier.downcase
      else
        identifier
      end
    end
    
    def proper_test?(word)
      (word == word.capitalize) || MarkovWord.shoutable_test?(word)
    end
    
    def shoutable_test?(word)
      word == word.upcase
    end
    
    def speakable_test?(word)
      !MarkovWord.shoutable_test?(word)
    end
    
    def is_sentence_end_test?(word)
      word = word.to_s
      return false unless word.scan(SENTENCE_END_REGEX).length > 0
      return false unless word.scan(/\.\.+/).length == 0  #this is for ellipses, e.g. "...."
      true
    end
    
    def is_punctuation_test?(word)
      word = word.to_s
      return false unless word.scan(PUNCTUATION_REGEX).length > 0
      return false if word.scan(/\:\S+/).length > 0    #this is for smileys
      true
    end
  end
  
  private
  
  def get_random_relative(relatives, count)
    index = rand(count)
    keys = relatives.keys
    keys.inject(0) do |running_index, key| 
      running_index += relatives[key]
      return key if running_index > index
      running_index 
    end
  end
end