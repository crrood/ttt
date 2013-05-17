# ttt_io.rb
# Input / Output manager for the ttt program

class Ttt_Reader


	# create variable to store parameters
	attr_accessor :params
	
	
	def initialize(input_filename, output_filename)
	
		# debug messages
		# should eventually be turned into error checking
		puts "ttt_Reader initialize started"
		puts "input_filename: " + input_filename
		puts "output_filename: " + output_filename
		puts ""
		
		
		# load input parameters from input file
		@in = File.open("input.csv", "r+")

		# and grab the input parameters
		@params = @in.gets.chomp.split(",")
		puts "input parameters:\n" + @params.to_s
		puts ""
		
		# get an output file ready
		@out = File.open(output_filename, "a")
		
	end
	
	def in
		@in
	end
	
	def out
		@out
	end
	
	def get_child
	
		weights = @in.gets.chomp.split(",")
		
		child = Hash.new
		params.each do |param|
			child[param.to_s] = weights[params.index(param)]
		end
		puts "child" + child.to_s
		
		return child
		
	end
	
end
