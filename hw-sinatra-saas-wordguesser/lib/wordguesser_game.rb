class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  attr_accessor :word, :guesses, :wrong_guesses

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end

  def guess(attempt)
    if !(attempt.instance_of?(String) and attempt =~ /\A[a-zA-Z]\z/)
      raise ArgumentError, "Invalid Input"
    end
    attempt.downcase!
    if @word.include?(attempt)
      if !@guesses.include?(attempt)
        @guesses = @guesses + attempt
        return true
      else
        return false
      end
    else
      if !@wrong_guesses.include?(attempt)
        @wrong_guesses = @wrong_guesses + attempt
        return true
      else
        return false
      end
      
    end
  end

  def check_win_or_lose()
    if @word == word_with_guesses()
      return :win
    elsif @wrong_guesses.length < 7
      return :play
    else
      return :lose
    end
  end

  def word_with_guesses()
    string_in_progress = ''
    @word.each_char do |item|
      if @guesses.include?(item)
        string_in_progress += item
      else
        string_in_progress += '-'
      end
    end
    return string_in_progress
  end

end
