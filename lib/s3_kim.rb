require "kim"
require "s3sync/s3try"
require "s3sync/s3config"

include S3sync

module Kim
  
  class S3Kim
    
    attr_reader @nr_of_changes 
    
    def initialize(bucket_name, new_kim)
      @bucket_name = bucket_name
      @new_kim = new_kim
      @nr_of_changes = 0
    end
    
    def new_mirror?
      
    end
    
    def determine_changes
      
    end
    
    def create_s3
      
    end
    
    def update_s3
      
    end
    
  end
  
end