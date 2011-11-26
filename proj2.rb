# William Lyon
# Algorithms
# Project 2
# 10.24.11

# Text-based race car game.  Program to find the optimal solution given textfile named 'data.txt' containing ASCII racetrack

#require 'thread'

# Use graph where vertices (nodes) are (x,y) position plus velocity vector (dx, dy)


# Define Node class
class Node
	def initialize(x, y, dx, dy)
	end

	def initialize()	#constructor
		@x=0
		@y=0
		@dx=0
		@dy=0
		@is_valid=true
		@visited=false
	end
	
	def setVector(d2x,d2y)	# change velocity vector
		@dx += d2x
		@dy += d2y
		
	end

	def getNeighbors(node_array, x_max, y_max) # return array of all possible Nodes that are neighbors to this Node
		
		# return array of Nodes [Node(x+dx, y+dy, dx, dy), Node(x+dx, y+dy, dx+1, dy), Node(x+dx, y+dy, dx-1, dy), Node(x+dx, y+dy, dx, dy+1), Node(x+dx, y+dy, dx, dy-1)]
			
	x_cord = @x+@dx		# new x coordinate	
	y_cord = @y+@dy		# new y coordinate
	
	rtn_array=[]		# temp Node array

	if x_cord>=0 && x_cord <x_max && y_cord>=0 && y_cord <y_max # conditions for valid neighbor
		if node_array[x_cord][y_cord].is_valid
			node_array[x_cord][y_cord].setVector(@dx,@dy) #accelerate by (0,0)
			rtn_array.push(node_array[x_cord][y_cord]) #add to temp array
		end
	end

	if x_cord+1>=0 && x_cord+1 <x_max && y_cord>=0 && y_cord <y_max #conditions for valid neighbor
		if node_array[x_cord+1][y_cord].is_valid
			node_array[x_cord+1][y_cord].setVector(@dx+1, @dy)  #accelerate by (1,0)
			rtn_array.push(node_array[x_cord+1][y_cord]) #add to temp array
		end
	end
	if x_cord-1>=0 && x_cord-1 <x_max && y_cord>=0 && y_cord <y_max #conditions for valid neighbor
		if node_array[x_cord-1][y_cord].is_valid
			node_array[x_cord-1][y_cord].setVector(@dx-1, @dy)  #accelerate by (-1,0) 
			rtn_array.push(node_array[x_cord-1][y_cord]) #add to temp array
		end
	end

	if x_cord>=0 && x_cord <x_max && y_cord+1>=0 && y_cord+1 <y_max  #conditions for valid neighbor
		if node_array[x_cord][y_cord+1].is_valid
			node_array[x_cord][y_cord+1].setVector(@dx, @dy+1)  #accelerate by (0,1)
			rtn_array.push(node_array[x_cord][y_cord+1]) #add to temp array
		end
	end	

	if x_cord>=0 && x_cord <x_max && y_cord-1>=0 && y_cord-1 <y_max #conditions for valid neighbor
		if node_array[x_cord][y_cord-1].is_valid
			node_array[x_cord][y_cord-1].setVector(@dx, @dy-1)  #accelerate by (0,-1)
			rtn_array.push(node_array[x_cord][y_cord-1]) #add to temp array
		end
	end
		@dx=0						# reset acceleration to 0,0
		@dy=0						# in case this coordinate is visited again
		if @layer>0						
			parent.visited=false	# set visited to false in case this coordinate is visted again with a different vector
		end
	return rtn_array

	end

	def x	# x coordinate
		@x
	end

	def road_char	# unicode value for character at x,y coordiantes on racetrack
		@road_char
	end
	def road_char=(value)
		@road_char=value
	end

	def layer		# used for BFS layer
		@layer
	end

	def layer=(value)
		@layer=value
	end

	def parent		# parent node, used in BFS 
		@parent
	end

	def parent=(value)
		@parent=value
	end

	def x=(value)
		@x=value
	end


	def y=(value)
		@y=value
	end
	def y		# y coordinate
		@y
	end

	def dx		# acceleration in x direction
		@dx
	end

	def dy		# acceleration in y direction
		@dy
	end

	def dx=(value)
		@dx=value
	end

	def dy=(value)
		@dy=value
	end

	def is_valid	# is x,y a valid position on racetrack?
		@is_valid
	end

	def visited		# used for BFS
		@visited
	end

	def visited=(value)
		@visited=value
	end

	def to_string()
		return " "+@x.to_s+" "+@y.to_s+" "+@dx.to_s+" "+@dy.to_s+" "+@road_char.to_s+" "+@is_valid.to_s
	end

	def determine_validity()
		if @road_char==35 then @is_valid=false  # is road_char is '#' then it is out of bounds
		else @is_valid=true						# otherwise it is valid
		end
	end
end

def BFS (node, array, x_dim, y_dim)	# Breadth First Search 
	node.layer=0
	count=0
	queue = []
	queue.push(node)
	rtn_node=node
	node.visited=true
	set_break=false
	while (!queue.empty?)
		new_node = queue.pop()
		
		new_node.getNeighbors(array, x_dim, y_dim).each do |neighbor|
			if neighbor.visited !=true then
				#puts neighbor.to_string
				neighbor.layer = new_node.layer+1
				neighbor.visited=true
				#new_node.setVector(0,0)
				queue.push(neighbor)
				neighbor.parent=new_node
				
				
				if neighbor.road_char==70 then 	# check if neighbor position in at finish line, break if it is
						#puts "SOLUTION!!!"
						set_break=true
						rtn_node=neighbor	# neighbor is the finsh vetex
				end
				break if neighbor.road_char==70 
				#break if neighbor.road_char==70
			end  
				break if neighbor.road_char==70
			end
	break if set_break
	
	end
	if (!set_break)
		puts "Impossible"	# if not solution exists, print Impossible
	end
	return rtn_node

end

def print_parents(node)	# prints all parent nodes
	if node.layer==0
		puts node.to_string
		return
	else
		puts node.to_string
		print_parents(node.parent)
	end
end

def restore_accel(node)	# since velocity vector is reset to zero this function restores dx and dy
	if node.layer == 0
		node.dx=0
		node.dy=0
		return
	

	else
		node.dx=node.x-node.parent.x
		node.dy=node.y-node.parent.y
		restore_accel(node.parent)
	end
end

def print_accel(node,queue)	# prints acceleration steps for all parents 
	#queue=[]
	if node.layer != 0
		queue.push("Accelerate by (" + (node.dx-node.parent.dx).to_s + ", " + (node.dy-node.parent.dy).to_s + ")")
		print_accel(node.parent, queue)
	else
		while (!queue.empty?)
			puts queue.pop()
		end
	end
end

data_array = IO.readlines('data.txt')	# read racetrack from data.txt file
dimensions = data_array[0].scan(/\w+/)
x_dim=dimensions[0].to_i		# racetrack dimensions
y_dim=dimensions[1].to_i

node_array = Array.new(x_dim) {Array.new(y_dim) {Node.new()}} # create Node array of racetrack dimensions

i = 0							#set x,y and road_char values for every Node in the array
until i==x_dim
	e =0
	until e==y_dim
		node_array[i][e].x=i
		#puts node_array[i][e].x
		node_array[i][e].y=e
		node_array[i][e].road_char=data_array[y_dim-e].slice(i)
		#puts node_array[i][e].y
		e += 1
	end
	i += 1
end
#puts data_array
#puts data_array[2]

node_array.each {|r|		# determine which nodes are valid racetrack positions
	r.each {
|myNode| myNode.determine_validity()}}


finish=BFS(node_array[2][1], node_array, x_dim, y_dim) # find the optimal solution using BFS - starting point on given racetrack is (2,1) adjust index in node_array[x][y] in this line as the starting point changes if a new reacetrack is used

restore_accel(finish)	# restore velocity vectors
queue=[] 				# create empty array for print_accel
print_accel(finish, queue)	# print all accelerations 


