require File.expand_path(File.dirname(__FILE__) + '/RandomTwitterHelper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/MarkovWord')

describe MarkovWord do
  shared_examples_for "a non-terminating word" do
    it "should show that it doesn't terminate" do
      @word.terminates?.should == false
    end
  end
  
  shared_examples_for "a word that hasn't had any children added" do
    it "should show that it has no children" do
      @word.num_children.should == 0
    end
    
    it "should show a children count of 0" do
      @word.children_count.should == 0
    end
    
    it_should_behave_like "a non-terminating word"
  end
  
  shared_examples_for "a word that hasn't had any parents added" do
    it "should show that it has 1 parent" do
      @word.num_parents.should == 1
    end
    
    it "should show a parents count of 1" do
      @word.parents_count.should == 1
    end
  end
  
  context "simple word" do
    before(:each) do
      @word = MarkovWord.new("TEST", :begin)
    end

    it "should have a lower case identifier" do
      @word.identifier.should == "test"
    end

    it "should say that it is proper" do
      @word.proper?.should == true
    end

    it "should say that it can be all caps" do
      @word.shoutable?.should == true
    end

    it "should not yet be speakable" do
      @word.speakable?.should == false
    end
    
    it "should have a shout count of one" do
      @word.shout_count.should == 1
    end
    
    it "should have a speak count of zero" do
      @word.speak_count.should == 0
    end

    it_should_behave_like "a word that hasn't had any children added"
    it_should_behave_like "a word that hasn't had any parents added"
    
    it "should show that it has a count of one" do
      @word.count.should == 1
    end
    
    context "on adding some capitalized parent instances" do
      before(:each) do
        @parents = [:begin, "a", "the"]
        @added_words = [ [:begin, "Test"],["a", "TEST"],["the","Test"] ]
        @added_words.each { |word_pair| @word.add_parent(*word_pair) }
      end
      
      it "should show a count of four" do
        @word.count.should == 4
      end
      
      it "should be speakable" do
        @word.speakable?.should == true
      end
      
      it "should be proper" do
        @word.proper?.should == true
      end
      
      it "should have three parents" do
        @word.num_parents.should == 3
      end
      
      it "should have a parents count of 4" do
        @word.parents_count.should == 4
      end
      
      it "should have a shout count of 2" do
        @word.shout_count.should == 2
      end
      
      it "should have a speak count of 2" do
        @word.speak_count.should == 2
      end
      
      it "should be able to get one of its parents" do
        @parents.include?(@word.get_random_parent).should == true
      end
      
      it "should get all of its parents eventually" do
        results = (1..30).collect { |throw_away| @word.get_random_parent }
        results.uniq.sort{ |a,b| a.to_s <=> b.to_s }.should == @parents.sort{ |a,b| a.to_s <=> b.to_s }
      end
      
      it_should_behave_like "a word that hasn't had any children added"
    end
    
    context "on adding some uncapitalized children instances" do
      before(:each) do
        @children = ["eats", "sucks", "blows"]
        @added_words = [ ["Test", "eats"],["TEST", "sucks"],["test","blows"] ]
        @children.each { |child| @word.add_child(child) }
      end

      it "should show a count of four" do
        @word.count.should == 1
      end

      it "should have three children" do
        @word.num_children.should == 3
      end

      it "should have a children count of 3" do
        @word.children_count.should == 3
      end

      it "should have a shout count of 1" do
        @word.shout_count.should == 1
      end

      it "should have a speak count of 0" do
        @word.speak_count.should == 0
      end

      it "should be able to get one of its children" do
        @children.include?(@word.get_random_child).should == true
      end

      it "should get all of its children eventually" do
        results = (1..30).collect { |throw_away| @word.get_random_child }
        results.uniq.sort{ |a,b| a.to_s <=> b.to_s }.should == @children.sort{ |a,b| a.to_s <=> b.to_s }
      end

      it_should_behave_like "a word that hasn't had any parents added"
    end
    
    context "on adding a terminating child" do
      before(:each) do
        @word.add_child
      end
      
      it "should have a count of two" do
        @word.count.should == 1
      end
      
      it "should show that it terminates" do
        @word.terminates?.should == true
      end
    end
    
    context "on creating punctuation words" do
      before(:each) do
        @words = [".",",",":",";","!","?"].collect{ |word| MarkovWord.new(word, :begin) }
      end
      
      it "each word should be punctuation" do
        @words.each { |word| word.punctuation?.should == true  }
      end
    end
    
    context "on creating non-punctuation words" do
      before(:each) do
        @words = ["this","that","the","other","thing","yay"].collect{ |word| MarkovWord.new(word, :begin) }
      end
      
      it "each word should not be punctuation" do
        @words.each { |word| word.punctuation?.should == false  }
      end
    end
  end
  
  
end
  