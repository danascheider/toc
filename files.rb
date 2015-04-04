module TOC
  def self.files
    Files::FILES
  end

  module Files
    BIN_FILES  = Dir.glob('./bin/**/*').sort
    LIB_FILES  = Dir.glob('./lib/**/*.rb').sort
    SPEC_FILES = Dir.glob('./spec/**/*.rb').sort
    FORMATS    = Dir.glob('./lib/formats/*.txt').sort
    BASE_FILES = %w(files.rb Gemfile LICENSE toc.gemspec README.md version.rb)

    FILES = [LIB_FILES, SPEC_FILES, FORMATS, BASE_FILES]
  end
end