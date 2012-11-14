module GameOfLife

	def self.get_cells(generation)
		generation.split("\n")
							.drop(1)
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


	def self.get_live_neighbour_count(generation, row_index, column_index)
		
		# get the row above, the current row and the row below
		previous_row = row_index > 0 ? generation[row_index.pred] : nil;
		this_row = generation[row_index]
		next_row = row_index < generation.length - 1 ? generation[row_index.next] : nil

		# get the number of live cells in the rows and return the total
		[].push(get_row_neighbours(previous_row, column_index))
			.push(get_row_neighbours(this_row, column_index, true))
			.push(get_row_neighbours(next_row, column_index))
			.reduce(:+)
	end

	def self.evolve_cell(is_alive, live_neighbour_count)

		if live_neighbour_count == 3 || (is_alive == 1 && live_neighbour_count == 2)
			return 1
		end
		return 0
	end
end