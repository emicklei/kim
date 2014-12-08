module Kim

  # A kind of <tt>Node</tt> that represents a file. Used for the tree
  # representation of a kim file.
  class FileNode < Node
    attr_accessor :timestamp, :size

    def initialize(name, parent, timestamp = nil, size = nil)
      super(name, parent)
      @timestamp = timestamp
      @size = size
    end

    def to_s_indent(indentation = 0)
      attributesIndent = " " * [0, 60 - indentation - @name.size].max;
      return super + attributesIndent + " (#{timestamp.strftime("%d-%m-%y %H:%M:%S")}, #{size} bytes)"
    end

    def to_s
      "FileNode: " + path
    end

    def directory?
      false
    end

    def file?
      true
    end

    def deep_clone
      return FileNode.new(@name, nil, @timestamp, @size)
    end

  end

end
