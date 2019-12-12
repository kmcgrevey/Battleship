require_relative 'ship'
require_relative 'board'

class ComputerPlayer
  attr_reader :board, :ships, :size

  def initialize(size = 4)
    @board = Board.new(size)
    cruiser = Ship.new("Cruiser", 3)
    destroyer = Ship.new("Destroyer", 2)
    @ships = [cruiser, destroyer]
    @size = size
    @speed = 0.01
  end

  def set_classic
    carrier = Ship.new("Carrier", 5)
    battleship = Ship.new("Battleship", 4)
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 3)
    destroyer = Ship.new("Destroyer", 2)
    @ships = [carrier, battleship, cruiser, submarine, destroyer]
    @size = 10
  end

  def set_custom_board

  end

  def reset
    @board = Board.new(@size)
    refresh_ships
    @coordinate_guesses = @board.cells.keys
  end

  def refresh_ships
    @ships = @ships.map do |ship|
      name = ship.name
      length = ship.length
      ship = Ship.new(name, length)
      ship
    end
  end

  def get_ready
    reset
    initial_instructions
    @ships.each do |ship|
      ship_placement(ship)
    end
  end

  def initial_instructions
    puts "I am laying out my ships..."
    sleep(1.5)
  end

  def ship_placement(ship)
    length = ship.length
    coin_toss = [1,2].sample
    if coin_toss == 1
      computer_array = horizontal_array_maker(ship, length)
    else
      computer_array = vertical_array_maker(ship, length)
    end
    @board.place(ship, computer_array)
  end

  def horizontal_array_maker(ship, length)
    computer_array = []
    while !(computer_array.all?{ |coor| @board.valid_coordinate?(coor)} &&
      @board.valid_placement?(ship, computer_array))
      computer_array = []
      initial_guess = @coordinate_guesses.sample
      computer_array = [initial_guess]
      cell_int = (initial_guess[1..initial_guess.length - 1]).to_i
      (length - 1).times do
        cell_int += 1
        computer_array << initial_guess[0] + cell_int.to_s
      end
    end
    computer_array
  end

  def vertical_array_maker(ship, length)
    computer_array = []
    while !(computer_array.all?{ |coor| @board.valid_coordinate?(coor)} &&
      @board.valid_placement?(ship, computer_array))
      computer_array = []
      initial_guess = @coordinate_guesses.sample
      computer_array = [initial_guess]
      cell_int = initial_guess[1..initial_guess.length - 1]
      cell_letter = (initial_guess[0]).ord
      (length - 1).times do
        cell_letter += 1
        computer_array << cell_letter.chr + cell_int
      end
    end
    computer_array
  end

  def print_board(game_over = false)
    puts "=============COMPUTER BOARD============="
    puts @board.render if !game_over
    puts @board.render(true) if game_over
    puts ""
  end

  def press_enter_to_continue
    print "(press "+ $white_bold + "ENTER" + $color_restore + " to continue...)"
    gets.chomp
  end

  def receive_fire(coordinate)
    @board.cells[coordinate].fire_upon
    print "HUMAN shot at #{coordinate}... "
    sleep(@speed)
  end

  def send_fire
    @coordinate_guesses.delete(@coordinate_guesses.sample)
  end

end
