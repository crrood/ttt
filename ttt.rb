# ttt.rb
# machine learning based bot that plays tic-tac-toe
# by colin rood


#############################################################################
############################   VARIABLES   ##################################
#############################################################################

# constants
WIDTH = 2

# initialize board state array
$board = [ [ " " , " " , " " ] , [ " " , " " , " " ] , [ " " , " " , " " ] ]


#############################################################################
#############################   CLASSES   ###################################
#############################################################################
class Move
	def initialize(x, y, player)
		@x = x
		@y = y
		@player = player
	end
	
	def x
		@x.to_i
	end
	
	def y
		@y.to_i
	end
	
	def player
		@player
	end
end


#############################################################################
#############################   METHODS   ###################################
#############################################################################

# main program method
def main

	# clear the system input buffer
	STDOUT.flush
	input = gets.chomp # chomp removes the trailing \n character
	
	# get input until exit command is received
	begin
		
		# interpret text commands
		case input
		when "print"
			print_state
			
		else
			# check if input is valid
			# and update board state
			if (formatted_input = format_input(input))
				set_state (formatted_input)
			end
			
		end
		
		# keep checking for input
		input = gets.chomp
		
	end until input == "exit"
	
end

# output board state to console
def print_state
	
	# iterate over array
	print "\n"
	(0..WIDTH).each do |y|
		(0..WIDTH).each do |x|
			print $board[x][y]
			
			# vertical lines
			print x < WIDTH ? "|" : nil
		end
		
		# horizontal lines
		print y < WIDTH ? "\n-----\n" : "\n"
	end
	print "\n"
	
end


# make sure input is properly formatted
# param: input string
def verify_input?(input)
	
	# input comes formatted as a string of the form "x y state"
	if !input.is_a? String
		puts "input must be a string"
		return false
	end
	
	# divide input string into an array
	f_input = input.split(" ")
	
	if f_input.length != 3
		puts "wrong number of arguments"
		return false
	
	else
		# format string into Array
		x = f_input[0].to_i
		y = f_input[1].to_i
		state = f_input[2].capitalize
		
	end
	
	# check data types
	if !(x.is_a? Integer) || !(y.is_a? Integer)
		puts "x and y must be numbers"
		return false
	
	elsif !(state.is_a? String)
		puts "state must be a string"
		return false
	
	end
	
	# check data ranges
	if (x < 0 || x > WIDTH)
		puts "x value out of range"
		return false
	
	elsif (y < 0 || y > WIDTH)
		puts "y value out of range"
		return false
	
	elsif !(state == "X" || state == "O")
		puts "state must be either X or O"
		return false
	
	end
	
	# everything's gravy
	return true
	
end


# convert the input string to a Move object
# param: input string of format "x y player"
def format_input(input)

	# make sure input string is valid
	if !verify_input?(input)
		return false
	end
	
	# input comes formatted as a string
	# of the form "x y state"
	f_input = input.split(" ")
	move_object = Move.new(f_input[0], f_input[1], f_input[2].capitalize)
	
	return move_object
end


# update board state
# param: qualified Move object
def set_state(move)
	
	# update board state
	$board[move.x][move.y] = move.player
	
	# print board for debugging
	print_state
	
end

# determine best move
# param: whose turn it is
def find_optimal_move_for(active)
	# CRITERIA FOR MOVE M:
	# does M win? (duh)
	# (delta?) possible future wins given M
	# (delta?) shortest possible turns to win given M
	# delta possible future opp wins given M
	# delta shortest possible turns to win given M
	(0..WIDTH).each do |y|
		(0..WIDTH).each do |x|
			print $board[x][y]
		end
	end
	
	# ALGORITHM
	# get list of all possible moves
	# evaluate and rate each
	# find best value (maybe put them all in a heap)
end

# quantify the value of a specific move
# param: qualified Move object
def evaluate(input)
	
end

#############################################################################
#############################   RUNTIME   ###################################
#############################################################################

# start program
puts "initializing"

# initialize main method
main