# 
# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'test/testdata'
require 'kim'

include Kim::Testdata

class CompareTest < Test::Unit::TestCase
  def test_compareEqual
    kim1 = defaultKim
    kim2 = kim1
    
    changes, node_count = kim1.compare(kim2)
    
    assert_equal 0, changes.size, "equal Kim's should have no changes"
  end
  
  def test_compareChangedFiles
    kim1 = defaultKim
    kim2 = changeFiles(kim1)
    
    changes, node_count = kim1.compare(kim2)
    
    fc_count = countChanges(changes, Kim::Change::FILE_CHANGED)
    
    assert_equal 2, fc_count, "Incorrect number of files changed"
    assert_equal 0, changes.size - fc_count, "Only files should be changed"
  end
  
  def test_compareAddedFiles
    kim1 = defaultKim
    kim2 = addFiles(kim1)
    
    changes, node_count = kim1.compare(kim2)
    
    fa_count = countChanges(changes, Kim::Change::FILE_ADDED)
    
    assert_equal 3, fa_count, "Incorrect number of files added"
    assert_equal 0, changes.size - fa_count, "Only files should be added"
    
  end

  def test_compareDeletedFiles
    kim1 = defaultKim
    kim2 = deleteFiles(kim1)
    
    changes, node_count = kim1.compare(kim2)
    
    fd_count = countChanges(changes, Kim::Change::FILE_DELETED)
    
    assert_equal 3, fd_count, "Incorrect number of files deleted"
    assert_equal 0, changes.size - fd_count, "Only files should be deleted"
    
  end

  def test_compareAddedDirs
    kim1 = defaultKim
    kim2 = addDirectories(kim1)
    
    changes, node_count = kim1.compare(kim2)
    
    da_count = countChanges(changes, Kim::Change::DIRECTORY_ADDED)
    
    assert_equal 3, da_count, "Incorrect number of directories added"
    assert_equal 0, changes.size - da_count, "Only directories should be added"
    
  end

  def test_compareDeletedDirs
    kim1 = defaultKim
    kim2 = deleteDirectories(kim1)
    
    changes, node_count = kim1.compare(kim2)
    
    dd_count = countChanges(changes, Kim::Change::DIRECTORY_DELETED)
    fd_count = countChanges(changes, Kim::Change::FILE_DELETED)
    
    assert_equal 1, dd_count, "Incorrect number of directories deleted"
    assert_equal 2, fd_count, "Incorrect number of files deleted"
    assert_equal 0, changes.size - dd_count - fd_count, "Only a directory and its files should be deleted"
    
  end
  
  def test_compareChangedDirs
    kim1 = defaultKim
    kim2 = changeDirectories(kim1)
    
    changes, node_count = kim1.compare(kim2)
    
    dc_count = countChanges(changes, Kim::Change::DIRECTORY_CHANGED)
    
    assert_equal 1, dc_count, "Incorrect number of directories changed"
    assert_equal 0, changes.size - dc_count, "Only directories should be changed"
    
  end

  def countChanges(changes, kind)  
    count = 0
    changes.each do |ch|
      count = count + 1 if ch.kind == kind
    end
    return count
  end
  
end
