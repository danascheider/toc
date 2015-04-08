require 'spec_helper'

describe 'TOC::Generator' do 
  before(:each) do 
    @generator = TOC::Generator.new(File.expand_path('../support/example1.js', __FILE__))
    @output    = File.read(File.expand_path('../support/example1-after.js', __FILE__ ))
  end

  describe 'create_table method' do 
    before(:each) do 
      @table = File.read(File.expand_path('../support/table.txt', __FILE__))
    end

    it 'returns the table' do 
      expect(@generator.create_table).to eql @table
    end
  end
end