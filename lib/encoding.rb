module Kim

  # Contains methods for handling the encoding of file names
  module Encoding
    def get_filesystem_encoding
      platform = RUBY_PLATFORM
    
      if platform.include?("darwin")
        "UTF-8"
      elsif platform.include?("linux")
        "UTF-8"
      elsif platform.include?("mswin32")
        "windows"
      end
    end

  end
end