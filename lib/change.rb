module Kim
  
# Represents a change between two directory structures.
# 
# There are six kinds of changes: (the <tt>kind</tt> property)
# * changed file: a file exists in the current and previous structure, but the
#   size of the timestamp has changed
# * added file: a file didn't exist in the previous structure, but is added in
#   the new structure
# * deleted file: a file existed in the previous structure, but it has
#   disappeared in the new structure
# * changed directory: a directory exists in the current and previous structure,
#   but the timestamp has changed
# * added directory: a directory didn't exist in the previous structure, but is
#   added in the new structure
# * deleted directory: a directory existed in the previous structure, but it has
#   disappeared in the new structure
#
# A Change consists of a kind and a path. The <tt>path</tt> represents the file or
# directory that has changed. The <tt>kind</tt> represents the kind of the change.
  class Change
    
    FILE_CHANGED = "FC"
    FILE_ADDED = "FA"
    FILE_DELETED = "FD"
    DIRECTORY_CHANGED = "DC"
    DIRECTORY_ADDED = "DA"
    DIRECTORY_DELETED = "DD"

    attr_reader :kind, :path
    
    def initialize(kind, path)
      @kind = kind
      @path = path
    end
    
    def self.file_changed(path)
    	Change.new(FILE_CHANGED, path)
    end
    
    def self.file_added(path)
    	Change.new(FILE_ADDED, path)
    end
    
    def self.file_deleted(path)
    	Change.new(FILE_DELETED, path)
    end
    
    def self.directory_changed(path)
    	Change.new(DIRECTORY_CHANGED, path)
    end
    
    def self.directory_added(path)
    	Change.new(DIRECTORY_ADDED, path)
    end
    
    def self.directory_deleted(path)
    	Change.new(DIRECTORY_DELETED, path)
    end
    
    def to_s
      "Change #{@kind} #{@path}"
    end
  end
  
end