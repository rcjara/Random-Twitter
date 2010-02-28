require File.expand_path(File.dirname(__FILE__) + '/RandomTwitterHelper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/RandomTwitter')

include RandomTwitterHelper

describe RandomTwitter do
  before(:each) do
    @db_path = File.expand_path(File.dirname(__FILE__) + '../config/db.sqlite')
    File.delete(db_path) if File.exists?(db_path)
    @twit = RandomTwitter.new(@db_path)
  end
  
  it "should have a database at the proper path" do
    File.exists?(@db_path).should == true
  end
  
  it "should show 0 tweets" do
    @twit.num_tweets.should == 0
  end
  
  context "after adding grabbing tweets off the internet" do
    before(:each) do
      @twit.grab_tweets
    end
    
    it "should show that it has a bunch of tweets" do
      @twit.num_tweets.should_not == 0
    end
    
    it "should show that it has no tweets dated after a minute from now" do
      @twit.tweets_after(Time.now + 60).size.should == 0
    end
    
    context "and then saving and creating a new twit from the save" do
      before(:each) do
        @twit.save
        @other_twit = RandomTwitter.new(@db_path)
      end
      
      it "should be the same as the other twit" do
        @twit.should == @other_twit
      end
      
      it "should not equal the other twit if it grabs more tweets" do
        @twit.grab_tweets
        @twit.should_not == @other_twit
      end
    end
  end
end