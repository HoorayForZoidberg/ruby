puts "Ok, let's rename some files! Please be careful, this program will rename ALL files in specified folder!"

i = 0
puts "Path of folder containing files to rename? (omit last \"/\")"
folder_path = gets.chomp
puts "Change file extension? (y/n)"
change_extension = gets.chomp
if (change_extension == "Y") || (change_extension == "y")
  puts "New file extension? (without preceding dot)"
  new_extension = gets.chomp
end
puts "Replace all filenames with new name? (y/n)"
change_file = gets.chomp
if (change_file == "Y") || (change_file == "y")
  puts "New base file name?"
  new_filename = gets.chomp
end
puts "Ok, just to check, these are the files we're going to rename..."
Dir.glob("#{folder_path}/*").each do |file|
  puts file
end
puts "Proceed ? (y/n)"
proceed = gets.chomp
if (proceed == "Y" || proceed == "y")
  Dir.glob("#{folder_path}/*").each do |file|
    unless  (file == ".." || file == ".")
    i += 1
    extension = File.extname(file)
    filename = File.basename(file, ".*")
    puts "Changing #{filename}#{extension} ..."
    if change_extension == ("Y" || "y")
      extension = ".#{new_extension}"
      puts "New extension is #{extension}"
    end
    if (change_file == "Y") || (change_file == "y")
      filename = "#{new_filename}_#{i}"
    end
    File.rename(file, "#{folder_path}/#{filename}#{extension}")
    end
    puts "New filename: #{filename}#{extension}"
  end
  puts "Completed all file name changes!"
else
  puts "Abort! Abort! Abort!"
end

