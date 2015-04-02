# The table of contents reads a JavaScript file looking for markers
# demarcating key sections of the code that should be listed in the
# table of contents. It takes a string as input.

class TOC
  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end

  def self.add_table
    #
  end

  def no_content? (line)
    false if /^\s*(\/\/|\/\*|(.*)\*\/)?/ =~ line
  end

  def first_after(lineno)
    arr   = File.readlines(@filename)

    arr.each_index do |index|
      if arr[index].match(/^\s*\w+/) && index >= lineno 
        return index + 1
        break
      end
    end
  end

  def get_sections
    sections = []
    line_nos = []
    comment_lines = []

    # Open the file and find the lines that are comments in the format
    # TOC is looking for.

    File.open(filename, 'r+') do |file|
      file.each_line do |line|
        if line.match(/\s*\/\*\s+[a-z]+/i)
          sections << [line.match(/[a-z ]+[a-z]/i).to_s.strip, file.lineno]
        end
      end
    end


    sections.each {|val| val[1] = first_after(val[1]) }

    sections
  end
end