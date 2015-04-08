require 'fileutils'
require File.expand_path('../formatter.rb', __FILE__)

module TOC

  # The TOC Generator reads a JavaScript file looking for markers
  # demarcating key sections of the code that should be listed in the
  # table of contents. It is initialized with the name of the file
  # to which the table of contents will be added.
  #
  #     generator = TOC::Generator.new('/home/fred/dev/fredsProject.js')

  class Generator
    attr_accessor :filename

    def initialize(filename)
      @filename  = filename
      @formatter = TOC::Formatter.new;
    end

    def create_table
      sections = get_sections
      offset   = 6 + sections.length

      sections.map! do |section|
        section[1] += offset
        @formatter.create_line section[0], section[1].to_s
      end

      sections = sections.join("\n")
      content = @formatter.wrap_content sections
    end

    def prepend_table
      table = create_table

      var new_file_name = @filename + '.tmp'
      File.open(new_file_name, 'w+') do |file|
        file.puts table

        File.readlines(@filename) do |line|
          file.puts line
        end
      end

      FileUtils.mv(new_filename, @filename)
    end

    # The +#no_content?+ analyzes the given +line+ to check whether it is an actual 
    # line of code or a comment. The +#no_content?+ method returns +true+ under the
    # following circumstances:
    #   1. The line begins with either +//+ or with whitespace followed immediately
    #      by +//+ (i.e., it is a single-line comment)
    #   2. The line begins with either +/*+ or with whitespace followed immediately
    #      by +/*+ and contains either no +*/+ ending or no text after any +*/+ (i.e.,
    #      it is the beginning of a multi-line comment or is a single-line comment that
    #      uses the multi-line syntax)
    #   3. The line ends with +*/+ and either contains no +/*+ opener or the +/*+ are the
    #      first non-whitespace characters on the line (i.e., it is the end of a multi-
    #      line comment or consists solely of a single-line comment that uses the multi-
    #      line syntax)
    #   4. The line consists of whitespace only
    #
    # The +#no_content?+ method returns +false+ if the line contains code or if it is
    # part of a multi-line comment but has no comment delineators itself. This will be
    # changed in future versions but was not an MVP feature. 

    def no_content? line
      # match lines starting with //
      slash_matcher          = /^\s*(\/\/)/

      # match lines starting with /* and not containing a */ elsewhere in the line
      multi_line_matcher     = /^\s*((\/)?\*)(.*)[^(\*\/)]$/

      # match lines consisting of only the end of a /* */ comment 
      multi_line_end_matcher = /^(.*)\*\/(\s*)$/

      # match lines that consist of white space only
      space_matcher          = /^\s*$/

      [slash_matcher, multi_line_matcher, multi_line_end_matcher, space_matcher].each do |regex|
        return true if line =~ regex
      end

      return false
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
end