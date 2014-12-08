require 'rubygems'
require 'rake/clean'
require 'rake/gempackagetask'
 
desc "Default Task"
task :default => [ :test, :package ,:install ] 
 
spec = Gem::Specification.new do |s|
  s.name = %q{kim}
  s.version = "0.1"
  s.date = %q{2007-12-25}
  s.summary = %q{Directory Indexer for Search and Compare}
  s.email = %q{ernest.micklei@philemonworks.com}
  s.homepage = %q{http://kim.googlecode.com}
  s.description = %q{Create a metadata file from a directory to search and compare}
  s.autorequire = %q{}
  s.has_rdoc = true
  s.authors = ["Ermest Micklei", "Jasper Kalkers"]
  # bin
  s.files += Dir.new('./bin').entries.select{|e| e =~ /^[^.]/}.collect{|e| 'bin/'+e}
  # lib
  s.files += Dir.new('./lib').entries.select{|e| e =~ /\.rb$/}.collect{|e| 'lib/'+e}

  s.test_files = Dir.new('./test').entries.select{|e| e =~ /^[^.].*\.rb$/}.collect{|e| 'test/'+e}
  s.rdoc_options = ["--title", "kim -- Search and Compare Directory Metadata", "--main", "README", "--line-numbers"]
  s.extra_rdoc_files = ['README']
  s.executables = ["kim"]   
  #s.add_dependency('builder', '>= 1.2.4')
end

Rake::GemPackageTask.new(spec) do |pkg| end

task :install do
  Gem::GemRunner.new.run(['install','pkg/kim'])
end

desc "Unit tests for Kim"
task :test do
  $: << 'test'
  Dir.new('./test').entries.each { |e| 
    load e if e =~ /_test.rb$/
  }
end

desc 'Measures test coverage'
task :coverage do
  
  puts File.expand_path(".")
  
  rm_rf "coverage"
  rcov = "rcov --text-summary -Ilib"
  system("#{rcov} --html test/*_test.rb")
  system("open coverage/index.html") if PLATFORM['darwin']
end