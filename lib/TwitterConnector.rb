require 'twitter'

class TwitterConnector
  attr_reader :user_name
  
  def initialize(config_file)
    load_config_file(config_file)
  end
  
  def load_config_file(config_file)
    File.open(config_file, 'r') do |file|
      first_regex_result = file.readline.scan(/(username:)(\s*)(\S+)/)
      second_regex_result = file.readline.scan(/(password:)(\s*)(\S+)/)
      begin
        @user_name = first_regex_result[0][2]
        @password = second_regex_result[0][2]
      rescue
        raise "Bad Config File"
      end
    end
  end
  
  def tweet(post)
    raise "Not logged on" unless logged_on?
    @user.update(post)
  end
  
  def most_recent_post
    raise "Not logged on" unless logged_on?
    Twitter::Search.new.from(@user_name).to_a.first.text
  end
  
  
  def has_password?
    !@password.nil?
  end
  
  def password
    raise "Error: You cannot access a TwitterConnector's password."
  end
  
  def connect
    twitter_auth = Twitter::HTTPAuth.new(@user_name, @password)
    @user = Twitter::Base.new(twitter_auth)
  end
  
  def logged_on?
    return false unless @user
    @user.verify_credentials
  end
  
  class << self
    def recent_popular_content(limit = -1)
      current_trends = Twitter::Trends.current
      current_trends[0..limit].collect { |trend| Twitter::Search.new(trend.query).collect{|result| result.text } }.flatten
    end
  end
end