module Kim
  module Testdata
    
    def nilKim
      return Kim.new("nilKim", nil)
    end

    def defaultKim
      root = DirectoryNode.new("", nil, Time.now)
      FileNode.new("abc.txt", root, Time.now, 1234567)
      foo = DirectoryNode.new("foo", root, Time.now)
      FileNode.new("def.rb", foo, Time.now, 8910)
      FileNode.new("ghi.txt", foo, Time.now, 111213)
      bar = DirectoryNode.new("bar", root, Time.now)
      FileNode.new("jkl.rb", bar, Time.now, 141516)
      FileNode.new("mno.txt", bar, Time.now, 17181920)
      return Kim.new("default", root)
    end
    
    def changeFiles(kimInput)
      kim = kimInput.deep_clone()
      changeTime = false
      kim.tree.each do |node|
        if node.file?
          if changeTime
            oldtime = node.timestamp
            node.timestamp = node.timestamp + 3600
          end
          changeTime = !changeTime
        end
      end
      return kim      
    end

    def addFiles(kimInput)
      kim = kimInput.deep_clone()
      kim.tree.each do |node|
        FileNode.new("extraFile", node, Time.now, 67676) if node.directory?
      end
      return kim      
    end

    def deleteFiles(kimInput)
      kim = kimInput.deep_clone()
      kim.tree.each do |node|
        node.children.delete(node.fileChildren[0]) if node.directory?
      end
      return kim      
    end

    def addDirectories(kimInput)
      kim = kimInput.deep_clone()
      kim.tree.each do |node|
        DirectoryNode.new("extraDir", node, Time.now) if node.directory?
      end
      return kim      
    end

    def deleteDirectories(kimInput)
      kim = kimInput.deep_clone()
      kim.tree.each do |node|
        node.children.delete(node.directoryChildren[0]) if node.directory?
      end
      return kim      
    end

    def changeDirectories(kimInput)
      kim = kimInput.deep_clone()
      changeTime = false
      kim.tree.each do |node|
        if node.directory?
          if changeTime
            oldtime = node.timestamp
            node.timestamp = node.timestamp + 3600
          end
          changeTime = !changeTime
        end
      end
      return kim      
    end

  end
end