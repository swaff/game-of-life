module GameOfLife

  def self.get_cells(generation)
    generation.split("\n")
  end

  def self.get_row_neighbours(row, cell_index, ignore_cell_index = false)
      
    return 0 if row.nil?

    neighbours = []

    # add to the left if possible
    neighbours.push(row[cell_index -1]) if cell_index > 0

    # add the cell at cell_index if required
    neighbours.push(row[cell_index]) unless ignore_cell_index
    
    # add the cell to the right if possible
    neighbours.push(row[cell_index + 1]) if cell_index < row.length

    # return the number of ones in the array
    neighbours.count('*')
  end


  def self.get_live_neighbour_count(generation, row_index, cell_index)
    
    # get the row above, the current row and the row below
    previous_row = row_index > 0 ? generation[row_index.pred] : nil;
    this_row = generation[row_index]
    next_row = row_index < generation.length - 1 ? generation[row_index.next] : nil

    # get the number of live cells in the rows and return the total
    [].push(get_row_neighbours(previous_row, cell_index))
      .push(get_row_neighbours(this_row, cell_index, true))
      .push(get_row_neighbours(next_row, cell_index))
      .reduce(:+)
  end

  def self.evolve_cell(cell, live_neighbour_count)
    live_neighbour_count == 3 || (cell == '*' && live_neighbour_count == 2) ? '*' : '.'
  end

  def self.evolve(generation)

    # change the string into an array representing the rows, each of which 
    # contains an string of '*' and/or '.' representing the cells    
    cells = get_cells(generation)
    next_generation = ''

    # iterate over each row
    cells.each_with_index do |row, row_index|

      # create the new row
      new_row = row.split('')
                    .each_with_index
                    .map do |cell, cell_index| 

        evolve_cell(cell, get_live_neighbour_count(cells, row_index, cell_index))
      end

      # add the string representing the row to the next generation
      next_generation << "#{new_row.join}\n"
    end
    return next_generation
  end
end