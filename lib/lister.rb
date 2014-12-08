require "parser" 

module Kim

  # Responsible for listing the contents of a kim file. Input is a stream of a
  # kim file and a output stream for the list.
  class Lister
    
    include Parser
        
    def list(kimstream, outstream)
      @str = ""
      @path_elements = []
      $outstream = outstream
      parse(kimstream)
    end
    
    def display(word, path_elements)
      return File.join(File.join(path_elements), word)
    end
    
    def parsed_header(header)
      # can be ignored for now
    end
      
    def parsed_start_directory(directoryname)
      $outstream.puts(display(directoryname, @path_elements) + "\n")
      @path_elements.push directoryname 
    end
    
    def parsed_file(filename)
      $outstream.puts(display(filename, @path_elements) + "\n")
    end
    
    def parsed_end_directory()
      @path_elements.pop
    end
    
    def parsed_timestamp(timestampStr)
      # can be ignored
    end
    
    def parsed_size(sizeStr)
      # can be ignored
    end
      
  end
end
