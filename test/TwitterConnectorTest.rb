require File.expand_path(File.dirname(__FILE__) + '/RandomTwitterHelper.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/TwitterConnector.rb')

describe TwitterConnector do

  shared_examples_for "A TwitterConnector that has loaded a good config file" do
    it "should have loaded the proper username" do
      @tweeter.user_name.should == "rauljara"
    end

    it "should show that it has loaded a password" do
      @tweeter.has_password?.should be(true)
    end

    it "should not show the password" do
      lambda { @tweeter.password }.should raise_error("Error: You cannot access a TwitterConnector's password.")
    end
    
    it "should not yet show that it is logged in" do
      @tweeter.logged_on?.should be(false)
    end
  end
  
  context "on loading a good config file" do
    before(:all) do
      @tweeter = TwitterConnector.new(File.expand_path(File.dirname(__FILE__) + '/../config/rjaccount') )
    end

    it_should_behave_like "A TwitterConnector that has loaded a good config file"

    context "on connecting to twitter" do
      before(:all) do
        @tweeter.connect
      end

      it "should show that it has succesfully logged on" do
        @tweeter.logged_on?.should be(true)
      end

      it "should grab the text from a list of recent tweets" do
        @tweeter.recent_content.class.should be(Array)
      end

      it "should be able to post things" do
        pending("I should write this")
      end
    end
  end
  
  context "on loading a bad config file" do
    it "should raise an error" do
      lambda { TwitterConnector.new(File.expand_path(File.dirname(__FILE__) + '/../config/badconfig') ) }.should raise_error("Bad Config File")
    end
  end
  
  context "on loading a configuration with a bad password" do
    before(:all) do
      @tweeter = TwitterConnector.new(File.expand_path(File.dirname(__FILE__) + '/../config/badpassword') )
    end
    
    it_should_behave_like "A TwitterConnector that has loaded a good config file"
    
    context "on attempting to log on" do

      it "should not show that it has logged on" do
        @tweeter.logged_on?.should be(false)
      end
    end
    
  end
end