note
	description: "Summary description for {FIRE_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIRE_COMMAND
inherit
	COMMANDS

create
	make
feature
	make
	local
		model_access : ETF_MODEL_ACCESS
		do
			model := model_access.m
		end

feature
	execute(move_row:INTEGER_32;move_column:INTEGER_32)
		do
			model.fire
		end
	undo
		do

			model.projectile_list.remove_tail (1)
			model.decrease_projectile_location
			model.decrease_success_state
			model.set_output_success_msg_state
			model.make_board
			model.display_projectile_location
			model.decrement_cursor
		end
	redo
		do
			model.history[model.cursor].execute (0, 0)
		end
end
