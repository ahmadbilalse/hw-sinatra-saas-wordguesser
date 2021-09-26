class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = word.chars.map { |letter| '-' }.join()
  end

  def valid_letter?(letter)
    if letter.nil? or letter.empty? or letter =~ /[^A-Za-z]/
      raise ArgumentError.new
    end
  end

  def fill_word_with_guesses(letter)
    @word.chars.each_with_index do |element, index|
      if element == letter
        @word_with_guesses[index] = element
      end
    end
  end

  def guess(letter)
    valid_letter?(letter)
    letter = letter.downcase
    if @word.include? letter and !@guesses.include? letter
      @guesses += letter
      fill_word_with_guesses(letter)
      return true
    elsif !@word.include? letter and !@wrong_guesses.include? letter
      @wrong_guesses += letter
      return true
    end
    return false
  end

  def check_win_or_lose
    if !@word_with_guesses.include? '-'
      return :win
    end
    if (@guesses.length + @wrong_guesses.length) >= 7
      return :lose
    end
    return :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
