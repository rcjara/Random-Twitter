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
  end
  
  def create_database
    @db.create_table :tweets do
      primary_key :id
      String :text
      Time :time
    end
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
  
  
  private
  
  def insert_tweet_hash(tweet_hash)
    @tweets_table.insert(:text => tweet_hash[:text], :time => tweet_hash[:time])
    @tweets_table_altered = true
  end
  
  
  def gen_tweets
    @tweets = @tweets_table.collect { |tweet_hash| Tweet.new(tweet_hash) }
    @tweets_table_altered = false
  end
  
end