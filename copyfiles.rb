require 'fileutils'

files = {}
folder_path = nil
prefix = nil
excluded_folder_paths = []
excluded_prefixes = []
proceed = false
pinwheel = %w{| / - \\}

puts "Ok, let's copy some files!"
puts "Let's get started. First, in which folder are your files located?"

folder = gets.chomp
folder ||= Dir.home

puts ""
puts "Thank you. Your chosen directory is #{folder}"
puts "Now, what file extensions do you want to copy?"
puts "(without the preceding \"\.\" and comma separated please - e.g. \"jpg, jpeg, png\")"

file_type_string = gets.chomp
file_type_array = file_type_string.split(", ")

until proceed
  files = {}
  puts ""
  puts "Any specific folder paths you would like to exclude?"
  puts "(just type \"done\" when ready)"
  until folder_path == "done"
    folder_path = gets.chomp
    excluded_folder_paths <<  folder_path
  end
  folder_path = nil

  puts ""
  puts "Alright. Any file prefixes you'd like to ignore?"
  puts "-- a common one for images is \"thumb_\", for example"
  puts "(just type \"done\" when ready)"
  until prefix == "done"
    prefix = gets.chomp
    excluded_prefixes << prefix
  end
  prefix = nil


  file_type_array.each do |extension|
    Dir.glob("#{folder}/**/*.#{extension}").each do |path|
      unless excluded_folder_paths.include?(path)
        file_name = File.basename(path, extension)
        unless excluded_prefixes.any?{|prefix| file_name.match(/^(#{Regexp.escape(prefix)})/i)}
          file_size = File.size(path)
          key_name = "#{file_name}_#{file_size.to_s}"
          files[key_name] = path unless files.key?(key_name)
          print "\b" + pinwheel.rotate!.first
        end
      end
    end
  end

  puts "the files to copy would be these..."
  total_size = 0
  files.each do |_, path|
    puts "#{File.basename(path)} of size #{File.size(path)} at #{File.dirname(path)}"
    total_size += File.size(path)
  end
  puts ""
  puts "That's #{files.size} files, totaling #{total_size / 1048576} MB"
  puts ""
  puts "Do you want to continue, or specify more folders and prefixes to exclude?"
  puts "1) CONTINUE"
  puts "2) ADD MORE EXCLUSIONS"
  decision = gets.chomp
  proceed = true if decision == "1"
end

puts "Now, what directory would you like to copy your files into?"
target_directory = gets.chomp

puts ""
puts "Your target directory is #{target_directory}. Are you ready to proceed? (Y/N)"
decision = gets.chomp

if decision == "Y"
  files.each do |_, path|
    file_name = File.basename(path)
    FileUtils.mkdir_p(target_directory)
    FileUtils.cp(path, "#{target_directory}/#{file_name}")
    puts "Copying #{file_name} to #{target_directory}/#{file_name}"
  end
  puts "Done! All your files have been copied to your destination directory!"
else
  puts "No files were harmed in the running of this program ;)"
end
