module GameOfLife

	def self.get_cells(generation)
		generation.split("\n")
							.map { |x| x.split('')
													.map { |x| x == '.' ? 0 : 1 } 
							}
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
		neighbours.count(1)
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

	def self.evolve_cell(is_alive, live_neighbour_count)

		if live_neighbour_count == 3 || (is_alive == 1 && live_neighbour_count == 2)
			return 1
		end
		return 0
	end

	def self.get_formatted_row(row)
		row.map { |cell| cell == 1 ? '*' : '.' }.join << "\n"
	end

	def self.evolve(generation)

		# change the string into an array representing the rows, each of which 
		# contains an array of ones and/or zeros representing the cells		
		cells = get_cells(generation)
		next_generation = ''

		# iterate over each row
		cells.each_with_index do |row, row_index|

			# create the new row
			new_row = []
			row.each_with_index do |cell, cell_index| 
				live_neighbour_count = get_live_neighbour_count(cells, row_index, cell_index)
				new_row << evolve_cell(cell, live_neighbour_count)
			end

			# add the string representing of the row to the next generation
			next_generation << get_formatted_row(new_row)
		end
		next_generation
	end
end