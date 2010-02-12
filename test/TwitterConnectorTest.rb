require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
      lambda { @tweeter.password }.should raise_error("No method error")
    end

    context "on connecting to twitter" do
      before(:all) do
        @tweeter.connect
      end

      it "should show that it has succesfully logged on" do
        pending("I should write this")
      end

      it "should grab a list of recent tweets" do
        pending("I should write this")  
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