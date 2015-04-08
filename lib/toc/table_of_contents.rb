module TOC
  class TableOfContents

    # The +filename+ method returns the filename associated with the
    # generator (see above). 
    # 
    # The +filename=+ method sets the instance's +@filename+ variable 
    # so the same generator can be used on multiple files.

    attr_accessor :filename

    def initialize(filename)
      @filename  = filename
      @beginning = File.readlines(File.expand_path('../../formats/beginning.txt', __FILE__)).join
      @ending    = File.readlines(File.expand_path('../../formats/ending.txt', __FILE__)).join
    end

    # The +create_line+ method takes a section +name+ and line +number+ as arguments. It then
    # returns a table-of-contents entry 90 characters long, incorporating that section name and
    # line number and adding the appropriate periods, asterisks, etc.
    #
    #     table.create_line 'Core Properties', 120
    #       # => ' * Core Properties ................................................................. 120 *'

    def create_line name, number
      beg    = " * #{name} "
      ending = " #{number}  *"
      dots   = "." * (90 - (beg + ending).length)
      beg + dots + ending
    end

    # The +first_after+ method takes a line number as argument +lineno+. Finding that line
    # in the file corresponding to the generator's +filename+, it identifies the first
    # line after that containing actual code. If given +lineno+ contains actual
    # code, that number is returned. For example, given this file:
    #
    #    1|   // This line is a comment
    #    2|   // This line is also a comment
    #    3|   
    #    4|   var foo = 'bar',  // define the foo variable
    #    5|       baz = 'qux'
    #
    #    generator.first_after(1)       # => 4
    #    generator.first_after(4)       # => 4

    def first_after(lineno)
      arr   = File.readlines(@filename)

      arr.each_index do |index|
        if arr[index].match(/^\s*\w+/) && index >= lineno 
          return index + 1
          break
        end
      end
    end

    # The +get_sections+ method looks for comments in the file associated
    # with the TOC::TableOfContents instance of the format recognized as a TOC 
    # section marker. It stores the headings in each of those comments in 
    # the +sections+ array, along with the line number of the comment.
    # Finally, it replaces those line numbers with the line number of the
    # actual code following the comment.
    #
    # Comments that are recognized as section headers take this basic form:
    #
    #     /* Some Arbitrary Text
    #     /***********************************************************/
    #
    # Both of these lines can contain any quantity of whitespace before or
    # after the text or comment markers. The text can contain any characters
    # except newlines. On the second line, there must be at least 20 *
    # characters.

    def get_sections
      sections = []

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

    def wrap_content text
      @beginning + "\n" + text + "\n" + @ending
    end

    private

      # The private +TOC::TableOfContents::toc_format+ method returns a regular expression
      # matching the format of a generated table of contents. This is used internally to 
      # remove existing tables of contents from files prior to adding new ones.

      def self.toc_format
        /^\/(\*{88})\n \*( ){86}\*\n \* CONTENTS( ){71}LINE  \*\n( \* [A-Za-z0-9 ]*\.* [0-9]{1,5} +\*\n)* \*( )+\*\n\/\**\/\n$/
      end
  end
end