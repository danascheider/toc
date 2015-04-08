require 'spec_helper'

describe TOC::TableOfContents do 
  describe 'initialize' do 
    before(:each) { @toc = TOC::TableOfContents.new }

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
      @toc  = TOC::TableOfContents.new
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
end