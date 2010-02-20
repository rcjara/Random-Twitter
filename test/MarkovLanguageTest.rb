require File.expand_path(File.dirname(__FILE__) + '/RandomTwitterHelper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/MarkovLanguage')

describe MarkovLanguage do
  context "a simple snippet" do
    before(:each) do
      @snippet = "This is my very small snippet."
      @lang = MarkovLanguage.new
      @lang.add_snippet(@snippet)
    end
    
    it "should have 7 words" do
      @lang.num_words.should == 7
    end
    
    it "should produce the only snippet it is capable of producing" do
      @lang.gen_snippet.should == @snippet
    end
    
    it "should have the right words" do
      @lang.words.sort.should == ["this","is","my","very","small","snippet",". "].sort
    end
  end
  
  context "another, more complex snippet" do
    before(:each) do
      @snippet = "this is my VERY tiny, small snippet.  it RULES!"
      @lang = MarkovLanguage.new
      @lang.add_snippet(@snippet)
    end
    
    it "should have 12 words" do
      @lang.num_words.should == 12
    end
    
    it "some of its words should be shoutable" do
      @lang.fetch_word("very").shoutable?.should == true
      @lang.fetch_word("rules").shoutable?.should == true
    end
    
    it "should only have words with counts of 1" do
      @lang.words.each do |word|
        @lang.fetch_word(word).count.should == 1
      end
    end
    
    it "should have words with the proper shout counts" do
      shout_words = ["very", "rules",". ",",","! "]
      non_shout_words = @lang.words - shout_words
      shout_words.each { |word| @lang.fetch_word(word).shout_count.should == 1 }
      non_shout_words.each { |word| @lang.fetch_word(word).shout_count.should == 0 }
    end
    
    it "should produce the only snippet it is capable of producing" do
      @lang.gen_snippet.should == "This is my VERY tiny, small snippet.  It RULES!"
    end
    
    it "should have the right words" do
      @lang.words.sort.should == ["this","is","my","very","small","snippet","tiny",",",". ","it","rules","! "].sort
    end
  end
  
  context "some real word examples" do
    before(:each) do
      @array_of_snippets = [
        "Spending Valentine's Day with my loves: Booze and the internet",
        "Valentine's Day is a bitches holiday. #nuffsaid",
        "Valentines Day with @briannabaiz my mom and nana.. so excited",
        "Sorry but i think its hilarious how #weallhatemiley , #wesupportmiley & #wehatemileyhaters are all trending xP",
        "are you really justin bieber??",
        "Wow indeed! Sven Kramer is now a trending topic - he deserves it too :)"
      ]
      @array_of_output =   [
        "Spending Valentine's Day with my loves: Booze and the internet",
        "Valentine's Day is a bitches holiday.  #nuffsaid",
        "Valentines Day with @briannabaiz my mom and nana.. so excited",
        "Sorry but i think its hilarious how #weallhatemiley , #wesupportmiley & #wehatemileyhaters are all trending xP",
        "Are you really justin bieber??",
        "Wow indeed! Sven Kramer is now a trending topic - he deserves it too :)"
      ]
        
    end
    
    it "should produce the right sentence" do
      @array_of_snippets.each_with_index do |snippet, i|
        lan = MarkovLanguage.new
        lan.add_snippet(snippet)
        lan.gen_snippet.should == @array_of_output[i]
      end
    end
  
  end
end