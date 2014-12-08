require 'codec'
require 'encoding'

module Kim
  
  # Responsible for the contents of a kim file. This module contains the method
  # that determine the format of a kim file.
  module Maker
    include Codec
    include Encoding
    
    def make_header(store)
      store << 'kim version="a" encoding="' + get_filesystem_encoding + "\"\n"
    end
    
    def make_start_directory(store, directoryname, timestamp)
      store << '<' << escape(directoryname) << ':' << encodeTime(timestamp)
    end

    def make_file(store, filename, timestamp, size)
      store << '|' << escape(filename) << ':' << encodeTime(timestamp) << '?' << size.to_s
    end
        
    def make_end_directory(store)
      store << '>'
    end
  
  end

end