module Kim
  
# Module that contains encoding and decoding methods for reading and writing
# a kim file.
  module Codec
    
    def escape(str)
      cop = String.new(str)
      cop.gsub!("*", "*0")
      cop.gsub!("|", "*1") #124
      cop.gsub!("<", "*2") #60
      cop.gsub!(">", "*3") #62
      cop.gsub!(":", "*4") #58
      cop.gsub!("?", "*5") #63
      return cop
    end

    def unescape(str)
      cop = String.new(str)
      cop.gsub!("*1", "|")
      cop.gsub!("*2", "<")
      cop.gsub!("*3", ">")
      cop.gsub!("*4", ":")
      cop.gsub!("*5", "?")
      cop.gsub!("*0", "*")
      return cop
    end
    
    def encodeTime(time)
      b64Time = escape(Base64.encode64(time._dump))
      return b64Time[0..-2]
    end

    def decodeTime(timeStr)
      return Time._load(Base64.decode64(timeStr + "\n"))
    end
    
  end
end
