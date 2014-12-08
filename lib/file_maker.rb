require 'maker'

module Kim
  
  # Responsible for creating a kim file of a directory structure.
  class FileMaker
    
    include Maker
    
    attr_reader :folder_count, :file_count 

    def initialize(ignoreFilesRegExs, ignoreDirsRegExs)
      @ignoreFilesRegExs = ignoreFilesRegExs
      @ignoreDirsRegExs = ignoreDirsRegExs
      @folder_count = 0
      @file_count = 0
    end
    
    def make(store, path, dir)
      if path.size == 0 
        make_header(store)
        eachdir = dir
      else 
        eachdir = File.join(path,dir)
      end
      make_start_directory(store, dir, File.mtime(eachdir))
      Dir.new(eachdir).each{|e| 	
        eFilename = File.join(eachdir,e)
        if '.' == e
        elsif '..' == e
        elsif File.symlink?(eFilename)
          #TODO what should we do with symbolic links? For now ignore them
          STDERR.puts("WARNING: the symbolic link '#{eFilename}' is ignored!")
        elsif File.directory?(eFilename) # is directory?
          if not matchRegExs(eFilename, @ignoreDirsRegExs)
            @folder_count += 1
            make(store,eachdir,e)
          end
        elsif File.file?(eFilename)
          if not matchRegExs(eFilename, @ignoreFilesRegExs) 
            @file_count += 1
            eStat = File.stat(eFilename)
            make_file(store, e, eStat.mtime, eStat.size())
          end
        end # else: ignore the entry
      }
      make_end_directory(store)
    end

    private
    
    def matchRegExs(path, regExs)
      matched = nil
      regExs.each do |regEx|
        matched = path.match(regEx)
        break if matched
      end
      result = !matched.nil?
      return result
    end
    
  end
end
