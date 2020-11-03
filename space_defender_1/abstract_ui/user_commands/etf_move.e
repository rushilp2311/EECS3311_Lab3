note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE
inherit
	ETF_MOVE_INTERFACE
create
	make
feature -- command
	move(row: INTEGER_32 ; column: INTEGER_32)
		require else
			move_precond(row, column)
		local
			move_row:INTEGER_32
			valid_move:INTEGER_32
    	do
			-- perform some update on the model state


			if model.is_game_started then
				move_row := 0
				valid_move := (row - model.ship_location.row) + (column - model.ship_location.column)
				if
					row = A
				then
					move_row:=1
				end
				if
					row = B
				then
					move_row:=2
				end
				if
					row = C
				then
					move_row:=3
				end
				if
					row = D
				then
					move_row:=4
				end
				if
					row = E
				then
					move_row:=5
				end
				if
					row = F
				then
					move_row:=6
				end
				if
					row = G
				then
					move_row:=7
				end
				if
					row = H
				then
					move_row:=8
				end
				if
					row = I
				then
					move_row:=9
				end
				if
					row = J
				then
					move_row:=10
				end
				if move_row = 0 or column > model.board.width then
					model.update_error_state
					model.set_output_error_msg_state
					model.output_msg.append ("%N  "+model.error.move_outside_board)
				else
						if valid_move.abs > model.max_player_moves then
							model.update_error_state
							model.set_output_error_msg_state
							model.output_msg.append ("%N  "+model.error.move_movement_range)
						else
							if move_row = model.ship_location.row and column = model.ship_location.column then
										model.update_error_state
										model.set_output_error_msg_state
										model.output_msg.append ("%N  "+model.error.move_same_location)
							else
									model.add_command (create {MOVE_COMMAND}.make)

									model.history[model.cursor].execute (move_row, column)

							end
						end

				end
			else
				model.update_error_state
				model.set_output_error_msg_state
				model.output_msg.append("%N  "+ model.error.not_in_game)
			end


			etf_cmd_container.on_change.notify ([Current])
    	end

end
