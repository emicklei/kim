require "parser" 

module Kim

  # Responsible for building a tree of nodes, based the contents of a kim file.
  # Input is a stream of a kim file.
  class TreeBuilder

    include Parser
        
    def buildTree(kimstream)
      @directoryNodes = []
      @currentNode = nil
      @tree = nil
      parse(kimstream)
      return @tree
    end
    
    def parsed_header(header)
      # can be ignored for now
    end
      
    def parsed_start_directory(directoryname)
      @currentDirectory = @directoryNodes.last
      @currentNode = DirectoryNode.new(directoryname, @currentDirectory)
      @directoryNodes.push @currentNode
      # set root for the first time
      @tree = @currentNode if @tree.nil?
    end
    
    def parsed_file(filename)
      @currentDirectory = @directoryNodes.last
      @currentNode = FileNode.new(filename, @currentDirectory)
    end
    
    def parsed_end_directory()
      @directoryNodes.pop
    end
    
    def parsed_timestamp(timestampStr)
      time = decodeTime(timestampStr)
      @currentNode.timestamp = time

    end
    
    def parsed_size(sizeStr)
      @currentNode.size = sizeStr.to_i
    end

  end

end
