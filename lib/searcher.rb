require "parser" 

module Kim
  
  # Responsible for searching the contents of a kim file. Input is a stream of a
  # kim file as well as a regular expression to which a match must be found.
  class Searcher
    include Parser
    
    def search(kimname, kimstream, regex)
      @path_elements = []
      @hits = []
      @regex = regex
      @kimname = kimname
      parse(kimstream)
      return @hits
    end
    
    def display(word, path_elements)
      return File.join(File.join(path_elements), word)
    end
      
    def test_occurrence(word, path_elements, regex, hits, name)		
      if word =~ regex
        hits.push SearchHit.new(name, display(word, path_elements))
      end				
    end

    def parsed_header(header)
      # can be ignored for now
    end
      
    def parsed_start_directory(directoryname)
      test_occurrence(directoryname, @path_elements, @regex, @hits, @kimname)
      @path_elements.push directoryname
    end
    
    def parsed_file(filename)
      test_occurrence(filename, @path_elements, @regex, @hits, @kimname)
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
