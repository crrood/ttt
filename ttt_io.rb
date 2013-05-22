# ttt_io.rb
# Input / Output manager for the ttt program

class Ttt_Reader


	# create variable to store parameters
	attr_accessor :params
	
	
	# creates a new object
	# sets input file
	# gets parameters
	def initialize(input_filename, output_filename)
	
		# DEBUG
		# should eventually be turned into error checking
		puts "ttt_Reader initialize started"
		puts "input_filename: " + input_filename
		puts "output_filename: " + output_filename
		puts ""
		
		
		# load input parameters from input file
		@in = File.open("input.csv", "r+")

		# and grab the input parameters
		@params = @in.gets.chomp.split(",")
		
		# DEBUG
		puts "input parameters:\n" + @params.to_s
		puts ""
		
		# get an output file ready
		@out = File.open(output_filename, "a")
		
	end
	
	
	# initialize input file
	# .csv expected
	def in
		@in
	end
	
	
	# initialize output file
	def out
		@out
	end
	
	
	# returns Hash where 
	# key = parameter
	# value = its weight
	def get_child
	
		weights = @in.gets.chomp.split(",")
		
		child = Hash.new
		params.each do |param|
			child[param.to_s] = weights[params.index(param)]
		end
		
		# DEBUG
		puts "child" + child.to_s
		
		return child
		
	end
	
end
