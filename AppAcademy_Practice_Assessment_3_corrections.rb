# Define a method that reverses the digits of its argument and returns the resulting number.
# reverse_digits(1738) => 8371
def reverse_digits(int)
  return int.to_s.reverse.to_i
end

# Define a method, #pair_product?, that accepts two arguments: an array of integers and a target_product (an integer). The method returns a boolean indicating whether any pair of elements in the array multiplied together equals that product. You cannot multiply an element by itself. An element on its own is not a product.
# pair_product?([3, 1, 5], 15) => true
def pair_product?(arr, target_product)
  return arr.combination(2).map{|x,y| x * y}.include?(target_product)
end

# Define a method, #slice_between_vowels(word), that accepts a string as an argument. Your method should return the slice of the word between the first and last vowels of that word. Return an empty string if the word has less than 2 vowels.
# slice_between_vowels("serendipity") => "rendip"
# slice_between_vowels("train") => ""
# slice_between_vowels("dog") => ""
def slice_between_vowels(word)
  word_array = word.split('')
  first_vowel_position = 0
  last_vowel_position = 0
  vowel_number = 0
  for i in (0...word_array.length)
    if ['a', 'e', 'i', 'o', 'u'].include?(word_array[i])
      vowel_number +=1
      first_vowel_position = i if vowel_number == 1
      last_vowel_position = i
    end
  end
  if first_vowel_position == last_vowel_position
    result = ""
  else
    result = word_array.slice(first_vowel_position+1, last_vowel_position - first_vowel_position - 1).join('')
  end
  return result
end

require_relative "test.rb"


# test.rb (fixed)

$success_count = 0
$failure_count = 0

def deep_dup(arr)
  arr.inject([]) { |acc, el| el.is_a?(Array) ? acc << deep_dup(el) : acc << el }
end

def note_success(returned, invocation, expectation)
  # removed puts instruction here
  $success_count += 1
end

def note_failure(returned, invocation, expectation)
  puts "failure: #{invocation}: expected #{expectation}, returned #{returned}"
  $failure_count += 1
end

def format_args(args)
  o_args = deep_dup(args)
  o_args.map! do |arg|
    arg = prettify(arg)
    arg.class == Array ? arg.to_s : arg
  end
  o_args.join(', ')
end

def prettify(statement)
  case statement
  when Float
    statement.round(5)
  when String
    "\"#{statement}\""
  when NilClass
    "nil"
  else
    statement
  end
end

def equality_test(returned, invocation, expectation)
  if returned == expectation && returned.class == expectation.class
    note_success(returned, invocation, expectation)
  else
    note_failure(returned, invocation, expectation)
  end
end

def identity_test(returned, invocation, expectation, args)
  if returned.__id__ == args[0].__id__
    equality_test(returned, invocation, expectation)
  else
    puts "failure: #{invocation}: You did not mutate the original array!"
    $failure_count += 1
  end
end

def method_missing(method_name, *args)
  method_name = method_name.to_s
  expectation = args[-1]
  args = args[0...-1]
  if method_name.start_with?("test_")
    tested_method = method_name[5..-1]
    print_test(tested_method, args, expectation)
  else
    method_name = method_name.to_sym
    super
  end
end

def print_test(method_name, args, expectation)
  returned = self.send(method_name, *args)
  returned = prettify(returned)
  expectation = prettify(expectation)
  args_statement = format_args(args)
  invocation = "#{method_name}(#{args_statement})"
  method_name.include?("!") ? identity_test(returned, invocation, expectation, args) : equality_test(returned, invocation, expectation)
  rescue Exception => e
    puts "failure: #{invocation} threw #{e}"
    puts e.backtrace.select {|t| !t.include?("method_missing") && !t.include?("print_test")}
    $failure_count += 1
end
# removed all 'puts' instructions from following lines
test_reverse_digits(1738, 8371)
test_reverse_digits(0, 0)
test_pair_product?([3,1,5], 15,  true)
test_pair_product?([1,5,100], 25, false)
test_slice_between_vowels("serendipity", "rendip")
test_slice_between_vowels("le3t", "")
# removed TOTAL PASSED / FAILED, and added escaped "\" expected in the submission output
puts "#{$success_count} \\/ #{$success_count + $failure_count}"
$success_count = 0
$failure_count = 0