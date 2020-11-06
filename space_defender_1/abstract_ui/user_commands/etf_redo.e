note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REDO
inherit
	ETF_REDO_INTERFACE
create
	make
feature -- command
	redo
    	do

    		if model.is_game_started then
    			model.increment_cursor
    			if model.cursor > 0 and model.cursor < model.history.count then

    				model.history[model.cursor].redo
				else
					model.update_error_state
					model.set_output_error_msg_state
					model.output_msg.append ("%N  "+model.error.redo_history)
    			end
    		else
    			model.update_error_state
				model.set_output_error_msg_state
				model.output_msg.append ("%N  "+model.error.not_in_game)

    		end


			-- perform some update on the model state
			etf_cmd_container.on_change.notify ([Current])
    	end

end
