note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ABORT
inherit
	ETF_ABORT_INTERFACE
create
	make
feature -- command
	abort
    	do
			-- perform some update on the model state
			if model.is_game_started then
				model.abort
			else
				model.update_error_state
				model.set_output_error_msg_state
				model.output_msg.append("%N  "+ model.error.not_in_game)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
