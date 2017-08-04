require_relative 'card.rb'
require 'byebug'

class Board
  attr_reader :grid
  CARD_VALUES = ('a'..'z').to_a

  def initialize(size=4) #SIZE MUST BE EVEN
    @grid = Array.new(size) { Array.new(size) }
  end

  def [](pos)
    row,col = pos
    @grid[row][col]
  end

  def []=(pos,value)
    row ,col = pos
    @grid[row][col] = value
  end

  def populate
    num_uniq_cards = @grid.length**2 / 2
    card_list = Array.new(num_uniq_cards)
    card_list += card_list
    card_list.map!.with_index { |el,idx| Card.new(CARD_VALUES[idx%num_uniq_cards]) }
    card_list.shuffle!
    @grid.each_with_index do |row, idx|
      row.each_index do |jdx|
        @grid[idx][jdx] = card_list.pop
      end
    end
  end

  def render
    dim = @grid.length
    first_row = "   |"
    divider = "----"
    i = 0
    while i < dim
      first_row += " #{i} |"
      divider += "----"
      i+=1
    end
    puts first_row
    puts divider
    current_row = ""
    @grid.each_with_index do |row, idx|
      current_row += " #{idx} |"
      row.each_index do |jdx|
        current_card = @grid[idx][jdx]
        current_symbol = ""
        if current_card.paired
          current_symbol = " "
        else
          if current_card.face_up
            current_symbol = current_card.face_value.to_s
          else
            current_symbol = "X"
          end
        end
        current_row += " #{current_symbol} |"
      end
      puts current_row
      puts divider
      current_row=""
    end
    puts ""
    puts ""
  end

  def won?
    status = true
    @grid.each_index do |idx|
      status &&= @grid[idx].all? { |card| card.paired }
    end
    status
  end

  def reveal(guessed_pos)
    row,col = guessed_pos
    @grid[row][col].reveal
  end

  def hide(guessed_pos)
    row,col = guessed_pos
    @grid[row][col].hide
  end

  def set_paired(guessed_pos)
    row,col = guessed_pos
    @grid[row][col].set_paired
  end
end
