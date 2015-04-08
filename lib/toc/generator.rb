require 'fileutils'
require File.expand_path('../table_of_contents.rb', __FILE__)

module TOC

  # The TOC Generator reads a JavaScript file looking for markers
  # demarcating key sections of the code that should be listed in the
  # table of contents. It is initialized with the name of the file
  # to which the table of contents will be added.
  #
  #     generator = TOC::Generator.new('/home/fred/dev/fredsProject.js')

  class Generator
    # Each generator object is intialized with a +filename+, which is the
    # name of the file to which the table of contents should be added.
    # This filename is assigned to the +@filename+ instance variable, 
    # which is readable and settable using the +filename+ accessor.
    #
    # The +initialize+ method creates a TOC::Formatter object and 
    # stores it in the +@table+ instance variable. It then uses the
    # formatter to generate the table of contents according to the formatting
    # guidelines.
    #
    #     generator = TOC::Generator.new(File.expand_path('./lib/myfile.js', __FILE__))
    #     generator.filename            # => '/home/fred/myproject/lib/myfile.js'

    def initialize(filename)
      @filename  = filename
      @toc       = TOC::TableOfContents.new(filename);
    end

    def create_table
      sections = @toc.get_sections
      offset   = 6 + sections.length

      sections.map! do |section|
        section[1] += offset
        @toc.create_line section[0], section[1].to_s
      end

      sections = sections.join("\n")
      content = @toc.wrap_content sections
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
  end
end