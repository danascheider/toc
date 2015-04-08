require 'spec_helper'

describe 'TOC::Generator' do 
  before(:each) do 
    @generator = TOC::Generator.new(File.expand_path('../support/example1.js', __FILE__))
    @output    = File.read(File.expand_path('../support/example1-after.js', __FILE__ ))
  end

  describe 'prepend_table' do 
    it 'calls prepare_file' do 
      expect_any_instance_of(TOC::Generator).to receive(:prepare_file)
      @generator.prepend_table
    end

    it 'prepends the table of contents' do 
      @generator.prepend_table
      expected = File.read(File.expand_path('../support/example1-after.js', __FILE__))
      actual   = File.read(File.expand_path('../support/example1.js', __FILE__))
      expect(actual.chomp).to eql expected.chomp
    end
  end
end