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
      dots   = "." * (89 - (beg + ending).length)
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


    def generate
      sections = get_sections
      sections.each {|section| section[1] += (6 + sections.length)}
      content = wrap_content(generate_content sections)
      content
    end

    def generate_content(sections)
      sections.map! {|section| create_line(section[0], section[1].to_s) }
      sections = sections.join("\n") << "\n"
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

      File.open(@filename, 'r+') do |file|
        file.each_line do |line|
          if line.match(/\s*\/\*\s+[a-z]+/i)
            sections << [line.match(/[a-z ]+[a-z]/i).to_s.strip, file.lineno]
          end
        end
      end

      sections.each {|val| val[1] = first_after(val[1]) }

      sections
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

    def wrap_content text
      @beginning + "\n" + text + @ending + "\n"
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