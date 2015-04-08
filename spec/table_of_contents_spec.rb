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
end