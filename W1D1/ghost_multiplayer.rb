class Game
  attr_reader :fragment, :players, :active_players, :current_player, :dictionary, :candidate_words
  def initialize(players, dictionary="dictionary.txt")
    @fragment=""
    @players = players
    @active_players = @players.map { |player| player.name }
    @current_player = players[0]
    @loss_hash = Hash.new(0)
    if dictionary == "dictionary.txt"
      @dictionary = File.readlines('dictionary.txt').map { |line| line[0..-2] }
    else
      @dictionary = dictionary
    end
    @candidate_words = @dictionary
  end

  def play
    until game_over?
      play_round
    end
  end

  def game_over?
    @active_players.length==1
  end

  def display_records
    ghost = "GHOST"
    @players.each { |player| puts "#{player.name}: #{ghost[0...@loss_hash[player.name]]}" }
  end

  def play_round
    until round_over?
      puts "Your fragment is #{@fragment}"
      play_turn
    end
    #puts "Congratulations, #{@current_player.name}, you win this round!"
    unswitch_players!
    @active_players.delete!(@current_player.name)
    reset
  end

  def reset
    @fragment = ""
    @candidate_words = @dictionary
  end


  def play_turn
    puts "#{@current_player.name}, choose your next letter!"
    @fragment += @current_player.guess
    if valid_fragment?
      @candidate_words = @candidate_words.select { |word| word[0...@fragment.length]==@fragment }
      switch_players!
    else
      @current_player.alert_invalid_guess
      @fragment = @fragment[0..-2]
    end
  end

  def switch_players!
    @current_player = @active_players[(@active_players.find_index(@current_player.name)+1) % @active_players.length]
  end

  def unswitch_players!
    @current_player = @active_players[(@active_players.find_index(@current_player.name)-1) % @active_players.length]
  end

  def round_over?
    @candidate_words.include?(@fragment)
  end

  def valid_fragment?
    !@candidate_words.select { |word| word[0...@fragment.length]==@fragment }.empty?
  end
end

class Player
  attr_accessor :name
  def initialize(name)
    @name = name
  end

  # def guess
  #   input = gets.chomp
  #   while input.length != 1
  #     puts "only one letter! Guess again"
  #     input = gets.chomp
  #   end
  # end

  def guess
    k = false
    until k == true
      input = gets.chomp
      if input.length != 1
        puts "try again!"
      else
        k = true
      end
    end
    input
  end

  def alert_invalid_guess
    puts "bad guess"
  end
end
