module TOC
  MAJOR  = 0
  MINOR  = 0
  PATCH  = 1
  SUFFIX = 'alpha'

  def self.gem_version
    SUFFIX ? "#{MAJOR}.#{MINOR}.#{PATCH}.#{SUFFIX}" : "#{MAJOR}.#{MINOR}.#{PATCH}"
  end
end