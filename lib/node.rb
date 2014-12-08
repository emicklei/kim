require "node_iterator"

module Kim
  
  # Represents the abstract node. A super class of <tt>FileNode</tt> and 
  # <tt>DirectoryNode</tt>. A <tt>Node</tt> ancestor is the root of a tree of a
  # <tt>Kim</tt> object.
  class Node
    attr_reader :name, :parent

    include Comparable

    def initialize(name, parent)
      @name = name
      self.parent = parent
    end
    
    def parent=(parent)
      @parent = parent
      if (!parent.nil?)
        parent.children.push(self)
      end
    end
    
    def level
      count = 0
      node = self
      while (node.parent != nil)
        count = count + 1
        node = node.parent
      end
      return count
    end
    
    def goUp(levels)
      node = self
      (1..levels).each do |i|
        node = node.parent
      end
      return node
    end

    def to_s_indent(indentation = 0)
      return (" " * indentation) + @name
    end

    def <=>(oth)
      if oth.nil?
        return 1
      end
      if (self.parent.equal?(oth.parent))
        # Optimization. The else part would have been enough. This optimizes the
        # use case in which lots of nodes of one parent are sorted.
        return compareWithString(self.name, oth.name, oth)
      else
        return compareWithString(self.path, oth.path, oth)
      end
    end
    
    def compareWithString(selfString, othString, oth)
      comparison = selfString <=> othString
      if (comparison == 0)
        if (self.file? && oth.directory?)
          return -1
        elsif (self.directory? && oth.file?)
          return 1
        else
          return 0
        end
      else
        return comparison
      end
    end

    def list(outstream)
      self.each do |node|
        outstream.puts(node.path + "\n")
      end
    end

    def listSorted(outstream)
      self.eachSorted do |node|
        outstream.puts(node.path + "\n")
      end
    end

    def path
      if (parent.nil?)
        @name
      else
        File.join(parent.path(), @name)
      end
    end

    def each
      nodeItr = NodeIterator.new(self)
      while (nodeItr.hasNext?) do
        yield nodeItr.next
      end
    end
    
    def eachSorted
      nodeItr = NodeIterator.new(self, true)
      while (nodeItr.hasNext?) do
        yield nodeItr.next
      end
    end
    
    def compare(node)
      changes = []
      node_count = 0
      oldItr = NodeIterator.new(self, true)
      newItr = NodeIterator.new(node, true)

      oldNode = oldItr.next
      newNode = newItr.next
      if (oldNode.nil? && newNode.nil?)
        node_count = 0
      elsif (not (oldNode.nil? && newNode.nil?))
        node_count = 2
      else
        node_count = 1
      end
      while (not (oldNode.nil? && newNode.nil?))

        #puts "        DEBUG; comparing '#{oldNode}' and '#{newNode}'"

        if (newNode.nil? || (!oldNode.nil? && oldNode < newNode))
          # we encountered a deleted node
          if (oldNode.directory?)
            changes.push Change::directory_deleted(oldNode.path)
          else
            changes.push Change::file_deleted(oldNode.path)
          end
          oldNode = oldItr.next
          node_count = node_count + 1
        elsif (oldNode.nil? || oldNode > newNode)
          # we encountered an added node
          if (newNode.directory?)
            changes.push Change.directory_added(newNode.path)
          else
            changes.push Change.file_added(newNode.path)
          end
          newNode = newItr.next
          node_count = node_count + 1
        else
          # we encountered an existing node
          if (oldNode.file? && newNode.file?)
            if ((oldNode.timestamp <=> newNode.timestamp) != 0 || oldNode.size != newNode.size)
              changes.push Change.file_changed(newNode.path)
            end
          elsif (oldNode.directory? && newNode.directory?)
            if (oldNode.timestamp <=> newNode.timestamp) != 0
              changes.push Change.directory_changed(newNode.path)
            end
          end

          oldNode = oldItr.next
          newNode = newItr.next
          node_count = node_count + 2
        end
      end
      return changes, node_count
    end
    
  end

end