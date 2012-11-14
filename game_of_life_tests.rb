require 'test/unit'
require './game_of_life.rb'

class GolTests < Test::Unit::TestCase

  def test_get_cells
    assert_equal([[1]], GameOfLife.get_cells("*"))

    generation = "***\n...\n.*."

    expected = [
      [1, 1, 1],
      [0, 0, 0],
      [0, 1, 0]
    ]
    assert_equal(expected, GameOfLife.get_cells(generation))

    generation = "*****\n.....\n*****\n.....\n*****"
    expected = [
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1]
    ]
    assert_equal(expected, GameOfLife.get_cells(generation))
  end

  def test_get_row_neighbours

    row = nil
    assert_equal(0, GameOfLife.get_row_neighbours(row, 0))

    row = [0]
    assert_equal(0, GameOfLife.get_row_neighbours(row, 0))

    row = [1]
    assert_equal(1, GameOfLife.get_row_neighbours(row, 0))

    row = [1]
    assert_equal(0, GameOfLife.get_row_neighbours(row, 0, true))

    row = [0, 0, 1, 1]
    assert_equal(0, GameOfLife.get_row_neighbours(row, 0, true))
    assert_equal(0, GameOfLife.get_row_neighbours(row, 0, false))
    assert_equal(1, GameOfLife.get_row_neighbours(row, 1, true))
    assert_equal(1, GameOfLife.get_row_neighbours(row, 1, false))
    assert_equal(1, GameOfLife.get_row_neighbours(row, 2, true))
    assert_equal(2, GameOfLife.get_row_neighbours(row, 2, false))
    assert_equal(1, GameOfLife.get_row_neighbours(row, 3, true))
    assert_equal(2, GameOfLife.get_row_neighbours(row, 3, false))
  end

  def test_get_live_neighbour_count__with_one_row

    generation = [[1]]
    assert_equal(0, GameOfLife.get_live_neighbour_count(generation, 0, 0))

    generation = [[1, 1]]
    assert_equal(1, GameOfLife.get_live_neighbour_count(generation, 0, 0))

    generation = [[1, 1]]
    assert_equal(1, GameOfLife.get_live_neighbour_count(generation, 0, 1))

    generation = [[0, 1]]
    assert_equal(1, GameOfLife.get_live_neighbour_count(generation, 0, 0))

    generation = [[1, 0]]
    assert_equal(1, GameOfLife.get_live_neighbour_count(generation, 0, 1))

    generation = [[1, 1, 1]]
    assert_equal(1, GameOfLife.get_live_neighbour_count(generation, 0, 0))
    assert_equal(2, GameOfLife.get_live_neighbour_count(generation, 0, 1))
    assert_equal(1, GameOfLife.get_live_neighbour_count(generation, 0, 2))
  end

  def test_get_live_neighbour_count__with_two_rows
    # two rows now
    generation = [
      [1, 0],
      [1, 1]
    ]

    assert_equal(2, GameOfLife.get_live_neighbour_count(generation, 0, 0))
    assert_equal(3, GameOfLife.get_live_neighbour_count(generation, 0, 1))
    assert_equal(2, GameOfLife.get_live_neighbour_count(generation, 1, 0))
    assert_equal(2, GameOfLife.get_live_neighbour_count(generation, 1, 1))
  end

  def test_get_live_neighbour_count__with_three_rows
    # two rows now
    generation = [
      [1, 0, 1],
      [1, 1, 1],
      [0, 1, 1]
    ]

    assert_equal(2, GameOfLife.get_live_neighbour_count(generation, 0, 0))
    assert_equal(5, GameOfLife.get_live_neighbour_count(generation, 0, 1))
    assert_equal(2, GameOfLife.get_live_neighbour_count(generation, 0, 2))
    assert_equal(3, GameOfLife.get_live_neighbour_count(generation, 1, 0))
    assert_equal(6, GameOfLife.get_live_neighbour_count(generation, 1, 1))
    assert_equal(4, GameOfLife.get_live_neighbour_count(generation, 1, 2))
    assert_equal(3, GameOfLife.get_live_neighbour_count(generation, 2, 0))
    assert_equal(4, GameOfLife.get_live_neighbour_count(generation, 2, 1))
    assert_equal(3, GameOfLife.get_live_neighbour_count(generation, 2, 2))
  end

  def test_get_live_neighbour_count__with_four_rows
    # two rows now
    generation = [
      [1, 0, 1, 0],
      [1, 0, 1, 1],
      [1, 1, 1, 0],
      [0, 1, 1, 1]
    ]

    assert_equal(1, GameOfLife.get_live_neighbour_count(generation, 0, 0))
    assert_equal(4, GameOfLife.get_live_neighbour_count(generation, 0, 1))
    assert_equal(2, GameOfLife.get_live_neighbour_count(generation, 0, 2))
    assert_equal(3, GameOfLife.get_live_neighbour_count(generation, 0, 3))
    assert_equal(3, GameOfLife.get_live_neighbour_count(generation, 1, 0))
    assert_equal(7, GameOfLife.get_live_neighbour_count(generation, 1, 1))
    assert_equal(4, GameOfLife.get_live_neighbour_count(generation, 1, 2))
    assert_equal(3, GameOfLife.get_live_neighbour_count(generation, 1, 3))
    assert_equal(3, GameOfLife.get_live_neighbour_count(generation, 2, 0))
    assert_equal(6, GameOfLife.get_live_neighbour_count(generation, 2, 1))
    assert_equal(6, GameOfLife.get_live_neighbour_count(generation, 2, 2))
    assert_equal(5, GameOfLife.get_live_neighbour_count(generation, 2, 3))
    assert_equal(3, GameOfLife.get_live_neighbour_count(generation, 3, 0))
    assert_equal(4, GameOfLife.get_live_neighbour_count(generation, 3, 1))
    assert_equal(4, GameOfLife.get_live_neighbour_count(generation, 3, 2))
    assert_equal(2, GameOfLife.get_live_neighbour_count(generation, 3, 3))
  end

  def test_evolve_cell__live_cell_with_fewer_than_two_live_neighbours_dies
    assert_equal(0, GameOfLife.evolve_cell(1, 0))
    assert_equal(0, GameOfLife.evolve_cell(1, 1))
  end

  def test_evolve_cell__live_cell_with_two_or_three_live_neighbours_lives_on

    assert_equal(1, GameOfLife.evolve_cell(1, 2))
    assert_equal(1, GameOfLife.evolve_cell(1, 3))
  end

  def test_evolve_cell__live_cell_with_more_than_three_live_neighbours_dies

    4.upto(8) do |neighbour_count|
      assert_equal(0, GameOfLife.evolve_cell(1, neighbour_count))
    end
  end

  def test_evolve_cell__dead_cell_with_exactly_three_live_neighbours_becomes_a_live_cell

    0.upto(2) do |neighbour_count|
      assert_equal(0, GameOfLife.evolve_cell(0, neighbour_count))
    end

    assert_equal(1, GameOfLife.evolve_cell(0, 3))

    4.upto(8) do |neighbour_count|
      assert_equal(0, GameOfLife.evolve_cell(0, neighbour_count))
    end
  end

  def test_get_formatted_row
    row = [0]
    assert_equal(".\n", GameOfLife.get_formatted_row(row))

    row = [1]
    assert_equal("*\n", GameOfLife.get_formatted_row(row))

    row = [1, 0]
    assert_equal("*.\n", GameOfLife.get_formatted_row(row))

    row = [1, 0, 1, 1, 1, 0, 0, 1]
    assert_equal("*.***..*\n", GameOfLife.get_formatted_row(row))
  end

  def test_evolve

    second = GameOfLife.evolve(".\n")
    expected = ".\n"
    assert_equal(expected, second)

    second = GameOfLife.evolve(".*\n")
    expected = "..\n"
    assert_equal(expected, second)

    second = GameOfLife.evolve("***\n")
    expected = ".*.\n"
    assert_equal(expected, second)

    # test some blocks
    first = "....\n" +
            ".**.\n" +
            ".**.\n" +
            "....\n"
            
    expected_second = first
    assert_equal(expected_second, GameOfLife.evolve(first))

    first = "......\n" +
            "..**..\n" +
            ".*..*.\n" +
            "..**..\n" +
            "....\n"
            
    expected_second = first
    assert_equal(expected_second, GameOfLife.evolve(first))

    # test some oscillators
    first = ".....\n" +
            ".....\n" +
            ".***.\n" +
            ".....\n" + 
            ".....\n"
            
    expected_second = ".....\n" +
                      "..*..\n" +
                      "..*..\n" +
                      "..*..\n" + 
                      ".....\n"
    assert_equal(expected_second, GameOfLife.evolve(first))

    first = "......\n" +
            ".**...\n" +
            ".*....\n" +
            "....*.\n" + 
            "...**.\n" +
            "......\n"
            
    expected_second = "......\n" +
                      ".**...\n" +
                      ".**...\n" +
                      "...**.\n" + 
                      "...**.\n" +
                      "......\n"
    assert_equal(expected_second, GameOfLife.evolve(first))
  end

  
end