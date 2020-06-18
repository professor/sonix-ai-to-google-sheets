#!/usr/bin/env ruby

def just_the_notes(input_filename, output_filename)
  print_output = false

  File.open(output_filename, "w") do |out|
    File.open(input_filename).each do |line|
      case line
      when "NOTES\n"
        puts "MATCH!"
        print_output = true
      when "TRANSCRIPT\n"
        print_output = false
      else
        out.write line if print_output
      end
    end
  end
end

def close_out_line(lines, index)
  if index + 1 == lines.size
    # last line
    return true
  end

  if lines[index +1][0] == "["
    return true
  end

  false
end

def formatted_codes(original_filename, input_filename, output_filename)
  lines = File.readlines(input_filename)

  File.open(output_filename, "w") do |out|

    out.write "Timestamp, File, Initial Coding"

    lines.each_with_index do |line, index|
      formatted_line = line.gsub("\"", "\"\"") # double quote
      formatted_line = formatted_line.gsub("] ", "]^") # insert seperator

      formatted_line = formatted_line.gsub("^", "^\"") #start

      if close_out_line(lines, index)
        formatted_line = formatted_line.strip + "\"" + "\n" # end
      end

      formatted_line = formatted_line.gsub("^", "^#{original_filename}^") # insert filename

      out.write formatted_line
    end
  end
end


filename = ARGV[0]
just_the_codes_filename = filename.sub(".txt", "-just-the-codes.txt")
output_filename = filename.sub(".txt", "-ready-for-google-sheets.txt")

just_the_notes(filename, just_the_codes_filename)
formatted_codes(filename, just_the_codes_filename, output_filename)

