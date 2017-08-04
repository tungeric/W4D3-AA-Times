
#require_relative 'card.rb'

require 'byebug'

class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def receive_revealed_card(pos, value)
  end

  def receive_match(pos1, pos2)
  end

  def guess(size)
    puts "Make your guess (use X,X format)"
    input = gets.chomp.split(",").map(&:to_i)
  end
end

class ComputerPlayer
  attr_reader :name, :known_cards, :matched_cards, :previous_guess
  def initialize(name)
    @name = name
    @known_cards = Hash.new() { |h,k| h[k]=[] }
    @matched_cards = []
    @previous_guess = []
  end

  def receive_revealed_card(pos, value)
    @known_cards[value] << pos unless @known_cards[value].include?(pos)
  end

  def receive_match(pos1, pos2)
    @matched_cards << pos1
    @matched_cards << pos2
  end

  def guess(size)
    input = []
    #debugger
    if @previous_guess.empty? # if this is your first guess
      @known_cards.values.each do |positions|
        if positions.length == 2
          input = positions.first
        end
      end
      if input.empty?
        input = random_guess(size)
      end
      @previous_guess = input
    else  # if this is your second guess
      @known_cards.values.each do |positions|
        if positions.length == 2
          if positions.include?(@previous_guess)
            #debugger
            positions.delete(@previous_guess)
            input = positions.pop
          end
        end
      end
      if input.empty?
        input = random_guess(size)
      end
      @previous_guess = []
    end
    input
  end

  def random_guess(size)
    idx_array = (0...size).to_a
    possible_guesses = idx_array.permutation(2).to_a
    (0...size).each { |idx| possible_guesses << [idx,idx] }
    possible_guesses.reject! { |pos| @matched_cards.include?(pos) }
    possible_guesses.reject! { |pos| @known_cards.values.include?([pos]) }
    possible_guesses.delete(@previous_guess)
    possible_guesses.shuffle!
    possible_guesses[0]
  end

end
