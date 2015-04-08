require 'reactive_support/core_ext/object/instance_variables'

Dir.glob('./lib/**/*.rb').each {|file| require file }
Dir.glob('support/**/*.rb').each {|file| require file }