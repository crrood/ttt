# ttt.rb
# machine learning based bot that plays tic-tac-toe
# by colin rood


require "./ttt_io.rb"

#############################################################################
############################   VARIABLES   ##################################
#############################################################################

# constants
WIDTH = 2

# initialize board state array
$board = [ [ "E" , "E" , "E" ] , [ "E" , "E" , "E" ] , [ "E" , "E" , "E" ] ]


#############################################################################
#############################   CLASSES   ###################################
#############################################################################
class Move
	
	attr_accessor :x, :y, :player
	
	def initialize(x, y, player)
		@x = x.to_i
		@y = y.to_i
		@player = player.capitalize
	end
	
	def opp
		@player == "X" ? "O" : "X"
	end
	
	def to_s
		"(" + @x.to_s + ", " + @y.to_s + ", " + @player.to_s + ")"
	end
	
end


class Individual
	
	# hash where
	# key = parameter
	# value = its weight
	attr_accessor :weight_of
	
	
	# initialize weight_of hash from given input
	def set_weights(input)
		
		# premade Hash
		if (input.is_a?(Hash))
		
			@weight_of = weight_hash
		
		# i/o reader object
		elsif (input.is_a?(Ttt_Reader))
			
			@weight_of = input.get_child
		
		end
		
	end
	
	
	# output formatting
	def to_s
		
		print @weight_of
		
	end
	
end


#############################################################################
#############################   METHODS   ###################################
#############################################################################

# main program method
def main
	
	# load the parameters from the file
	
	# initialize i/o class
	reader = Ttt_Reader.new("input.csv", "output.csv")
	
	
	# create an individual object from the input parameters
	player1 = Individual.new.set_weights(reader)
	player2 = Individual.new.set_weights(reader)
	
	
	# have them play each other
	winner = winner_of(player1, player2)
	
	
	# DEBUG
	puts mate(winner, winner == player1 ? player1 : player2, "exp")
	
	
	# save results to output.csv
	#	-- what info do I want?
	
	
			
	# clear the system input buffer and prepare for input
	STDIN.flush
	STDOUT.flush
	
	# get input until exit command is received
	begin
		
		# check for input
		input = gets.chomp

		
		# interpret text commands
		split = input.split
		case split[0]
		
		# TODO
		# "undo" command
		
		# manual of valid commands
		when "help"
			puts "[x] [y] [x/o]: log the current move"
			puts "print: output the current board state"
			puts "eval [x/o]: evaluate all possible moves for entered player"
			puts "eval [x] [y] [x/o]: output the entered move value given loaded input weights"
		
		# exit the program
		when "q"
			return
		
		# output current board state
		when "print"
		
			print_state
		
		# run evaluate method
		when "evaluate", "eval"
			
			if (split.length >= 4 && formatted_input = format_input(split[1] + " " + split[2] + " " + split[3]))
			
				# evaluate a specified move
				evaluate( formatted_input )
				
			elsif (split.length == 2)
			
				# evaluate all moves for specified player
				find_optimal_move_for(split[1].capitalize)
				
			end
			
		# input is the next move
		else
		
			# check if input is valid
			# and update board state
			if (formatted_input = format_input(input))
				set_state (formatted_input)
			end
			
		end
				
	end until input == "q"
	
end


# output board state to console
def print_state
	
	# iterate over array
	print "\n"
	(0..WIDTH).each do |y|
	
		(0..WIDTH).each do |x|
			
			if ($board[x][y] == "E")
				print " "
			else
				print $board[x][y]
			end
			
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

# NOTE
# this could probably go in the Move.initialize method
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
	move_object = Move.new(f_input[0], f_input[1], f_input[2])
	
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
def find_optimal_move_for(individual, active_side)
	
	# iterate over all spaces
	# evaluate each
	# and find maximum
	
	# counter variables
	best_move = nil
	max_value = 0
	
	# iterate over all possible moves
	(0..WIDTH).each do |y|
	
		(0..WIDTH).each do |x|
			
			# check if the move is valid
			if ($board[x][y] == "E")
			
				# evaluate move
				move_object = Move.new(x, y, active_side)
				move_value = evaluate(move_object, individual)
				
				# compare against current max
				if (move_value > max_value)
					max_value = move_value
					best_move = move_object.dup
				end
				
			end
			
		end
		
	end
	
	# DEBUG
	puts best_move
	
	# return the highest rated move
	best_move
	
end


# quantify the value of a specific move
# param: qualified Move object
def evaluate(move, individual)
	
	# CRITERIA FOR MOVE M:
	# does M win?
	# delta possible future wins given M
	# delta shortest possible turns to win given M
	# delta possible future opp wins given M
	# delta shortest possible turns to opp win given M
	
	# since there are only 8 possible ways to win in tic-tac-toe,
	# these can all be reasonably combined into a single brute force algorithm
	# which counts the number of player, opponent, and empty spaces
	# in each possible victory vector and determines values for these parameters
	# this runs once at the current board state
	# and again assuming (move) to determine deltas
	
	# parameter variables to max/min
	turns_to_win = [3, 3]
	turns_to_opp_win = [3, 3]
	possible_wins = [0, 0]
	possible_opp_wins = [0, 0]
	
	# counter hash
	num_filled_as = Hash.new
	num_filled_as["X"] = 0
	num_filled_as["O"] = 0
	num_filled_as["E"] = 0
	
	# runs algorithm twice
	# first at current board state
	# then taking move as true
	(0..1).each do |m|
	
		# the evaluation algorithm iterates through each
		# line (vertical, horizontal, and diagonal),
		# counting the number of each players' square in each
		
		# move_wins = 1 if all 3 squares are theirs
		# turns_to_win = 3 - # theirs if no opposing pieces present
		# possible_wins = sum of all lines where no opposing pieces present
		
		# iterates through board twice
		# reflecting from horizontal to vertical at y = 3
		# by reversing x and y coordinates
		
		(0..5).each do |y|
			(0..2).each do |x|
				# count spaces
				if (y < 3)
					# horizontal
					num_filled_as[$board[x][y]] += 1
				else
					# vertical
					num_filled_as[$board[y - 3][x]] += 1
				end
			end
			
			# evaluate parameters
			if (num_filled_as[move.player] == 0)
				possible_opp_wins[m]
				turns_to_opp_win[m] = [turns_to_opp_win[m], num_filled_as["E"]].min
				
			elsif (num_filled_as[move.opp] == 0)
				possible_wins[m] += 1
				turns_to_win[m] = [turns_to_win[m], num_filled_as["E"]].min
			
			end
			
			# reset hash
			num_filled_as.each_key{ |key| num_filled_as[key] = 0 }
			
		end
		
		# diagonals
		(0..1).each do |i|
			(0..2).each do |j|
				# a little bit of mathmatical wizardry
				# when i == 0 goes TL --> BR
				num_filled_as[$board[j][(2 * i - j).abs]] += 1
				
			end
		
			# evaluate parameters
			if (num_filled_as[move.player] == 0)
				possible_opp_wins[m] += 1
				turns_to_opp_win[m] = [turns_to_opp_win[m], num_filled_as["E"]].min
				
			elsif (num_filled_as[move.opp] == 0)
				possible_wins[m] += 1
				turns_to_win[m] = [turns_to_win[m], num_filled_as["E"]].min
			
			end
			
			# reset hash
			num_filled_as.each_key{ |key| num_filled_as[key] = 0 }
			
		end
		
		# set move as given and repeat
		$board[move.x][move.y] = move.player
	
	end
	
	# return $board to original state
	$board[move.x][move.y] = "E"
	
	# gather paramter values into Hash
	# not strictly necessary but nice for debugging
	params = Hash.new
	params["move_wins"] = turns_to_win[1] == 0 ? 1 : 0
	params["d_possible_wins"] = possible_wins[1] - possible_wins[0]
	params["d_turns_to_win"] = turns_to_win[1] - turns_to_win[0]
	params["d_possible_opp_wins"] = possible_opp_wins[1] - possible_opp_wins[0]
	params["d_turns_to_opp_win"] = turns_to_opp_win[1] - turns_to_opp_win[0]
	
	# initialize move value counter
	move_value = 0
	
	# multiply parameter values by their weights
	params.each_key do |p|
		move_value += params[p].to_i * individual.weight_of[p].to_i
	end
	
	# DEBUG
	puts "move_value for " + move.to_s + ": " + move_value.to_s
	
	move_value
	
end


# have two Individuals play each other
# and return a child Individual based on the outcome
def winner_of(parent1, parent2)
	
	# parent1 always goes first, is X
	# parent2 always goes second, is O
	set_state(find_optimal_move_for(player1, "X"))
	
	
end


# create a child given a winner and a loser Individual objects
def mate(winner, loser, method)
	
	# create new Individual object to store child
	child = Individual.new
	
	# DEBUG
	alpha = 0.7
	beta = 0.3
	gamma = 0.04
	
	# combine parent values
	case method.to_s
	
	# combine linearly
	when "lin"
		
		child.weight_of = winner.merge(loser) { |param, winner_weight, loser_weight| 
			(alpha * winner_weight.to_f + beta * loser_weight.to_f) * gen_error(gamma)
		}
		
	# combine exponentially
	when "exp"
		
		child.weight_of = winner.merge(loser) { |param, winner_weight, loser_weight|
			(winner_weight.to_f**alpha) * (loser_weight.to_f**beta) * gen_error(gamma)
		}
		
	end
	
	
	return child
	
end


# generate error modifier between 1 +/- gamma percent
def gen_error(gamma)
	
	(1 - gamma + 2 * rand * gamma)
	
end


#############################################################################
#############################   RUNTIME   ###################################
#############################################################################

# initialize main method

puts ""
main