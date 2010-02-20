require 'kconv'
require File.expand_path(File.dirname(__FILE__) + '/../lib/MarkovWord')

module RandomTwitterHelper
  def array_of_tweets
    File.open(File.expand_path(File.dirname(__FILE__) + '/../config/Tweets')) {|f| f.map{|line| line.chomp} }
    # File.open(File.expand_path(File.dirname(__FILE__) + '/../config/newTweets.txt')) {|f| f.to_a }
  end
  
  def array_of_cleaned_tweets
    File.open(File.expand_path(File.dirname(__FILE__) + '/../config/TweetsCleanedUp')) {|f| f.map{|line| line.chomp.toutf8} }
    # File.open(File.expand_path(File.dirname(__FILE__) + '/../config/newTweets.txt')) {|f| f.to_a }
  end
  
  def nouns_to_markov_words(nouns)
    nouns.collect { |noun| MarkovWord.new(noun, "the") }
  end
end
