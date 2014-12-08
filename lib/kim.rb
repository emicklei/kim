require "base64"
require "node"
require "file_node"
require "directory_node"
require "node_iterator"
require "search_hit"
require "change"
require "lister"
require "tree_builder"
require "searcher"
require "file_maker"
require "node_maker"

module Kim
  
  EXTENSION = "kim"

  # Main class representing a directory structure. Contains methods for all
  # functionality that is exported via de kim script.
  class Kim
    
    attr_reader :name, :folder_count, :file_count, :node_count
    attr_accessor :tree 
    
    def initialize(name, tree = nil)
      # check for extension
      if name.match(Regexp.new("[.]#{EXTENSION}$")).nil?
        @kimname = name
      else
        @kimname = name[0..-(EXTENSION.length + 2)]
      end
      @tree = tree
    end

    def filename
      @kimname + "." + EXTENSION
    end
    
    #
    # make always includes the root directory. Even if it matches a regular
    # expression in ignoreDirsRegExs.
    def make(dir, stream, ignoreFilesRegExs = [], ignoreDirsRegExs = [])
      if not @tree.nil?
        raise KimException.new("make can only be called for a Kim object without a tree")
      end
      fileMaker = FileMaker.new(ignoreFilesRegExs, ignoreDirsRegExs)
      fileMaker.make(stream, '', dir)
      @folder_count = fileMaker.folder_count
      @file_count = fileMaker.file_count
    end
    
    def write(stream)
      if @tree.nil?
        raise KimException.new("write can only be called for a Kim object with a tree")
      end
      nodeMaker = NodeMaker.new()
      nodeMaker.make(stream, tree)
      @folder_count = nodeMaker.folder_count
      @file_count = nodeMaker.file_count
    end
    
    def self.search(regex)
      hits = []
      Dir.new('.').each{|e|
        if e =~ Regexp.new("." + EXTENSION + "$")
          kimname = e[0..-5]
          kim = Kim.new(kimname)
          hits += kim.seek(regex)
        end
      }
      return hits
    end

    def to_s
      "Kim: #{@kimname}"
    end

    def list(outstream)
      if @tree.nil?
        return listFile(outstream)
      else
        return @tree.list(outstream)
      end
    end
    
    def listSorted(outstream)
      buildTree
      return @tree.listSorted(outstream)
    end
    
    def compare(otherKim)
      buildTree
      otherKim.buildTree
      return @tree.compare(otherKim.tree)
    end
    
    def deep_clone
      kim = Kim.new(@kimname)
      if not @tree.nil?
        kim.tree = @tree.deep_clone
      end
      return kim
    end

    def seek(regex)
      kimfile = File.new filename
      hits = Searcher.new.search(@kimname, kimfile, regex)
      kimfile.close
      return hits
    end

    def buildTree(stream = nil)
      if @tree.nil?
        mustclose = false
        if stream.nil?
          stream = File.new(filename)
          mustclose = true
        end
        @tree = TreeBuilder.new.buildTree(stream)
        stream.close if mustclose
      end
    end
    
    protected
    
    def listFile(outstream)
      kimstream = File.new(self.filename)
      Lister.new.list(kimstream, outstream)
      kimstream.close
    end

  end
end