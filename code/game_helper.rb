
# This class is probably overkill, but I'm including it here
# to illustrate how you'd define your own class.
class GameHelper 

  # normally, instance variables (those that being with an @)
  # are not accessible outside the object.  Ruby provides helper
  # macros to provide getters and setters.  Here, I'm using 
  # attr_reader to create a getter function.  The format for these
  # kinds of macros is to follow the macro name with a symbol
  # that matches the instance variable name without the @.  
  attr_reader :all_words

  # note that I could also have called attr_writer here to
  # create a setter function for the @all_words instance variable,
  # or I could have called attr_accessor to create both getter
  # and setter at once.  How does all this magic happen?
  # During evaluation of the class, the ruby injects the
  # getter and setter functions into the class definition for you.

  # this is the object constructor...defined as the constructor
  # by virtue of its name, initialize.
  def initialize(fname = '../data/SINGLE.TXT')
    # read in the data
    f = File.open(fname,'r')
    
    # File::readlines will return an array of lines
    @all_words = f.readlines
    # notice how I didn't have to declare the 
    # @all_words variable ahead of assigning it.

    # remove the line returns and such
    @all_words.map!{ |term| term.strip }
    # see how I used map! instead of map...I wanted
    # the mapping to change the object I called it on.

    # remove any words with internal punctuation
    @all_words.delete_if{ |term| 
      term.match(/\W/)
    }
  end

end


# In class, we originally started defining member functions on the
# GameHelper class to search the word lists for operations like
# begins_with and does_not_contain.  That's reasonable, but what that
# design won't support is the chaining of those operations.  For
# example, I might want to find all the 5 letter words that begin
# with 'e' but do not contain 'x'.  But, in order to do that, each of
# those operations will need to take as input the results of the prior
# operation.  While we *could* do that with our GameHelper class,
# it's far simplier to use modify the built-in Array class with our
# own functionality.  
#
# This is why I used attr_reader :all_words in the GameHelper
# class.  That allows me to get at the @all_words instance variable 
# within GameHelper (which is an Array object) so I can call our
# added operators on it directly...which gives me chaining.
#
# To be more specific, by defining these operations on the Array
# class, I can now do this:
# 
#  my_array.with_word_length(5).begins_with('e').does_not_contain('x')
#
class Array

  # filter the words to only those with size = len
  # def with_word_length(len)
  #   self.select{ |term| term.length == len }
  # end

  # filter the words to only those with size = len
  def with_word_length(*len)
    self.select{ |term| 
      len.any?{ |count|
        term.length == count
      }
    }
  end

  # filter the words to only those that start with
  # at least one of the passed-in letters
  def begins_with(*list_of_possible_letters)
    self.select{ |term|
      list_of_possible_letters.any?{ |letter|
        letter == term[0]
      }
    }
  end

  # filter the words to only those that contain
  # at least one of the passed-in letters
  def contains(*list_of_possible_letters)
    self.select{ |term|
      list_of_possible_letters.any?{ |letter|
        term.match(/#{letter}/)
      }
    }
  end

  # filter the words to only those that do not
  # contain any of the passed-in letters
  def does_not_contain(*list_of_possible_letters)
    self.select{ |term|
      list_of_possible_letters.none?{ |letter|
        term.match(/#{letter}/)
      }
    }
  end

  # Syntactic sugar - just offering the existing Array count function
  # under a name that makes more sense for our use case.  
  # There's another way to do this, btw. Look up how Ruby supports aliasing.  
  def word_count
    self.count
  end

  def char_count_less_than(char, count)
    self.select{ |term|
      term.scan(/#{char}/).count < count 
    }
  end

  def does_not_end_with(*list_of_possible_letters)
    self.select{ |term|
      list_of_possible_letters.any?{ |letter|
        letter != term[-1]
      }
    }
  end

end

# Here's another example of adding functionality to an existing
# class definition.  We'll crack open the String class and add
# our own contains_count function to it.
class String
  # how many times does the passed-in char occur
  # in the string?
  def contains_count(char)
  end
end


gh = GameHelper.new
# puts gh.words_of_length(5)
# puts gh.all_words.does_not_contain('a','e','i','o')
#puts gh.all_words.char_count_less_than('e',2)
puts gh.all_words.with_word_length(4,5).contains('y').does_not_end_with('y')


# find all 5-letter words that begin with 'e' but have no
# more 'e' letters in them nor have an 'x' or 'y' in them
