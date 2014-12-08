# Module that contains logic for parsing a kim file.
# 
# This module should be included in a class and the following callback methods
# should be implementen:
# 
#    def parsed_header(header)
#    def parsed_start_directory(directoryname)
#    def parsed_file(filename)
#    def parsed_end_directory()
#    def parsed_timestamp(timestampStr)
#    def parsed_size(sizeStr)
#
require "codec"

module Kim

  module Parser
    
    include Codec
    
    def keyword?(ch)
      60 == ch || 124 == ch || 62 == ch || 58 == ch || 63 == ch
    end

    def next_token(stream)
      buffer = ''
      while not(stream.eof?)
        ch = stream.readchar
        if keyword?(ch)
          return ch , unescape(buffer)
        else
          buffer << ch
        end
      end
      return nil , unescape(buffer)
    end

    def parse(kimstream)
      tag = kimstream.readchar
      header = ""
      while !keyword?(tag) && !kimstream.eof?
        header << tag.chr
        tag = kimstream.readchar
      end
      parsed_header(header)
      while not(kimstream.eof?)
        case tag
        when 60 # <
          nexttag , word = next_token kimstream
          parsed_start_directory(word)
        when 124 # |				
          nexttag , word = next_token kimstream
          parsed_file(word)
        when 62 # >
          nexttag , word = next_token kimstream
          parsed_end_directory()
        when 58 # :
          nexttag , word = next_token kimstream
          parsed_timestamp(word)
        when 63 # ?
          nexttag , word = next_token kimstream
          parsed_size(word)
        end
        tag = nexttag
      end
    end
    
  end
  
end
