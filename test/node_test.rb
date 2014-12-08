# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'node'
require 'file_node'
require 'directory_node'

module Kim

  class Node_test < Test::Unit::TestCase
    
    def test_compare_to_nil
      node = DirectoryNode.new("test", nil)
      assert_equal 1, node <=> nil, "nil is smaller than any directory node"
      node = FileNode.new("test", nil)
      assert_equal 1, node <=> nil, "nil is smaller than any file node"
    end
    
    def test_compare_files_in_root
      node1 = FileNode.new("test1", nil)
      node2 = FileNode.new("test2", nil)
      
      assert_equal(-1, node1 <=> node2, "node1 is smaller than node2")
      assert_equal(1, node2 <=> node1, "node2 is greater than node1")
    end
    
    def test_compare_files_in_same_dir
      directory = DirectoryNode.new("directory")
      node1 = FileNode.new("test1", directory)
      node2 = FileNode.new("test2", directory)
      
      assert_equal(-1, node1 <=> node2, "node1 is smaller than node2")
      assert_equal(1, node2 <=> node1, "node2 is greater than node1")
    end

    def test_compare_files_in_different_dirs_same_level
      directory1 = DirectoryNode.new("directory1")
      directory2 = DirectoryNode.new("directory2")
      node1 = FileNode.new("test1", directory2)
      node2 = FileNode.new("test2", directory1)
      
      assert_equal(1, node1 <=> node2, "node1 is greater than node2")
      assert_equal(-1, node2 <=> node1, "node2 is smaller than node1")
    end

    def test_node_level
      mainroot = DirectoryNode.new("mainroot")
      directory1 = DirectoryNode.new("directory1", mainroot)
      subroot = DirectoryNode.new("a subroot", mainroot)
      directory2 = DirectoryNode.new("directory2", subroot)
      node1 = FileNode.new("test1", directory1)
      node2 = FileNode.new("test2", directory2)
      
      assert_equal 0, mainroot.level, "root node has level 0"
      assert_equal 1, subroot.level, "subroot node has level 1"
      assert_equal 1, directory1.level, "directory1 node has level 1"
      assert_equal 2, directory2.level, "directory2 node has level 2"
    end

    def test_node_goUp
      mainroot = DirectoryNode.new("mainroot")
      directory1 = DirectoryNode.new("directory1", mainroot)
      subroot = DirectoryNode.new("a subroot", mainroot)
      directory2 = DirectoryNode.new("directory2", subroot)
      node1 = FileNode.new("test1", directory1)
      node2 = FileNode.new("test2", directory2)
      
      assert_equal nil, mainroot.goUp(1), "parent of mainroot node is nil"
      assert_equal mainroot, directory1.goUp(1), "parent of directory1 node is mainroot"
      assert_equal nil, directory1.goUp(2), "2nd parent of directory1 node is nil"
      assert_equal subroot, directory2.goUp(1), "parent of directory2 node is subroot"
      assert_equal mainroot, directory2.goUp(2), "2nd parent of directory2 node is mainroot"
      assert_equal nil, directory2.goUp(3), "3d parent of directory2 node is nil"
    end

    def test_compare_files_in_different_dirs_different_levels
      mainroot = DirectoryNode.new("mainroot")
      directory1 = DirectoryNode.new("directory1", mainroot)
      subroot = DirectoryNode.new("a subroot", mainroot)
      directory2 = DirectoryNode.new("directory2", subroot)
      node1 = FileNode.new("test1", directory1)
      node2 = FileNode.new("test2", directory2)
      
      assert_equal(1, node1 <=> node2, "node1 is greater than node2")
      assert_equal(-1, node2 <=> node1, "node2 is smaller than node1")
    end

  end

  
end