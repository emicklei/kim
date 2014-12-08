module Kim
  
  # Responsible for iterating a tree of nodes. The iterator can walk the
  # tree sorted or not. The tree is processed breadth first. When the iterator
  # is sorted, the children of a <tt>Node</tt> are sorted when iterated over.
  # The order of children of the original tree node does not change.
  # The NodeIterator is used to implement the <tt>each</tt> <tt>eachSorted</tt>
  # methods.
  class NodeIterator
    
    def initialize(tree, sorted = false)
      @nodes = [tree]
      @sorted = sorted
    end

    def hasNext?
      return !@nodes.nil? && @nodes.size > 0
    end

    def next
      currentNode = @nodes.delete_at(0)
      if ((not currentNode.nil?) && currentNode.directory?)
        children = currentNode.children.clone
        children.sort! if @sorted
        @nodes = children + @nodes
      end
      return currentNode
    end
  end
  
end