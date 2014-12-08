$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'kim'

class ChangeTest < Test::Unit::TestCase
  
  def test_fileChanged
  	ch = Kim::Change.file_changed("what.txt")
  	assert ch.class == Kim::Change  
  end
  
end #class