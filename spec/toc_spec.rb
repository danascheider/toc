require 'spec_helper'

describe 'TOC' do 
  before(:each) do 
    @before = File.expand_path('../support/example1.js', __FILE__)
    @after  = File.read(File.expand_path('../support/example1-after.js', __FILE__ ))
  end

  it 'adds a table of contents' do 
    j
    expect(TOC::add_table(@before)).to eq(@after)
  end
end