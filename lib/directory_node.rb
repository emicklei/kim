module Kim

  # A kind of <tt>Node</tt> that represents a directory. Used for the tree
  # representation of a kim file.
  class DirectoryNode < Node
    attr_accessor :children, :timestamp

    def initialize(name, parent = nil, timestamp = nil)
      super(name, parent)
      @timestamp = timestamp
      @children = []
    end

    def to_s_indent(indentation = 0)
      attributesIndent = " " * [0, 60 - indentation - @name.size].max;
      return super + attributesIndent + " (#{timestamp.strftime("%d-%m-%y %H:%M:%S")}"
    end

    def to_s_indent(indentation = 0)
      childrenStr = ""
      children.each do |child|
        childrenStr += "\n#{child.to_s_indent(indentation + 2)}"
      end
      attributesIndent = " " * [0, 60 - indentation - @name.size].max;
      dirStr = super + attributesIndent + " (#{timestamp.strftime("%d-%m-%y %H:%M:%S")}"
      return dirStr + "/" + childrenStr
    end

    def to_s
      "DirectoryNode: " + path()
    end
    
    def directory?
      true
    end
    
    def file?
      false
    end

    def fileChildren
      result = []
      self.children.each do |child|
        result.push child if child.file?
      end
      return result
    end
    
    def directoryChildren
      result = []
      self.children.each do |child|
        result.push child if child.directory?
      end
      return result
    end
    
    def deep_clone
      node = DirectoryNode.new(@name)
      node.timestamp = self.timestamp
      @children.each do |child|
        child_copy = child.deep_clone
        child_copy.parent = node
      end
      return node
    end
    
  end

end