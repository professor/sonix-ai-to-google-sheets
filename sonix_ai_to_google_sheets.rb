#!/usr/bin/env ruby

SEPERATOR = "^"

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

def formatted_codes(original_filename, input_filename, output_filename)
  lines = File.readlines(input_filename)

  File.open(output_filename, "w") do |out|

    out.write "Sequence#{SEPERATOR}File#{SEPERATOR}Timestamp#{SEPERATOR}Initial Coding#{SEPERATOR}Quote\n"

    last_timestamp = "[]"

    lines.each_with_index  do |line, index|
      formatted_line = line.strip
      # puts "#{index}----\n"

      next if formatted_line == ""

      timestamp_match = formatted_line.match(/\[[\d\:]*\]/)
      # puts formatted_line
      if timestamp_match
        last_timestamp = timestamp_match[0]
        formatted_line = formatted_line.gsub(last_timestamp , "") # remove timestamp so we can just treat all lines the same
        formatted_line = formatted_line.strip
      end
      # puts formatted_line

      # formatted_line = formatted_line.gsub("\"", "\"\"") # double quote
      formatted_line = formatted_line.gsub("- Quote", "Quote")
      formatted_line = formatted_line.gsub("Quote", "#{SEPERATOR}Quote")

      formatted_line = formatted_line.gsub("- Context", "Context")
      formatted_line = formatted_line.gsub("Context", "#{SEPERATOR}Context")

      # parts = formatted_line.split("Quote")
      # code = parts[0]
      # quote = parts[1]
      # if quote
      #   quote = "Quote " + quote
      # end

      reference_file = original_filename.sub(".txt", "")
      # output_line = "000#{SEPERATOR}#{reference_file}"#{SEPERATOR}"#{last_timestamp}"#{SEPERATOR}"#{code}"#{SEPERATOR}"\"#{quote}\"\n"
      output_line = "000#{SEPERATOR}#{reference_file}#{SEPERATOR}#{last_timestamp}#{SEPERATOR}#{formatted_line}\n"

      out.write output_line
    end
  end
end


filename = ARGV[0]
just_the_codes_filename = filename.sub(".txt", "-just-the-codes.txt")
output_filename = filename.sub(".txt", "-ready-for-google-sheets.txt")

just_the_notes(filename, just_the_codes_filename)
formatted_codes(filename, just_the_codes_filename, output_filename)

