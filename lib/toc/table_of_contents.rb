module TOC
  class TableOfContents
    def initialize
      @beginning = File.readlines(File.expand_path('../../formats/beginning.txt', __FILE__)).join
      @ending = File.readlines(File.expand_path('../../formats/ending.txt', __FILE__)).join
    end

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