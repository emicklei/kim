$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'searcher'
require 'kim'

module Kim
  class SearcherTest < Test::Unit::TestCase
    
    def setup
      @startDir = Dir.getwd
      Dir.chdir("test/resources")
    end
    
    def teardown
      Dir.chdir(@startDir)
    end
    
    def test_searcher
      hits = Kim.search(/.*libmysqlclient.*/)
      assert_equal(10, hits.size, "The number of hits is not correct")
    end
    
  end
end
