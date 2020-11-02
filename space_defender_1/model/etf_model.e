note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			create game.make
			i := 0

		end

feature -- model attributes
	s : STRING
	i : INTEGER
	game : ETF_GAME


feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	play(row: INTEGER_32 ; column: INTEGER_32 ; player_mov: INTEGER_32 ; project_mov: INTEGER_32)
		--play model operation

		do
			game.play(row,column,player_mov,project_mov)
			default_update
		end
	move(row:INTEGER_32; column:INTEGER_32)
		do
			game.move(row,column)
		end
	pass
		do
			game.pass
		end
	abort
		do
			game.abort
		end
	fire
		do
			game.fire
		end
	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("")
			if(game.success_state = 0 and game.error_state = 0)
			then
				Result := "  Welcome to Space Defender Version 1."
			else
				Result.append(game.output)
			end

		end

end




