note
	description: "Summary description for {COMMANDS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMMANDS

feature --defered features
	model : ETF_MODEL

	execute(move_row:INTEGER_32;move_column:INTEGER_32)
		deferred
		end
	undo
		deferred
		end
	redo
		deferred
		end

end
