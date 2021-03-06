require_relative 'cell'

class Board
  attr_reader :cells, :grid_length

  def initialize(size = 4)
    @cells = {}
    @grid_length = size
    coordinates = generate_nested_coordinates(size).flatten
    generate_cells(coordinates)
  end

  def generate_nested_coordinates(size)
    coordinates = []
    letter_range = ("A"..(64 + size).chr)
    number_range = 1..size
    coordinates = letter_range.map do |letter|
      number_range.map { |number| "#{letter}#{number}" }
    end
    coordinates
  end

  def generate_cells(coordinates)
    coordinates.each do |coordinate|
      @cells[coordinate] = Cell.new(coordinate)
    end
  end

  def valid_coordinate?(coordinate)
    @cells.has_key?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    return false if ship.length != coordinates.length
    return false if !consecutive_coordinates?(coordinates)
    return false if overlap?(coordinates)
    true
  end

  def overlap?(coordinates)
      !(coordinates.all? { |coordinate| @cells[coordinate].empty? })
  end

  def consecutive_coordinates?(coordinates)
    letter_ords = coordinates.map { |coordinate| coordinate[0].ord }
    numbers = coordinates.map do |coordinate|
      coordinate[1..coordinate.length - 1].to_i
    end
    numbers_cons = consecutive_numbers?(numbers)
    numbers_same = same_numbers?(numbers)
    letters_cons = consecutive_numbers?(letter_ords)
    letters_same = same_numbers?(letter_ords)
    (numbers_cons && letters_same)||(numbers_same && letters_cons)
  end

  def consecutive_numbers?(numbers)
    numbers.each_cons(2).all? { |num1, num2| num1 == num2 - 1}
  end

  def same_numbers?(numbers)
    numbers.each_cons(2).all? { |num1, num2| num1 == num2}
  end

  def place(ship, coordinates)
    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

  def render(reveal = false)
    board_string = ""
    nested_coordinates = generate_nested_coordinates(@grid_length)
    board_string << "  " + ([*1..@grid_length].join(' ')) + " \n"
    nested_coordinates.each do |rows|
      board_string << rows[0][0] + " "
      rows.each do |cell|
        board_string << @cells[cell].render(reveal) + " "
      end
      board_string << "\n"
    end
    board_string
  end

end
