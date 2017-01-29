require_relative './game_helper'
require 'minitest/autorun'

class GameHelperTest < Minitest::Test
  
  def setup
    @gh = GameHelper.new
  end

  def test_that_file_is_loaded
    assert_operator @gh.all_words.word_count, :==, 351089
  end

  def test_length_is_respected
    assert_operator @gh.all_words.with_word_length(5).count, :==, 14847
  end

  def test_begins_with
    letters = ['f','g','i']
    selected_terms = @gh.all_words.begins_with(letters)
    # verify every selected_term begins with a member of letters
    selected_terms.each{ |term|
      assert_operator letters, :include?, term[0]
    }
  end

  def test_contains
    letters = ['f','g','i']
    selected_terms = @gh.all_words.contains(letters)
    # verify every selected_term contains at least one member of letters
    selected_terms.each{ |term|
      assert term.match(/[#{letters.join}]/), "#{term} does not contain #{letters.join(',')}"
    }
  end

  # def test_does_not_contain
  #   letters = ['x','y','z']
  #   selected_terms = @gh.all_words.does_not_contain(letters)
  #   # verify every selected_term contains none of letters
  #   selected_terms.each{ |term|
  #     assert term.match(/\A[^#{letters.join}]\z/), "#{term} contains #{letters.join(',')}"
  #   }
  # end

  def test_case_1
    terms = @gh.all_words.with_word_length(5).begins_with('e').does_not_contain('x')
    assert terms.all?{ |term| term.size == 5 && term.match(/\Ae[^x]{4}\z/) }
  end

  def test_case_2
    terms = @gh.all_words.with_word_length(6).begins_with('e','a').does_not_contain('y','i')
    assert terms.all?{ |term| term.size == 6 && term.match(/\A[ea][^iy]{5}\z/) }
  end 

  # def test_case_3
  #   terms = @gh.all_words.with_word_length(6).begins_with('e').char_count_less_than('e',2).does_not_contain('y')
  #   assert terms.all?{ |term| term_size == 6 && term.match(/\Ae[^ey]{5}\z/)}
  # end

  # def test_case_4
  #   terms = @gh.all_words.with_word_length(4,5).contain('y').does_not_end_with('y')
  #   assert terms.all?{ |term| [4,5].include?(term.size) && term.match(/y/) && term.match(/[^y]\z/) }
  # end

end
