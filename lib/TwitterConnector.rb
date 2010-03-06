require 'twitter'
require File.expand_path(File.dirname(__FILE__) + '/SimpleConfigParser')

class TwitterConnector
  attr_reader :username
  
  include SimpleConfigParser
  
  def initialize(config_path)
    parse_config_file(config_path, :username, :password)
  end
  
  def tweet(post)
    raise "Not logged on" unless logged_on?
    @user.update(post)
  end
  
  def most_recent_post
    raise "Not logged on" unless logged_on?
    Twitter::Search.new.from(@username).to_a.first.text
  end
  
  def has_password?
    !@password.nil?
  end
  
  def password
    raise "Error: You cannot access a TwitterConnector's password."
  end
  
  def connect
    twitter_auth = Twitter::HTTPAuth.new(@username, @password)
    @user = Twitter::Base.new(twitter_auth)
  end
  
  def logged_on?
    return false unless @user
    @user.verify_credentials
  end
  
  class << self
    def recent_popular_content(limit = -1)
      current_trends = Twitter::Trends.current
      current_trends[0..limit].collect do |trend| 
        Twitter::Search.new(trend.query).lang('en').collect do |result| 
          {:text => result.text, :time => Time.now} 
        end 
      end.flatten
    end
    
  end
  
end