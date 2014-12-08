#!/usr/bin/ruby
#
# kim - a filename indexer,searcher and comparer
#
# version 0.1
# by ernest.micklei@philemonworks.com, 2006
# and jasperkalkers@gmail.com, 2007


require "kim"
require "s3_config"
require "s3_kim"

help = <<HELP
kim is a simple filename indexer,searcher and comparer.
(ernest micklei & jasper kalkers, 2007)

usage:
  kim make [path] [storagename]
  kim compare [old] [new]
  kim list [storagename]
  kim s3create [storagename] [s3bucket]
  kim s3update [storagename] [s3bucket]
  kim [regex]
	
examples:
  kim make e:\\  disk0
    scan directory e:\ and make an 
    index file named disk0.kim
	
  kim compare disk0_24122007 disk0_25122007
    create a compare file from two index files
    
  kim lion.*
    search into all .kim files for 
    occurrences of the pattern lion.*
	
  kim list disk0
    produce the complete directory structure 
    from the index file named disk0.kim

  kim s3create disk0 myBucket
    Upload all files from index file disk0.kim to
    the existing (but empty*///*=/*) S3 bucket myBucket.

  kim s3update disk0 myBucket
    Perform all changes between the index file on S3
    and the index file disk0.kim to the existing S3
    bucket myBucket.

HELP

# 
# main
#

arguments = ARGV

if arguments.size == 1
  regex = Regexp.new arguments[0]
  puts Kim::Kim.search(regex)
elsif arguments.size == 2 && arguments[0].downcase == "list"
  kim = Kim::Kim.new(arguments[1])
  kim.list($stdout)
elsif arguments.size == 3 && arguments[0].downcase == "make"
  path = arguments[1]
  now = Time.now
  kim = Kim::Kim.new(arguments[2])
  stream = File.new(kim.filename, "w")
  kim.make(path, stream)
  stream.close
  STDERR.puts "Indexed #{kim.folder_count} folders and #{kim.file_count} files in #{Time.now-now} seconds and written to #{arguments[2]}"
elsif arguments.size == 3 && arguments[0].downcase == "compare"
  now = Time.now
  kim_old = Kim::Kim.new(arguments[1])
  kim_new = Kim::Kim.new(arguments[2])	
  changes, node_count = kim_old.compare(kim_new)
  puts "<changes>"
  changes.each do |change|
    puts "<change><kind>" + change.kind + "</kind><path>" + change.path + "</path></change>"
  end
  puts "</changes>"
  STDERR.puts "Compared #{node_count} nodes in #{Time.now-now} seconds"
elsif arguments.size == 3 && arguments[0].downcase == "s3create"
  kim_filename = arguments[1]
  s3_bucket = arguments[2]
  now = Time.now_f
  new_kim = Kim::Kim.new(kim_filename)
  s3_kim = Kim::S3Kim.new(s3_bucket, new_kim)
  
  if s3Kim.new_mirror?
    s3Kim.create_s3
  else
    STDERR.puts("The bucket already contains a mirror created by kim! Aborting.")
  end
    
  STDERR.puts "Created kim mirror S3 with #{s3Kim.nr_of_changes} changes in #{Time.now-now} seconds"
elsif arguments.size == 3 && arguments[0].downcase == "s3update"
  now = Time.now
  kim = Kim::Kim.new(arguments[1])
  
  STDERR.puts "Updated kim mirror S3 with #{s3Kim.nr_of_changes} changes in #{Time.now-now} seconds"
else 
  puts help
  exit
end
