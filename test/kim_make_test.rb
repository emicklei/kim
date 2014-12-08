$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'kim'

module Kim
  
  class KimMakeTest < Test::Unit::TestCase
    
    def setup
      # Make sure the timestamps of the test-files are as expected
      FileUtils.touch("test/test_make_folder/aFile1.txt", {:mtime => Time.local(2007,12,11,19,13,22,023)})
      FileUtils.touch("test/test_make_folder/aFolder1/aFile2.txt", {:mtime => Time.local(2007,11,29,6,23,2,923)})
      FileUtils.touch("test/test_make_folder/aFolder1/aFile3.txt", {:mtime => Time.local(2007,06,06,12,12,12,121)})
      FileUtils.touch("test/test_make_folder/aFolder2/aFolder3/aFile4.txt", {:mtime => Time.local(2008,1,1,2,54,34,223)})
      FileUtils.touch("test/test_make_folder/aFolder1", {:mtime => Time.local(2006,6,6,14,12,22,451)})
      FileUtils.touch("test/test_make_folder/aFolder2", {:mtime => Time.local(2007,1,1,2,34,34,273)})
      FileUtils.touch("test/test_make_folder/aFolder2/aFolder3", {:mtime => Time.local(2007,1,21,4,44,34,923)})
      FileUtils.touch("test/test_make_folder/empty_folder", {:mtime => Time.local(2007,5,9,2,54,34,273)})
    end
    
    def test_make
      kim = Kim.new("test_make")
      stream = StringIO.new("", "w")
      kim.make("test/test_make_folder", stream, [], [/\/\.svn$/])
      expected_file = File.new(File.join("test", "resources", "test_make.kim"))
      expected = expected_file.read
      expected_file.close
      assert_equal(expected, stream.string, "The kim file created with make is not correct.")
      stream.close
    end
    
    def test_node_make
      # read a kim file from an existing file
      test_file = File.join("test", "resources", "test_make.kim")
      kim = Kim.new("test_node_make")
      expected_file = File.new(test_file)
      kim.buildTree(expected_file)
      expected_file.close
      
      # write the kim file to a string based on the tree
      stream = StringIO.new("", "w")
      kim.write(stream)
      
      # read the contents of the existing test file from disk
      expected_file = File.new(test_file)
      expected = expected_file.read
      expected_file.close
      
      assert_equal(expected, stream.string, "The kim file created with write is not correct.")
      stream.close
    end
    
  end
  
end
