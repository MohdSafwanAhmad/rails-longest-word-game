require 'open-uri'
class GamesController < ApplicationController

  def new
    @letters = []
    @letters += Array.new(15) { (('A'..'Z').to_a).sample }
    @letters.shuffle!
  end


  def score
    @letters = params[:letters].split(',')
    @guess = params[:new]

    if word_success?(@guess, @letters)
      @score = @guess.chars.count
      @message = "Well Done"
    elsif word_valid?(@guess) && !word_in_grid?(@guess, @letters)
      @score = 0
      @message = "Word you entered is not in the grid" 
    else
      @score = 0
      @message = "Word you entered is not an english word.."
    end
  end

  private

def word_valid?(guess)
  url = "https://dictionary.lewagon.com/#{guess}"
  user_serialized = URI.parse(url).read
  dictionary = JSON.parse(user_serialized)
  return dictionary["found"]
end

def word_in_grid?(guess, grid)
  letters_copy = grid.clone
  guess.upcase.chars.each do |letter|
    if letters_copy.include?(letter)
      letters_copy.delete_at(letters_copy.index(letter))
    else
      return false
    end
  end
  return true
end

def word_success?(guess, grid)
  word_in_grid?(guess, grid) && word_valid?(guess)
end


end
