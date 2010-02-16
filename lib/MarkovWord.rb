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
    if MarkovWord.shoutable_test?(identifier)
      @shoutable = true
      @shout_count += 1
    else 
      @speakable = true
      @speak_count += 1
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
  
  def add_child(identifier, child)
    child = MarkovWord.downcase(child)
    @children_count += 1
    @children[child] = @children[child] + 1
    add_identifier(identifier)
  end
  
  def get_random_child
    get_random_relative(@children, @children_count)
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