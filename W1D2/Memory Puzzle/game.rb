require_relative 'card.rb'
require_relative 'board.rb'
require_relative 'player.rb'

class Game

  attr_reader :board, :player, :size

  def initialize(size = 4, player)
    @board = Board.new(size)
    @board.populate
    @player = player
    @size = size
  end

  def play
    until @board.won?
      play_round
    end
    @board.render;
    puts "Good job!!"

  end

  def play_round
    @board.render;
    guess_one = @player.guess(@size);
    @board.reveal(guess_one);
    @player.receive_revealed_card(guess_one, @board[guess_one].face_value)
    @board.render;
    guess_two = @player.guess(@size);
    @board.reveal(guess_two);
    @player.receive_revealed_card(guess_two, @board[guess_two].face_value)
    @board.render;
    if @board[guess_one]==@board[guess_two]
      @board.set_paired(guess_one)
      @board.set_paired(guess_two)
      @player.receive_match(guess_one, guess_two)
    else
      @board.hide(guess_one)
      @board.hide(guess_two)
    end
  end
end
