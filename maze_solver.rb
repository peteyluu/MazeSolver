class Move
  attr_accessor :x, :y, :distance

  def initialize(x, y, distance)
    @x = x
    @y = y
    @distance = distance
  end

  def <=>(other)
    @distance <=> other.distance
  end
end

class Maze
  DELTAS = [[-1, 0], [0, 1], [1, 0], [0, -1]]

  def initialize
    @maze = parse_file("maze2.txt")
    @end_coord = find_target('E')
    start_coord = find_target('S')
    move = move_with_coord(start_coord)
    @queue = [move]
    @path = []
    @seen = []

    run
  end

  def run
    until @queue.empty?
      current_move = @queue.shift
      coord = [current_move.x, current_move.y]
      @seen << coord
      @path << coord

      break if at_end?(coord)
      generate_moves(coord)
      p @queue
    end
  end

  def move_with_coord(coord)
    x1, y1 = coord
    x2, y2 = @end_coord
    x3 = (x1 - x2).abs
    y3 = (y1 - y2).abs
    distance = Math.sqrt((x3 * x3) + (y3 * y3))
    Move.new(x1, y1, distance)
  end

  def generate_moves(coord)
    DELTAS.each do |delta|
      new_coord = [coord[0] + delta[0], coord[1] + delta[1]]
      if !is_wall?(new_coord) && !@seen.include?(new_coord)
        new_move = move_with_coord(new_coord)
        @queue << new_move
      end
    end
    @queue.sort!
  end

  def is_wall?(coord)
    x, y = coord
    @maze[y][x] == '*'
  end

  def at_end?(coord)
    x, y, z = coord
    # i, j, k = @end_coord
    [x, y] == @end_coord
  end

  def find_target(target)
    @maze.each_with_index do |row, row_i|
      row.each_with_index do |col, col_i|
        return [row_i, col_i] if @maze[row_i][col_i] == target
      end
    end
  end

  def print_maze
    @maze.each do |row|
      puts row.join(" ")
    end
  end

  def parse_file(filename)
    maze = []
    File.open(filename).each_line do |line|
      maze << line.chars
    end
    maze
  end
end

m = Maze.new
