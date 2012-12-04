require 'digest/md5'

# Author::    John Ryan  (mailto:555john@gmail.com)
# Copyright:: Copyright (c) 2012 John Ryan
# License::   Distributes under the same terms as Ruby

module HashThatTree
 
	class HashIt
    attr_accessor :format  #the format to output the results to. csv, html or json
    attr_accessor :folders #path to folder containing files to hash
    attr_accessor :hash_results #the container for the hashing results
     
	   #initialize the class with the folders to be compared
  	 def initialize(options, folders )
  	   @format = options['output']
  	   @folders = folders
  	   @hash_results = FileHash.new
			 validate
		end
		
		# Validates the supplied folders ensuring they exist
		def validate
			@folders.each do |item|
        if(item==nil) || (item=="") || !Dir.exists?(item)
          puts "a valid folder path is required as argument #{item}"
          exit
        end
        p item
      end
      create_hash_results
		end
		
		# Iterates through the folders and creates a FileHashResults object containing the
    # results of the comparisson
    def create_hash_results
      
      @folders.each do |folder|
        Dir.foreach(folder) do |item|
          begin
            next if item == '.' or item == '..'
            fullfilename = File.expand_path(folder, item)
            the_hash = Digest::MD5.hexdigest(File.read(File.join(File.expand_path(folder), item)))
            item = item.downcase
            @hash_results.add(item, folder, the_hash)
          rescue
            puts "Skipped:#{item.inspect}"
          end
        end
      end
    end
	end
	
	#Container for the results of the file comparisson 
  class FileHash
   
   attr_accessor :hashmap
   
   def initialize()
    @hashmap = Hash.new()
   end
   
   # If this is a new filename add it to the hash list, 
   # otherwise append it to the existing has value
   def add(filename, folder, filehash)
     result = Hash.new
    
     if(!@hashmap.key?(filename))
       result[folder] =  filehash
       @hashmap[filename] = result
     else(@hashmap.key?(filename))
       innerItem = @hashmap[filename]
       innerItem[folder] = filehash
     end
   end
   
  end
  
end