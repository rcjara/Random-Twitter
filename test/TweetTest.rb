require File.expand_path(File.dirname(__FILE__) + '/RandomTwitterHelper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/Tweet')

include RandomTwitterHelper

describe Tweet do
  context "tweet_a" do
    before(:each) do
      @tweet = Tweet.new(:text=>"think you know a lot about music? not as much as @JackoWcko #ff him &amp; he'll keep you up-to-date", :time=>Time.now)
    end
    
    it "should convert to a normal string all right" do
      @tweet.to_s.should == "think you know a lot about music? not as much as @JackoWcko #ff him & he'll keep you up-to-date"
    end
    
    it "shouldn't have urls" do
      @tweet.urls.should == []
    end
    
    it "should respond with a time" do
      @tweet.time.should be_instance_of(Time)
      
    end
  end
  
  context "tweet_b" do
    before(:each) do
      @tweet = Tweet.new(:text=>"RT @dia_bollywood: It's not about why #MNIK is getting so much of media coverage...It's why is our democracy curbed to go out in Mumbai and watch a movie!!", :time=>Time.now)
    end
    
    it "should convert to a normal string all right" do
      @tweet.to_s.should == "RT @dia_bollywood: It's not about why #MNIK is getting so much of media coverage...It's why is our democracy curbed to go out in Mumbai and watch a movie!!"
    end
    
    it "should be able to remove a retweet" do
      @tweet.just_text.should == "It's not about why #MNIK is getting so much of media coverage...It's why is our democracy curbed to go out in Mumbai and watch a movie!!"
    end
    
    it "shouldn't have urls" do
      @tweet.urls.should == []
    end
  end
  
  context "tweet_c" do
    before(:each) do
      @tweet = Tweet.new(:text=>"@YungBentley Yup u Kno he Real #OhJustLikeMe LOL", :time=>Time.now)
    end
    
    it "should convert to a normal string all right" do
      @tweet.to_s.should == "@YungBentley Yup u Kno he Real #OhJustLikeMe LOL"
    end
    
    it "should be able to remove a to so and so" do
      @tweet.just_text.should == "Yup u Kno he Real #OhJustLikeMe LOL"
    end
    
    it "shouldn't have urls" do
      @tweet.urls.should == []
    end
  end
   
  context "tweet_d" do
    before(:each) do
     @tweet = Tweet.new(:text=>"RT @bkmacdaddy: Google Buzz Surpasses 9 Million Posts and Comments http://bit.ly/9x7vAZ", :time=>Time.now)
    end

    it "should convert to a normal string all right" do
     @tweet.to_s.should == "RT @bkmacdaddy: Google Buzz Surpasses 9 Million Posts and Comments http://bit.ly/9x7vAZ"
    end

    it "should be able to remove a url" do
     @tweet.just_text.should == "Google Buzz Surpasses 9 Million Posts and Comments {url}"
    end
    
    it "should have urls" do
      @tweet.urls.should == ["http://bit.ly/9x7vAZ"]
    end
  end
  
  context "tweet_d" do
    before(:each) do
     @tweet = Tweet.new(:text=>"RT @bkmacdaddy Google Buzz Surpasses 9 Million Posts and Comments http://bit.ly/9x7vAZ", :time=>Time.now)
    end
    
    it "should be able to remove a url" do
     @tweet.just_text.should == "Google Buzz Surpasses 9 Million Posts and Comments {url}"
    end
  end
  
  context "tweet_e" do
   before(:each) do
     @tweet = Tweet.new(:text=>"RT Google Buzz Surpasses 9 Million Posts and Comments http://bit.ly/9x7vAZ", :time=>Time.now)
    end

    it "should be able to remove a url" do
     @tweet.just_text.should == "Google Buzz Surpasses 9 Million Posts and Comments {url}"
    end
  end
  
  context "a whole bunch of tweets" do
    before(:each) do
      @dirty_tweets = array_of_tweets
      @cleaned_tweets = array_of_cleaned_tweets
    end
    
    it "should clean all of the damn tweets properly" do
      File.open(File.expand_path(File.dirname(__FILE__) + '/../config/TestResults'), 'w') do |f|
        @dirty_tweets.each_with_index do |dirty_tweet, i| 
          tweet = Tweet.new(:text=>dirty_tweet, :time=>Time.now)
          f << tweet.just_text + "\n"
          tweet.just_text.should == @cleaned_tweets[i]
        end
      end
    end
  
  end
  
end