require File.expand_path(File.dirname(__FILE__) + '/MarkovLanguage')
require File.expand_path(File.dirname(__FILE__) + '/TwitterConnector')
require File.expand_path(File.dirname(__FILE__) + '/Tweet')
require File.expand_path(File.dirname(__FILE__) + '/SimpleConfigParser')
require 'Sequel'

class RandomTwitter
  include SimpleConfigParser
  
  def initialize(config_path)
    parse_config_file(config_path, :account_path, :database_path)
    @connector = TwitterConnector.new(@account_path)
    @db = Sequel.sqlite(@database_path)
    create_database unless File.exists?(@database_path)
    @tweets_table = @db[:tweets]
    gen_tweets
    gen_language
  end
  
  def post(automatically = false) 
    @connector.connect
    post = generate_tweet
    continue = !automatically
    while continue
      puts "This is the tweet: " + post
      print "Is it acceptable? "
      continue = gets.chomp != "y"
      post = generate_tweet if continue
    end
    @connector.tweet(post)
  end
  
  def generate_tweet
    snippet = ""
    until RandomTwitter.acceptable?(snippet)
      snippet = language.gen_snippet
    end
    snippet
  end
  
  def create_database
    @db.create_table :tweets do
      primary_key :id
      String :text
      Time :time
    end
  end
  
  def ==(other)
    return false unless language == other.language
    true
  end
  
  def tweets_after(time = Time.now)
    tweets.select { |tweet| tweet.time >= time }
  end
  
  
  def num_tweets
    tweets.length
  end
  
  def grab_tweets
    new_tweets = TwitterConnector.recent_popular_content
    new_tweets.each do |tweet_hash|
      insert_tweet_hash(tweet_hash)
    end
  end
  
  def tweets
    gen_tweets if @tweets_table_altered
    @tweets
  end
  
  def language
    gen_language if @language_altered
    @language
  end
  
  def self.acceptable?(string)
    results = string.scan(/\S+/)
    return false if results.empty?
    results.each do |result|
      return true unless result[0].match(/^#/)
    end
    false
  end
  
  private
  
  def insert_tweet_hash(tweet_hash)
    @tweets_table.insert(:text => tweet_hash[:text], :time => tweet_hash[:time])
    @tweets_table_altered = true
    @language_altered = true
  end
  
  
  def gen_tweets
    @tweets = @tweets_table.collect { |tweet_hash| Tweet.new(tweet_hash) }
    @tweets_table_altered = false
  end
  
  def gen_language
    @language = MarkovLanguage.new
    tweets.each { |tweet| @language.add_snippet(tweet.just_text) }
    @language_altered = false
  end
  
  
end