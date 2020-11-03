note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PASS
inherit
	ETF_PASS_INTERFACE
create
	make
feature -- command
	pass
    	do
			-- perform some update on the model state
			if model.is_game_started then
				model.add_command (create {PASS_COMMAND}.make)
				model.history[model.cursor].execute (0, 0)
			else
				model.update_error_state
				model.set_output_error_msg_state
				model.output_msg.append("%N  "+ model.error.not_in_game)
			end


			etf_cmd_container.on_change.notify ([Current])
    	end

end
