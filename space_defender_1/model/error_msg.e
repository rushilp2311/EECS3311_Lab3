note
	description: "Summary description for {ERROR_MSG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR_MSG
create
	make
feature {NONE}
	make
		do
			not_in_game := "Not in game."
			move_outside_board := "The location to move to is outside of the board."
			move_movement_range := "The location to move is out of the Starfighter's movement range."
			move_same_location := "The Starfighter is already at that location."
			play_again := "Please end the current game before starting a new one."
			play_movement_parameter := "Starfighter movement should not exceed row - 1 + column - 1 size of the board."
			redo_history := "Nothing left to redo."
			undo_history := "Nothing left to undo."
		end
feature --attributes
	not_in_game : STRING
	move_outside_board : STRING
	move_movement_range : STRING
	move_same_location : STRING
	play_again : STRING
	play_movement_parameter : STRING
	redo_history : STRING
	undo_history : STRING


end
