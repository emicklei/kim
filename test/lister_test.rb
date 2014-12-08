$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'lister'
require 'kim'
require 'stringio'
require 'test/testdata'

include Kim::Testdata

module Kim

  class ListerTest < Test::Unit::TestCase
    
    def test_list      
      kim = Kim.new("test")
      kimstream = File.new(File.join("test", "resources", kim.filename))
      outstream = StringIO.new("", "w")
      Lister.new.list(kimstream, outstream)
      kimstream.close
      test_list = File.new(File.join("test", "resources", "test_list.txt"))
      expected = test_list.read
      test_list.close
      assert_equal(expected, outstream.string, "The list of test.kim is not correct.")
      outstream.close
    end

    def test_kim_list      
      kim = Kim.new(File.join("test", "resources", "test"))
      outstream = StringIO.new("", "w")
      kim.list(outstream)
      test_list = File.new(File.join("test", "resources", "test_list.txt"))
      expected = test_list.read
      test_list.close
      assert_equal(expected, outstream.string, "The list of test.kim is not correct.")
      outstream.close
    end

    def test_kim_listSorted
      kim = Kim.new(File.join("test", "resources", "test.kim"))
      outstream = StringIO.new("", "w")
      kim.listSorted(outstream)
      test_list = File.new(File.join("test", "resources", "test_list_sorted.txt"))
      expected = test_list.read
      test_list.close
      assert_equal(expected, outstream.string, "The sorted list of test.kim is not correct.")
      outstream.close
    end

    def test_kim_listTree
      kim = defaultKim
      outstream = StringIO.new("", "w")
      #outstream = File.new("test/resources/test_listTree.txt", "w")
      kim.list(outstream)
      test_list = File.new(File.join("test", "resources", "test_listTree.txt"))
      expected = test_list.read
      test_list.close
      assert_equal(expected, outstream.string, "The sorted list of test.kim is not correct.")
      outstream.close
    end

    def test_kim_listTreeSorted
      kim = defaultKim
      outstream = StringIO.new("", "w")
      kim.listSorted(outstream)
      test_list = File.new(File.join("test", "resources", "test_listTree_sorted.txt"))
      expected = test_list.read
      test_list.close
      assert_equal(expected, outstream.string, "The sorted list of test.kim is not correct.")
      outstream.close
    end

  end

end