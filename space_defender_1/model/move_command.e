note
	description: "Summary description for {MOVE_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE_COMMAND
inherit
	COMMANDS
create
	make
feature
olocation:TUPLE[row:INTEGER_32; column:INTEGER_32]
	location:TUPLE[row:INTEGER_32; column:INTEGER_32]
	make
	local
		model_access : ETF_MODEL_ACCESS
		do
			model := model_access.m
			create olocation.default_create
			create location.default_create
		end

feature

	execute(move_row:INTEGER_32;move_column:INTEGER_32)
		do
			model.move (move_row, move_column)

		end
	undo
		do
			model.ship_location.row := model.location[model.cursor].old_l.row
			model.ship_location.column := model.location[model.cursor].old_l.column
			model.decrease_success_state
			model.set_output_success_msg_state
			model.decrease_projectile_location
			model.display_projectile_location
			model.make_board
			if model.cursor -1 > 0 then
				if (model.location[model.cursor - 1].curr.row = model.location[model.cursor].old_l.row) and (model.location[model.cursor-1].curr.column = model.location[model.cursor].old_l.column) then
					model.output_msg.append ("%N"+"  The Starfighter moves: "+"["+model.row_indexes.item (model.location[model.cursor - 1].curr.row).out+","+model.location[model.cursor-1].curr.column.out+"]"+" -> "+"["+model.row_indexes.item (model.location[model.cursor].old_l.row).out+","+model.location[model.cursor].old_l.column.out+"]")
				else
					model.output_msg.append ("%N"+"  The Starfighter stays at: "+"["+model.row_indexes.item (model.ship_location.row).out+","+model.ship_location.column.out+"]")

				end
			end
			model.decrement_cursor
		end
	redo
		do
			if model.cursor + 1 < model.location.count then
				model.history[model.cursor].execute (model.location[model.cursor+1].curr.row,model.location[model.cursor+1].curr.column)
			end

		end

end
