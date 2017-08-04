require 'byebug'
class Maze
  attr_reader :start_pos, :end_pos, :board

  def self.get_maze(maze_file_name)
    result = File.readlines(maze_file_name)
      .map do |row|
        row.chomp.chars
      end
  end

  def initialize(maze_file_name = 'maze.txt')
    @board = Maze.get_maze(maze_file_name)
    @start_pos = find_start_position
    @end_pos = find_end_position
  end

  def find_start_position
    find_position('S')
  end

  def find_end_position
    find_position('E')
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @board[row][col] = val
  end

  def render
    @board.each do |row|
      puts row.join
    end
  end

  def add_path(path)
    path.each {|pos| self[pos] = 'O'}
  end


  private

  def find_position(char)
    @board.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        if @board[row_idx][col_idx] == char
          return [row_idx, col_idx]
        end
      end
    end
    nil
  end

end

class MazeSolver

  def initialize(maze=Maze.new)
    @maze = maze
    @all_seen_posz = {}
  end

  def adjacent_posz(pos)
    row, col = pos
    result = []

    result << [row.pred, col] if row.pred >= 0 # up
    result << [row, col.pred] if col.pred >= 0 # left
    result << [row.next, col] if @maze.board[row.next] #down
    result << [row, col.next] if @maze.board[0][col.next] # right

    result.select do |pos|
      [' ', 'E'].include?(@maze[pos])
    end
  end

  def run
    target = @maze.end_pos

    @current_posz = [@maze.start_pos]
    @all_seen_posz = {@maze.start_pos => nil}

    until @current_posz.empty? || @all_seen_posz.include?(target)
      explore_current_posz
    end

    path = build_path(target)
    if path.empty?
      "Can't find a path!"
    else
      @maze.add_path(path)
      @maze.render
    end
  end

  def explore_current_posz
    new_current_posz = []
    @current_posz.each do |current_pos|
      adjacent_posz(current_pos).each do |adjacent_pos|
        next if @all_seen_posz.include?(adjacent_pos)
        new_current_posz << adjacent_pos
        @all_seen_posz[adjacent_pos] = current_pos
      end
    end
    # debugger
    new_current_posz.each {|new_current| puts "#{new_current} < #{@all_seen_posz[new_current]}"}
    puts "---"
    @current_posz = new_current_posz.dup
  end

  def build_path(target)
    path = []
    until target.nil?
      path << target
      target = @all_seen_posz[target]
    end
    path.reverse
  end
end


if __FILE__ == $0
  maze = MazeSolver.new
  maze.run
end
