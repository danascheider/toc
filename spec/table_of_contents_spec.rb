require 'spec_helper'

describe TOC::TableOfContents do 
  before(:each) do
    @toc    = TOC::TableOfContents.new(File.expand_path('../support/example1.js', __FILE__))
    @output = File.read(File.expand_path('../support/example1-after.js', __FILE__))
  end

  describe 'get_sections' do 
    it 'identifies sections' do 
      expect(@toc.get_sections).to eq([['Core Properties', 10], ['Special Properties', 16]])
    end
  end

  describe 'initialize' do 
    it 'sets the @beginning variable' do 
      beginning = [
        "/\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\n", 
        " \*                                                                                       \*\n", 
        " \* CONTENTS                                                                        LINE  \*"
        ].join

      expect(@toc.instance_values['beginning']).to eql beginning
    end

    it 'sets the @ending variable' do 
      ending = [
        " \*                                                                                       \*\n", 
        "/\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*/\n"
        ].join
      expect(@toc.instance_values['ending']).to eql ending
    end
  end

  describe 'create_line' do 
    before(:each) do 
      @name = 'Core Properties'
      @num  = 20
    end

    it 'includes the name at the beginning' do 
      expect(@toc.create_line @name, @num).to match(/^ \* Core Properties/)
    end

    it 'includes the number at the end' do 
      expect(@toc.create_line @name, @num).to match(/ 20  \*( )?$/)
    end
  end

  describe 'first_after method' do
    before(:each) do 
      @toc.filename = (File.expand_path('../support/example2.txt', __FILE__))
    end

    it 'returns a numeric' do 
      expect(@toc.first_after(2)).to be_a(Numeric)
    end

    it 'returns the appropriate line number' do 
      expect(@toc.first_after(2)).to be(5)
    end
  end
end