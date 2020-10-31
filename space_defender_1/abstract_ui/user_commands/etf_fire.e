note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
create
	make
feature -- command
	fire
    	do
			-- perform some update on the model state
			if model.game.is_game_started then
				model.fire
			else
				model.game.update_error_state
				model.game.set_output_error_msg_state
				model.game.output_msg.append("%N"+ model.game.error.not_in_game)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
