require 'reactive_support/core_ext/object/instance_variables'
require 'fileutils'

Dir.glob('./lib/**/*.rb').each {|file| require file }
Dir.glob('support/**/*.rb').each {|file| require file }

RSpec.configure do |c|
  c.after(:each) do 
    path = File.expand_path('..', __FILE__);
    FileUtils.cp("#{path}/support/example1.txt", "#{path}/support/example1.js")
  end
end