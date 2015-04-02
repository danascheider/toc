class TOC
  MAJOR  = 0
  MINOR  = 1
  PATCH  = 0
  SUFFIX = nil

  def self.gem_version
    SUFFIX ? "#{MAJOR}.#{MINOR}.#{PATCH}.#{SUFFIX}" : "#{MAJOR}.#{MINOR}.#{PATCH}"
  end
end