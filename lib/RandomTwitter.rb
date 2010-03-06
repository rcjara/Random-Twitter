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
  end
  
  def create_database
    @db.create_table :tweets do
      primary_key :id
      String :test
      Time :time_tweeted
    end
  end
  
  def num_tweets
    @tweets.count
  end
  
  def grab_tweets
    new_tweets = TwitterConnector.grab_recent_content
    new_tweets.each do |tweet_hash|
      
    end
  end
  
  
end