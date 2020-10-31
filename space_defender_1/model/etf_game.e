note
	description: "Summary description for {ETF_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_GAME
create
	make
feature {NONE}
	make
		do
			max_player_moves := 0
			max_projectile_move:=0
			success_state:=0
			error_state:=0
			is_game_started := false
			row_indexes := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'>>
			create projectile_list.make_empty
			create ship_location.default_create
			create board.make_filled (create {STRING}.make_empty,0,0)
			create error.make
			create grid_layout.make_empty
			create output_msg.make_empty
			create old_ship_location.default_create
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



feature --Operations

	set_output_error_msg_state
		do
			output_msg := " state:"+success_state.out +"."+error_state.out+", error"
		end
	set_output_success_msg_state
		do
			output_msg:=" state:"+success_state.out +"."+error_state.out+", ok"
		end

	update_success_state
		do
			success_state := success_state + 1
		end
	update_error_state
		do
			error_state := error_state + 1
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
					output_msg.append ("%N A projectile moves:"+"["+row_indexes.item (projectile_list[pl.item].row).out+","+(projectile_list[pl.item].column - max_projectile_move).out+"]->"+"["+row_indexes.item (projectile_list[pl.item].row).out+","+projectile_list[pl.item].column.out+"]")
				end
			end
		end
	is_ship_collided(row:INTEGER_32;column:INTEGER_32)
		do
			across 1 |..| projectile_list.count as pl
				loop
					if (projectile_list[pl.item].row = row) and (projectile_list[pl.item].column = column) then
						is_game_started := false
						output_msg.append ("%N The Starfighter moves and collides with a projectile: "+"["+row_indexes.item (old_ship_location.row).out+","+old_ship_location.column.out+"]"+"->"+"["+row_indexes.item (row).out+","+ship_location.out+"]")
						output_msg.append (grid_layout)
						output_msg.append ("%N The game is over. Better luck next time!")
					end
				end

		end
	is_projectile_collided
		do
			across 1 |..| projectile_list.count as pl
				loop
					if (projectile_list[pl.item].row = ship_location.row) and (projectile_list[pl.item].column = ship_location.column) then
						is_game_started := false
						output_msg.append ("%N A projectile moves and collides with the Startfighter:"+"["+row_indexes.item (projectile_list[pl.item].row).out+","+(projectile_list[pl.item].column - max_projectile_move).out+"]->"+"["+row_indexes.item (projectile_list[pl.item].row).out+","+projectile_list[pl.item].column.out+"]")
						output_msg.append (grid_layout)
						output_msg.append ("%N The game is over. Better luck next time!")
					end
				end

		end


	move_vertical (row:INTEGER_32; column:INTEGER_32)
		local
			i : INTEGER_32
		do
			if ship_location.row > row then
				from i := row
				until
					i <= ship_location.row
				loop
					if is_game_started then
						is_ship_collided(i,column)
					end
					i:=i-1
				end
				if is_game_started then
					ship_location.row := row
				end
			elseif ship_location.row < row then
				from i := ship_location.row
				until
					i >= row
				loop
					if is_game_started then
						is_ship_collided(i,column)
					end
					i:=i+1
				end
				if is_game_started then
					ship_location.row := row

				end
			end
		end
	move_horizontal (row:INTEGER_32; column:INTEGER_32)
	local
			i : INTEGER_32
		do
			if ship_location.column > column then
				from i := column
				until
					i >= ship_location.column
				loop
					if is_game_started then
						is_ship_collided(row,i)
					end
					i:=i-1
				end
				if is_game_started then
					ship_location.column := column
				end
			elseif ship_location.column < column then
				from i := ship_location.column
				until
					i <= column
				loop
					if is_game_started then
						is_ship_collided(row,i)
					end
					i:=i+1
				end
				if is_game_started then
					ship_location.column := column
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
							board.put (" S ",r.item,c.item)
					else
							board.put (" _ ",r.item,c.item)
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
							board.put (" X ", projectile_list[pl.item].row,projectile_list[pl.item].column)
						else

							board.put (" * ", projectile_list[pl.item].row,projectile_list[pl.item].column)
						end

					end
				end
			end


			grid_layout.append("%N ")
			across 1 |..| board.width as i loop grid_layout.append(" " + fi.formatted (i.item)) end
			across 1 |..| board.height as r
			loop
				grid_layout.append ("%N "+ row_indexes[r.item].out)
				across 1 |..| board.width as c
				loop
					grid_layout.append (board.item (r.item, c.item))

				end
			end
		end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	play(row:INTEGER_32;column:INTEGER_32; player_mov: INTEGER_32 ; project_mov: INTEGER_32)
		local
			s_row:REAL_64
		do
			if is_game_started = true then
				update_error_state
				set_output_error_msg_state
				output_msg.append ("%N"+error.play_again)

			else
				is_game_started := true
				if player_mov > ((row-1)+(column-1))  then
					update_error_state
					set_output_error_msg_state
					output_msg.append("%N"+error.play_movement_parameter)

				else
					s_row := row/2
					ship_location.row := s_row.ceiling
					ship_location.column := 1

					create board.make_filled ("",row,column)
					max_player_moves := player_mov
					max_projectile_move := project_mov
					make_board
					update_success_state
					error_state:=0
					set_output_success_msg_state
				end
			end


		end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		

	move(move_row:INTEGER_32;move_column:INTEGER_32)

		do
			old_ship_location.column := ship_location.column
			old_ship_location.row := ship_location.row
			update_projectile_location
			move_vertical(move_row,move_column)
			move_horizontal(move_row,move_column)
			error_state:=0
			update_success_state
			set_output_success_msg_state
			make_board
			if is_game_started then
				display_projectile_location
				output_msg.append ("%N The Starfighter moves : "+"["+row_indexes.item (old_ship_location.row).out+","+old_ship_location.column.out+"]"+"->"+"["+row_indexes.item (ship_location.row).out+","+ship_location.column.out+"]")
			end


		end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fire
		local
			projectile_location :TUPLE[row:INTEGER_32;column:INTEGER_32]
		do
			update_projectile_location
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
			error_state := 0


			if is_game_started then

				output_msg.append ("%N The Starfighter fires a projectile at:"+"["+row_indexes.item (ship_location.row).out+","+ship_location.column.out+"]")
			end

		end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	pass
		do
			update_success_state
			set_output_success_msg_state

			update_projectile_location

			if is_game_started then
				display_projectile_location
			end
			make_board
			is_projectile_collided
			error_state:=0


		end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	abort
		do
			error_state:=0
			update_success_state
			set_output_success_msg_state
			is_game_started:=false
			output_msg.append("%N"+"Game has been exited.")
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
end
