require 'maker'

module Kim
  
  # Responsible for creating a kim file based on a node.
  class NodeMaker
    
    include Maker
    
    attr_reader :folder_count, :file_count 

    def initialize
      @folder_count = 0
      @file_count = 0
    end
    
    def make(store, node)
      make_header(store)
      make_internal(store, node)
    end
    
    private
    
    def make_internal(store, node)
      if node.directory?
        make_start_directory(store, node.name, node.timestamp)
        node.children.each do |child|
          make_internal(store, child)
        end
        make_end_directory(store)
      else
        make_file(store, node.name, node.timestamp, node.size)
      end
    end
    
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
