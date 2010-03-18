require File.expand_path(File.dirname(__FILE__) + '/HTMLDecoder')
require 'kconv'

class Tweet
  URL_PATTERN = /http:\/\/\S+/
  WWW_PATTERN = /www.\S+.\S+/
  
  attr_reader :urls, :time
  
  def initialize(tweet_hash)
    @time = tweet_hash[:time]
    @original_text = HTMLDecoder.decode(tweet_hash[:text].toutf8)
    @urls = @original_text.scan(URL_PATTERN)
  end
  
  def to_s
    @original_text
  end
  
  def just_text
    return @just_text if @just_text
    
    @just_text = @original_text.dup
    
    chop_point = 1
    begin
      while chop_point > 0
        chop_point = 0
        if @just_text[0] == '@'[0]
          chop_point = @just_text.scan(/@\S+\s/)[0].length
        else 
          first_matches = @just_text.scan(/^RT/)
          chop_point = determine_chop_point(@just_text, first_matches[0]) if first_matches[0]
          retweet_matches = @just_text.scan(/RT @\S+\s/)
          chop_point = determine_chop_point(@just_text, retweet_matches[0]) if retweet_matches[0]
          more_retweet_matches = @just_text.scan(/RT @\S+:\sRT\s/)
          chop_point = determine_chop_point(@just_text, more_retweet_matches[0]) if more_retweet_matches[0]
        end
    
        @just_text.slice!(0...chop_point)
      end
    
      @just_text.gsub!(URL_PATTERN, "{url}")
      @just_text.gsub!(WWW_PATTERN, "{url}")
      @just_text = @just_text.strip
    rescue
      @just_text = ""
    end
  end
  
  def determine_chop_point(string, match)
    string.index(match) + match.length
  end
end