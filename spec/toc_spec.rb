require 'spec_helper'

describe 'TOC' do 
  before(:each) do 
    @toc      = TOC.new(File.expand_path('../support/example1.js', __FILE__))
    @output   = File.read(File.expand_path('../support/example1-after.js', __FILE__ ))
  end

  it 'identifies sections' do 
    expect(@toc.get_sections).to eq([['Core Properties', 10], ['Special Properties', 16]])
  end

  describe 'first_after method' do
    before(:each) do 
      @toc    = TOC.new(File.expand_path('../support/example2.txt', __FILE__))
    end

    it 'returns a numeric' do 
      expect(@toc.first_after(2)).to be_a(Numeric)
    end

    it 'returns the appropriate line number' do 
      expect(@toc.first_after(2)).to be(5)
    end
  end

  # it 'adds a table of contents' do 
  #   expect(TOC.add_table).to eq(@output)
  # end
end