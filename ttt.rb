# ttt.rb
# machine learning based bot that plays tic-tac-toe
# by colin rood


# start program
puts "initializing"

# constants
WIDTH = 2

# initialize board state array
$board = [ [ " " , " " , " " ] , [ " " , " " , " " ] , [ " " , " " , " " ] ]

#############################################################################
#############################   METHODS   ###################################
#############################################################################

# main program method
def main()

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
			setState(input)
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
def verify_input?(input)
	
	# input comes formatted as a string of the form "x y state"
	if !input.is_a? String
		puts "input must be a string"
		return false
	end
	
	# divide input string into an array
	fInput = input.split(" ")
	
	if fInput.length != 3
		puts "wrong number of arguments"
		return false
	
	else
		# format string into Array
		x = fInput[0].to_i
		y = fInput[1].to_i
		state = fInput[2].capitalize
		
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


# convert the input string to an array
def format_input(input)

	# make sure input is valid
	if !verify_input?(input)
		return false
	end
	
	# input comes formatted as a string
	# of the form "x y state"
	fInput = input.split(" ")
	x = fInput[0].to_i
	y = fInput[1].to_i
	state = fInput[2].capitalize
	
	# put it all back into the array
	fInput[0] = x
	fInput[1] = y
	fInput[2] = state
	
	return fInput
end


# update board state
def setState(input)
	
	# format input
	fInput = format_input(input)
	if (fInput == false)
		# input wasn't formatted correctly
		return false
	end
	
	# update board state
	$board[fInput[0]][fInput[1]] = fInput[2]
	
	# print board for debugging
	print_state
	
end

# determine best move
# param: whose turn it is
def evaluate(active)
	# CRITERIA FOR MOVE M:
	# does M win? (duh)
	# (delta?) possible future wins given M
	# (delta?) shortest possible turns to win given M
	# delta possible future opp wins given M
	# delta shortest possible turns to win given M
	
	# ALGORITHM
	# get list of all possible moves
	# evaluate and rate each
	# find best value (maybe put them all in a heap)
end

# initialize main method
main