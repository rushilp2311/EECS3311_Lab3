note
	description: "Summary description for {PASS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PASS_COMMAND
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
			model.pass
		end
	undo
		do
			model.decrement_cursor
			model.decrease_success_state
			model.set_output_success_msg_state
			model.decrease_projectile_location
			model.display_projectile_location
			model.make_board
			if (model.location[model.cursor].old_l.row = model.location[model.cursor ].curr.row) and (model.location[model.cursor ].old_l.column = model.location[model.cursor  ].curr.column) then
				model.output_msg.append ("%N"+"  The Starfighter moves: "+"["+model.row_indexes.item (model.location[model.cursor].old_l.row).out+","+model.location[model.cursor].old_l.column.out+"]"+" -> "+"["+model.row_indexes.item (model.ship_location.row).out+","+model.ship_location.column.out+"]")

			else
				model.output_msg.append ("%N"+"  The Starfighter stays at: "+"["+model.row_indexes.item (model.ship_location.row).out+","+model.ship_location.column.out+"]")			end
		end
	redo
		do
			model.history[model.cursor].execute (0,0)
		end
end
