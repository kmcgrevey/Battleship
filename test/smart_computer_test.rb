require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/computer_player'
require_relative '../lib/human_player'
require_relative '../lib/smart_computer'
require_relative '../lib/ship'
require_relative '../lib/board'

class SmartComputerTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    ships = [@cruiser, @submarine]
    board = Board.new
    @smart_cpu = SmartComputer.new(board, ships)
  end

  def test_board
    @smart_cpu.opponent_board.place(@cruiser, ["B2", "C2", "D2"])
    @smart_cpu.opponent_board.place(@submarine, ["C1", "D1"])
    @smart_cpu.opponent_board.cells["C2"].fire_upon
    @smart_cpu.opponent_board.cells["C3"].fire_upon
    @smart_cpu.opponent_board.cells["C1"].fire_upon
    possibilities = ["B1", "B2", "D1", "D2"]

    assert possibilities.include?(@smart_cpu.send_fire)
  end

  # def test_it
  #   @smart_cpu.opponent_board.cells["A1"].fire_upon
  #   @smart_cpu.opponent_board.cells["B1"].fire_upon
  #   @smart_cpu.opponent_board.cells["B3"].fire_upon
  #   @smart_cpu.opponent_board.cells["D4"].fire_upon
  #   @smart_cpu.opponent_board.cells["C1"].fire_upon
  #   @smart_cpu.opponent_board.cells["D2"].fire_upon
  #   @smart_cpu.opponent_board.cells["B2"].fire_upon
  #   @smart_cpu.opponent_board.cells["A2"].fire_upon
  #   @smart_cpu.opponent_board.cells["A4"].fire_upon
  #
  #
  #   @smart_cpu.generate_valid_guesses
  # end
  #
  # def test_count_hits
  #   @smart_cpu.opponent_board.place(@cruiser, ["A1", "A2", "A3"])
  #   @smart_cpu.opponent_board.cells["A1"].fire_upon
  #   @smart_cpu.opponent_board.cells["A2"].fire_upon
  #   actual = @smart_cpu.count_hits(["A1", "A2", "A3"])
  #   expected = 2
  #
  #   assert_equal expected, actual
  #
  #   @smart_cpu.find_groups_with_most_hits
  #   @smart_cpu.suggest_coordinate
  # end

end
