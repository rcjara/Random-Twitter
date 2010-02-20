require File.expand_path(File.dirname(__FILE__) + '/RandomTwitterHelper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/MarkovLanguage')

describe MarkovLanguage do
  context "a simple snippet" do
    before(:each) do
      @sentence = "This is my very small sentence."
      @lang = MarkovLanguage.new
      @lang.add_snippet(@sentence)
    end
    
    it "should have 7 words" do
      @lang.num_words.should == 7
    end
    
    it "should produce the only sentence it is capable of producing" do
      @lang.gen_snippet.should == @sentence
    end
    
    it "should have the right words" do
      @lang.words.sort.should == ["this","is","my","very","small","sentence","."].sort
    end
  end
  
  context "another, more complex snippet" do
    before(:each) do
      @snippet = "This is my VERY tiny, small sentence.  It RULES!"
      @lang = MarkovLanguage.new
      @lang.add_snippet(@snippet)
    end
    
    it "should have 7 words" do
      @lang.num_words.should == 9
    end
    
    it "should produce the only snippet it is capable of producing" do
      @lang.gen_snippet.should == @snippet
    end
    
    it "should have the right words" do
      @lang.words.sort.should == ["this","is","my","very","small","sentence","tiny",",",". ","it","rules","! "].sort
    end
  end
end