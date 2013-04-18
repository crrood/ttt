# ttt.rb
# machine learning based bot that plays tic-tac-toe
# by colin rood


# start program
puts "initializing"


# initialize board state array
$board = [ [ " " , " " , " " ] , [ " " , " " , " " ] , [ " " , " " , " " ] ]


# main program method
def main()

	# clear the system input buffer
	STDOUT.flush
	input = gets.chomp # chomp removes the trailing \n character
	
	# get input until exit command is received
	begin
		
		# check if input is valid
		# and update board state
		setState(input)
		
		# keep checking for input
		input = gets.chomp
		
	end until input == "exit"
	
end

# output board state to console
def print_state()
	
	# iterate over array
	print "\n"
	(0..2).each do |y|
		(0..2).each do |x|
			print $board[x][y]
			
			# vertical lines
			print x < 2 ? "|" : nil
		end
		
		# horizontal lines
		print y < 2 ? "\n-----\n" : "\n"
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
	
	elseif !(state.is_a? String)
		puts "state must be a string"
		return false
	
	end
	
	# check data ranges
	if (x < 0 || x > 2)
		puts "x value out of range"
		return false
	
	elseif (y < 0 || y > 2)
		puts "y value out of range"
		return false
	
	elseif !(state == "X" || state == "O")
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
	if !(fInput = format_input(input))
		return false
	end
	
	# update board state
	$board[fInput[0]][fInput[1]] = fInput[2]
	
	# print board for debugging
	print_state()
	
end

main()