require File.expand_path(File.dirname(__FILE__) + '/RandomTwitterHelper.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/TwitterConnector.rb')

describe TwitterConnector do
  context "on loading a good config file" do
    before(:all) do
      @tweeter = TwitterConnector.new(File.expand_path(File.dirname(__FILE__) + '/../config/rjaccount') )
    end

    it "should have loaded the proper username" do
      @tweeter.user_name.should == "rauljara"
    end

    it "should show that it has loaded a password" do
      @tweeter.has_password?.should be(true)

    end

    it "should not show the password" do
      lambda { @tweeter.password }.should raise_error("Error: You cannot access a TwitterConnector's password.")
    end

    context "on connecting to twitter" do
      before(:all) do
        @tweeter.connect
      end

      it "should show that it has succesfully logged on" do
        @tweeter.logged_on.should be(true)
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
end