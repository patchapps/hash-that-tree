require 'digest/md5'

# Author::    John Ryan  (mailto:555john@gmail.com)
# Copyright:: Copyright (c) 2012 John Ryan
# License::   Distributes under the same terms as Ruby

# The program takes two directories and creates a MD5 hash for every file contained within.
# It then builds a result set that compares files with the same name and allows for them to be outputted
# as a csv string
module HashThatTree
  
  # This class accepts two folders and provides methods to iterate
  # through them creating a hash of each file within and can display 
  # the results for analysis 

	class MD5Compare
    attr_accessor :folder1, :folder2
	 
	    #initialize the class with the folders to be compared
  		def initialize(folder1, folder2)
			@folder1 = folder1
			@folder2 = folder2
			@filehash = Hash.new
			validate
		end
		
		# Validates the input ensuring the arguments are both valid folders
		def validate
			if(folder1==nil) || (folder1=="") || !Dir.exists?(folder1)
				puts "a valid folder path is required as argument 1"
				exit
			end
					
			if(folder2==nil) || (folder2=="")  || !Dir.exists?(folder2)
				puts "a valid folder path is required as argument 2"
				exit
			end
			
		end
		
		# Iterates through the folders and creates a FileHashResults object containing the
		# results of the comparisson
		def compare
			
			Dir.foreach(@folder1) do |item|
				next if item == '.' or item == '..'
				item = item.downcase
				the_hash = Digest::MD5.hexdigest(File.read(File.join(@folder1, item)))
				filedata = FileHashResults.new(item, the_hash, nil)
				@filehash[item] = filedata
			end

			Dir.foreach(@folder2) do |item|
				next if item == '.' or item == '..'
				item = item.downcase
				the_hash = Digest::MD5.hexdigest(File.read(File.join(@folder2, item)))
				if(@filehash[item]==nil)
					filedata = FileHashResults.new(item, nil, the_hash)
					@filehash[item] = filedata
					next
				end
				@filehash[item.downcase].file_hash2 = the_hash	
			end
		end

    #Dumps the contents of the FileHashResults object in csv form to standard out 
		def display_results
			puts "FileName,#{@folder1},#{@folder2},Are Equal"
			@filehash.each{ |key, value| puts "#{value.file_name},#{value.file_hash1},#{value.file_hash2}, #{value.file_hash1==value.file_hash2}" }
		end
		
	end
	
	#Container for the results of the file comparisson 
	class FileHashResults
   attr_accessor :file_name, :file_hash1, :file_hash2
   def initialize(file_name, file_hash1, file_hash2)
    @file_name = file_name
    @file_hash1 = file_hash1
    @file_hash2 = file_hash2
    end
  end

	htt = MD5Compare.new(ARGV[0], ARGV[1])
	htt.compare
	htt.display_results
end
