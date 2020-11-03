note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY
inherit
	ETF_PLAY_INTERFACE
create
	make
feature -- command
	play(row: INTEGER_32 ; column: INTEGER_32 ; player_mov: INTEGER_32 ; project_mov: INTEGER_32)
		require else
			play_precond(row, column, player_mov, project_mov)
    	do
			-- perform some update on the model state
			if model.is_game_started = true then
				model.update_error_state
				model.set_output_error_msg_state
				model.output_msg.append ("%N  "+model.error.play_again)

			else
				if player_mov > ((row-1)+(column-1))  then
					model.update_error_state
					model.set_output_error_msg_state
					model.output_msg.append("%N"+model.error.play_movement_parameter)
				else

					model.play(row,column,player_mov,project_mov);
					model.add_locations ([model.ship_location,model.ship_location])
				end

			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
