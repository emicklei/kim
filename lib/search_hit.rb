module Kim
  
  # A part of the result of a search in several kim files. A <tt>SearchHit</tt>
  # contains the filename of the file that is a match of the search operation.
  # It also contains the name of the kimfile the match was made.
  class SearchHit
    
    attr_reader :kimname, :filename 
    
    def initialize(kimname, filename)
      @kimname = kimname
      @filename = filename
    end
    
    def to_s
      return "[#{kimname}] #{filename}"
    end
  end
  
end