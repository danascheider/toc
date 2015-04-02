Dir.glob('./lib/**/*.rb').each {|file| require file }
Dir.glob('support/**/*.rb').each {|file| require file }