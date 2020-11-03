note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do

			max_player_moves := 0
			max_projectile_move:=0
			success_state:=0
			error_state:=0
			is_game_started := false
			cursor:=0
			row_indexes := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'>>
			create projectile_list.make_empty
			create ship_location.default_create
			create board.make_filled (create {STRING}.make_empty,0,0)
			create error.make
			create grid_layout.make_empty
			create output_msg.make_empty
			create old_ship_location.default_create
			create history.make_empty
			create location.make_empty
			ship_location.compare_objects
			old_ship_location.compare_objects
		end
feature --attributes
	is_game_started:BOOLEAN
	max_player_moves : INTEGER_32
	max_projectile_move : INTEGER_32
	success_state :INTEGER_32
	error_state :INTEGER_32
	grid_layout:STRING
	output_msg: STRING
	board : ARRAY2[STRING]
	row_indexes : ARRAY[CHARACTER]
	projectile_list: ARRAY[TUPLE[row:INTEGER_32;column:INTEGER_32]]
	ship_location : TUPLE[row:INTEGER_32;column:INTEGER_32]
	old_ship_location : TUPLE[row:INTEGER_32; column:INTEGER_32]
	error:ERROR_MSG
	history : ARRAY[COMMANDS]
	location: ARRAY[TUPLE[old_l:TUPLE[row:INTEGER_32;column:INTEGER_32];curr:TUPLE[row:INTEGER_32;column:INTEGER_32]]]
	cursor : INTEGER_32


feature -- model operations

	reset
		do
			make
		end

	add_locations(location_tuple : TUPLE[old_l:TUPLE[row:INTEGER_32;column:INTEGER_32];curr:TUPLE[row:INTEGER_32;column:INTEGER_32]])
		do
			location.force (location_tuple, location.count+1)
		end
	decrease_success_state
		do
			success_state := success_state - 1
		end

	add_command (c:COMMANDS)
		do
			history.force (c, history.count + 1)
			cursor := cursor + 1
		end
	increment_cursor
		do
			cursor := cursor + 1
		end
	decrement_cursor
		do
			cursor := cursor - 1

		end

	set_output_error_msg_state
		do
			output_msg := "  state:"+success_state.out +"."+error_state.out+", error"
		end
	set_output_success_msg_state
		do
			output_msg:="  state:"+success_state.out +"."+error_state.out+", ok"
		end

	update_success_state
		do
			success_state := success_state + 1
		end
	update_error_state
		do
			error_state := error_state + 1
		end

	decrease_projectile_location
		do
			if projectile_list.count > 0 then
				across 1 |..| projectile_list.count as pl
				loop
					projectile_list[pl.item].column := projectile_list[pl.item].column - max_projectile_move
					if is_game_started then
						is_projectile_collided
					end
				end
			end
		end

	update_projectile_location
		do
			if projectile_list.count > 0 then
				across 1 |..| projectile_list.count as pl
				loop
					projectile_list[pl.item].column := projectile_list[pl.item].column + max_projectile_move
					if is_game_started then
						is_projectile_collided
					end
				end
			end
		end
	display_projectile_location
		do
			if projectile_list.count > 0 then
			across 1 |..| projectile_list.count as pl
				loop

					if projectile_list[pl.item].column - 1 = ship_location.column and projectile_list[pl.item].row = ship_location.row then
						output_msg.append ("%N"+"  The Starfighter fires a projectile at: "+"["+row_indexes.item (ship_location.row).out+","+ship_location.column.out+"]")
					else
						if  (projectile_list[pl.item].column > board.width) then
							if (projectile_list[pl.item].column - max_projectile_move) < board.width then
							output_msg.append ("%N"+"  A projectile moves: "+"["+row_indexes.item (projectile_list[pl.item].row).out+","+(projectile_list[pl.item].column - max_projectile_move).out+"] -> "+"out of the board")
						end
						else
							output_msg.append ("%N"+"  A projectile moves: "+"["+row_indexes.item (projectile_list[pl.item].row).out+","+(projectile_list[pl.item].column - max_projectile_move).out+"] -> "+"["+row_indexes.item (projectile_list[pl.item].row).out+","+projectile_list[pl.item].column.out+"]")
						end
					end
				end
			end
		end
	is_ship_collided
		do
			across 1 |..| projectile_list.count as pl
				loop
					if (projectile_list[pl.item].row = ship_location.row) and (projectile_list[pl.item].column = ship_location.column) then
						is_game_started := false
						output_msg.append ("%N"+"  The Starfighter moves and collides with a projectile: "+"["+row_indexes.item (old_ship_location.row).out+","+old_ship_location.column.out+"]"+" -> "+"["+row_indexes.item (ship_location.row).out+","+ship_location.column.out+"]")
						make_board
						output_msg.append (grid_layout)
						output_msg.append ("%N"+"  The game is over. Better luck next time!")
					end
				end

		end
	is_projectile_collided
		do
			across 1 |..| projectile_list.count as pl
				loop
					if (projectile_list[pl.item].row = ship_location.row) and (projectile_list[pl.item].column = ship_location.column) and is_game_started then
						is_game_started := false
						output_msg.append ("%N"+"  A projectile moves and collides with the Startfighter: "+"["+row_indexes.item (projectile_list[pl.item].row).out+","+(projectile_list[pl.item].column - max_projectile_move).out+"] -> "+"["+row_indexes.item (projectile_list[pl.item].row).out+","+projectile_list[pl.item].column.out+"]")
						make_board
						output_msg.append (grid_layout)
						output_msg.append ("%N"+"  The game is over. Better luck next time!")
					end
				end

		end





-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	make_board
		local
			fi: FORMAT_INTEGER
		do
			create fi.make (2)
			grid_layout := ""
			across 1 |..| board.height as r
			loop
				across 1 |..| board.width as c
				loop
					if(ship_location.row ~ r.item and ship_location.column ~ c.item) then
							board.put ("S",r.item,c.item)
					else
							board.put ("_",r.item,c.item)
					end
				end
			end


			if(projectile_list.count > 0)
			then
				across 1 |..| projectile_list.count as pl
				loop
					if projectile_list[pl.item].row <= board.height and projectile_list[pl.item].column <= board.width
					then
						if (projectile_list[pl.item].row = ship_location.row) and (projectile_list[pl.item].column = ship_location.column)  then
							board.put ("X", projectile_list[pl.item].row,projectile_list[pl.item].column)
						else

							board.put ("*", projectile_list[pl.item].row,projectile_list[pl.item].column)
						end

					end
				end
			end


			grid_layout.append("%N")
			grid_layout.append ("      ")
			across 1 |..| board.width as i
			loop
				if (i.item + 1) = board.width  then
					grid_layout.append("" +  (i.item).out+" ")
				elseif (i.item ) = board.width then
					grid_layout.append("" +  (i.item).out+"")
				else
					grid_layout.append("" +  (i.item).out+"  ")
				end

			end
			across 1 |..| board.height as r
			loop
				grid_layout.append ("%N    "+ row_indexes[r.item].out)
				grid_layout.append (" ")
				across 1 |..| board.width as c
				loop
					grid_layout.append (board.item (r.item, c.item))
					if c.item < board.width then
						grid_layout.append ("  ")

					end
				end
			end
		end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	play(row:INTEGER_32;column:INTEGER_32; player_mov: INTEGER_32 ; project_mov: INTEGER_32)
		local
			s_row:REAL_64
		do
			is_game_started:=true
			s_row := row/2
			ship_location.row := s_row.ceiling
			ship_location.column := 1
			create board.make_filled ("",row,column)
			create projectile_list.make_empty
			max_player_moves := player_mov
			max_projectile_move := project_mov
			make_board
			update_success_state
			error_state:=0
			set_output_success_msg_state
			old_ship_location.row := ship_location.row
			old_ship_location.column := ship_location.column
		end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		

	move(row:INTEGER_32;column:INTEGER_32)
	local
		k:INTEGER_32
		j:INTEGER_32

		do
			update_projectile_location
			old_ship_location.column := ship_location.column
			old_ship_location.row := ship_location.row
			history.remove_tail (history.count - cursor)
			if ship_location.row < row and is_game_started then
				from
					j:= ship_location.row
				until
					j > row
				loop

					if is_game_started then
						ship_location := [j,ship_location.column]
						is_ship_collided
					end

					j:=j+1
				end

			end

				-- move up in same column
				if ship_location.row > row and is_game_started then
					from
						j := ship_location.row
					until
						j < row
					loop
					if is_game_started then

							ship_location := [j  , ship_location.column]
							is_ship_collided

						end

						j := j - 1
					end
				end

				-- move right in same row
				if ship_location.column < column and is_game_started then
					across
						(ship_location.column + 1) |..| (column)   is index
					loop

							if is_game_started then
							ship_location := [ship_location.row, index+1]
							is_ship_collided
							end


					end
				end


				-- move left in same row
				if ship_location.column >  column and is_game_started then
					from
						k := ship_location.column - 1
					until
						k < column
					loop
							if is_game_started then
								ship_location := [ship_location.row, k]
								is_ship_collided
							end


						k := k - 1
					end
				end

			error_state:=0
			update_success_state
			set_output_success_msg_state
			display_projectile_location
			is_ship_collided
			if is_game_started then
				make_board
				add_locations ([old_ship_location,ship_location])
				output_msg.append ("%N"+"  The Starfighter moves: "+"["+row_indexes.item (old_ship_location.row).out+","+old_ship_location.column.out+"]"+" -> "+"["+row_indexes.item (ship_location.row).out+","+ship_location.column.out+"]")
			end


		end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fire
		local
			projectile_location :TUPLE[row:INTEGER_32;column:INTEGER_32]
		do
			update_projectile_location
			is_projectile_collided
			if is_game_started then

			create projectile_location.default_create
			projectile_location.row := ship_location.row
			projectile_location.column := ship_location.column + 1
			update_success_state
			set_output_success_msg_state
			if is_game_started then
				display_projectile_location
			end


			projectile_list.force (projectile_location, projectile_list.count+1)
			make_board
			location.force ([old_ship_location,ship_location], location.count+1)
			end
			error_state := 0


			if is_game_started then

				output_msg.append ("%N"+"  The Starfighter fires a projectile at: "+"["+row_indexes.item (ship_location.row).out+","+ship_location.column.out+"]")
			end
		end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	pass
		do
			update_success_state
			set_output_success_msg_state
			update_projectile_location
			is_projectile_collided
			if is_game_started then
				location.force ([ship_location,ship_location],location.count+1)
				make_board
				display_projectile_location
				output_msg.append ("%N"+"  The Starfighter stays at: "+"["+row_indexes.item (ship_location.row).out+","+ship_location.column.out+"]")
			end
			error_state:=0


		end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
abort
		do
			cursor:=0
			location.make_empty
			history.make_empty
			error_state:=0
			update_success_state
			set_output_success_msg_state
			is_game_started:=false
			output_msg.append("%N"+"  Game has been exited.")
		end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
	output : STRING
		do
			create Result.make_empty
			if(error_state > 0) then
				Result.append (output_msg)
			else
				Result.append (output_msg)
				if is_game_started then
					Result.append (grid_layout)
				end
			end
		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("")
			if(success_state = 0 and error_state = 0)
			then
				Result := "  Welcome to Space Defender Version 1."
			else
				Result.append(output)
			end

		end

end
