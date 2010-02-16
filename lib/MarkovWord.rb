require 'Set'

class MarkovWord
  attr_reader :identifier, :count, :parents_count, :children_count, :shout_count, :speak_count
  
  def initialize(identifier, parent)
    @identifier = MarkovWord.downcase(identifier)
    
    @count, @parents_count, @children_count, @shout_count, @speak_count = 0, 0, 0, 0, 0
    @parents = Hash.new(0)
    @children = Hash.new(0)
    
    @proper = true
    @shoutable = false
    @speakable = false
    
    @proper = MarkovWord.proper_test?(identifier)
    @shoutable = MarkovWord.shoutable_test?(identifier)
    
    add_parent(parent, identifier)
  end
  
  def proper?
    @proper
  end
  
  def shoutable?
    @shoutable
  end
  
  def speakable?
    @speakable
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
    @shoutable ||= shout_test! identifier
    @speakable ||= speak_test! identifier
  end
  
  def add_parent(parent, identifier)
    parent = MarkovWord.downcase(identifier)
    @parents_count += 1
    @parents[parent] += 1
    add_identifier(identifier)
  end
  
  def get_random_parent
    index = rand(@parents_count)
    keys = @parents.keys
    keys.inject(0) do |running_index, key| 
      running_index += @parents[key]
      return key if running_index > index
      running_index 
    end
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
  end
  
  private
  
  def shout_test!(word)
    result = MarkovWord.shoutable_test?(word)
    @shout_count += result ? 1 : 0
    result
  end
  
  def speak_test!(word)
    result = MarkovWord.speakable_test?(word)
    @speak_count += result ? 1 : 0
    result
  end
end