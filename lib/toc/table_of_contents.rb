module TOC
  class TableOfContents
    def initialize
      @beginning = File.readlines(File.expand_path('../../formats/beginning.txt', __FILE__)).join
      @ending = File.readlines(File.expand_path('../../formats/ending.txt', __FILE__)).join
    end

    def self.toc_format
      /^\/(\*{88})\n \*( ){86}\*\n \* CONTENTS( ){71}LINE  \*\n( \* [A-Za-z0-9 ]*\.* [0-9]{1,5} +\*\n)* \*( )+\*\n\/\**\/\n$/
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

    def wrap_content text
      @beginning + "\n" + text + "\n" + @ending
    end
  end
end