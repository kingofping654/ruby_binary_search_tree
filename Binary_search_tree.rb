#the Node class makes up the data points that are inside of the tree.
class Node
  include Comparable
attr_accessor :data, :left_child, :right_child

#This creates a new node when ever a new instance is created. By defualt the node is empty and has no children.
def initialize(data=nil)
  @data = data
  @left_child = nil
  @right_child = nil
end
end

#The Tree class holds all of the methods that make the tree and modify, analyze, or add to it.
class Tree < Node
attr_accessor :root

#When initialized the class is given an array by the user which is sorted into order and it removes and duplicates. The root is then found by using the build_tree method. 
  def initialize(array)
    @arr = array.sort.uniq
    @root = build_tree(@arr)
  end

  #This method finds the root fo the array by fidning the median number. It creates the tree by regresively giving the left and right roots and adding children to them. The method is set to stop whenever an item in the array is bigger than what follows it. 
  def build_tree(arr, first = 0,  last = arr.length - 1)
     return nil if first > last
    
    middle = (first + last) / 2 
  root = Node.new(arr[middle])
root.left_child = build_tree(arr, first, middle-1)
root.right_child = build_tree(arr, middle+1, last)
root
  end


#Insert will add a new node based on user input that will create a leaf node at the end of either the left/right side. It will continue left or right till it hits an empty node.
def insert(value, node = @root)
  return Node.new(value) if node == nil
 return node if node.data == value
 
 if node.data < value
  node.right_child = insert(value, node.right_child)
 else
  node.left_child = insert(value, node.left_child)
 end
 node
end

#Delete takes a given value and removes it from the tree. If the value coresponds to a leaf it will remove it and nothing else changes. if it has only one side with a child that child replces its parent. If it has children on both sides you look to the right child and then to its left_children till you hit the end and use that node to replace the deleted varaible(this should be a leaf).
def delete(value)
return "Sorry, you can't delete something from an empty tree" if root ==nil
node = @root
until node.data == value

  if node.data < value
  node = node.right_child

  else
  node = node.left_child
end
end

if node.left_child == nil && node.right_child == nil
  node.data = nil
  @arr.delete(node.data)

elsif node.left_child == nil && node.right_child != nil
  node.data = node.right_child.data
  node.right_child.data = nil

elsif node.left_child != nil && node.right_child == nil
  node.data = node.left_child.data
node.left_child.data = nil


else
  node = node.right_child
  until node == nil
    node = node.left_child
    replacement_node = node
  end

  node = nil
node = @root
until node.data == value
if node.data < value
  node = node.right_child
else
  node = node.left_child
end
end
node.data = replacement_node
end
end

#This method takes a given value and returns the node the value is housed in. If the node is not included it returns blank.
def find(value)
return "Sorry your tree doesn't include the value" if root == nil
node = @root
until node.data == value
  break if node == nil
  if node.data < value
    node = node.right_child
  else
    node = node.left_child
  end
end
node
end

#Returns all of the nodes in the tree by starting at the root and adding each nodes children into a queue. After the root is printed the left child is printed then the right. This process repeats until the queue is empty and the tree has been traversed. The results are flattened to a single array and then returned.
def level_order(root = @root)
result = []
return result if root == nil
queue = []
queue.push(root)

until queue.empty?
  level_size = queue.length?
  level = []
  level_size.times do
    node = queue.shift
    level.push(node.value)
    queue.push(node.left_child) unless node == nil
    queue.push(node.right_child) unless node == nil
end
result.push(level)
end
result.flatten
end

#This method prints the nodes in order of left side, right side, and root.It is done recursively till the node is nill.
def in_order(node = @root)
  return if node.nil?

  in_order(node.left_child)
  print "#{node.data} "
  in_order(node.right_child)
end

#This method prints the nodes in order of root, left side, and right side. It is done recursively till the node is nill
def pre_order(node = @root)
  return if node.nil?

  print "#{node.data} "
  pre_order(node.left_child)
  pre_order(node.right_child)
end

#returns the nodes in order of left, right, root. It is done recursively till the node is empty. 
def post_order(node = @root)
  return "sorry your tree seems to be empty." if node == nil

  
  post_order(node.left_child)
  post_order(node.right_child)
  print "#{node.data} "
end
  
#Finds the height of a certain value based on how many levels it is till the bottom. Height is the longest path. It first finds the nodes position by going left or right depending on the value versus the current node. Once it reaches the node it will add nodes to a queue and depending on if they are right or left children it will add a counter to the respective side. Once the leaf is reached if the left counter is higher that determines height and that number is given (reversed if right is higher.)
def height(value)
node = @root
  return "Sorry your tree seems to be empty" if node == nil

  until node.data == value
    if value < node.data
      node = node.left_child
    else value > node.data
      node = node.right_child
    end
  end
  
  queue = []
  queue.push(node)
  left_counter = 0
  right_counter = 0
  
  until queue.empty?
  level_size = queue.length?
  level = []
  level_size.times do
    node = queue.shift
    queue.push(node.left_child) unless node == nil
    left_counter += 1 unless node == nil
    queue.push(node.right_child) unless node == nil
    right_counter += 1 unless node ==nil
end
end
if left_counter > right_counter
  print "#{values} height is #{left_counter}"
else
  print "#{values} height is #{right_counter}"
end
end

#returns how close the value is to the root so a counter is added to each time you go down a level till the value is reached. Once the calue is reached the value is told to be how ever many counters deep it is.
def depth(value)
  node = @root
  counter = 0
  until node.data == value
    if value < node.data
      node = node.left_child
      counter += 1
    else value > node.data
      node = node.right_child
      counter += 1
    end
  end
    print "#{values} depth is #{counter}"
end

#Returns true or false based on if the array is sorted. it uses the sorted? method to test this and if it returns true then it means the tree is balanced. 
def balanced?(arr = @arr)
 if sorted?(arr) == true
  true
 else
  false
 end
end

#Tests if an array is sorted. works with i representing the index and it stops when you get to the end of the array index. as long as each item is bigger than whats behind it the method contiues. If the i equals the index of the last item it is sorted and returns true if not false. 
def sorted?(arr)
  i = 0
  until i == arr.length - 1
    break if arr[i] > arr[i + 1]
      i += 1
  end
 if i == arr.length - 1
  true
 else
  false
 end
end

#A method to find the root of an array. It takes the middle number in the array. It only really works if the array has first been sorted and all duplicates have been removed.
def find_root(arr)
  root = arr.length/2 
  root
end

#This methos will rebalance the tree by sorting and removing duplicates from the array and reforming the tree. If the tree is already balanced (based on balanced?) it will tell the user that the tree should already be balanced.
def rebalance(arr)
  balanced?(arr)
  if balanced?(arr) == true
    puts "Your tree should already be balanced."
  else balanced?(arr) == false
    arr.sort.uniq
  end
end

#I did not make this but it prints the tree so it looks like a tree!
 def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

end

#test_array = Array.new(15) {rand(1..100)}
test_array = [1,2,4,5,7,6,10]
test = Tree.new(test_array)
test.balanced? 
#test.in_order
#test.pre_order
#test.post_order
test.insert(20)
test.delete(10)
#test.in_order
test.pretty_print