note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
create
	make
feature -- command
	undo
    	do
    		if model.is_game_started then
    			if model.cursor >0 and model.history.count > 0 then
    				model.history[model.cursor].undo
				else
					model.update_error_state
					model.set_output_error_msg_state
					model.output_msg.append ("%N  "+model.error.undo_history)
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
