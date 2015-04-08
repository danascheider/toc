require 'spec_helper'

describe TOC::TableOfContents do 
  describe 'initialize' do 
    it 'sets the @beginning variable' do 
      beginning = [ 
        "/*****************************************************************************************", 
        " *                                                                                       *", 
        " * CONTENTS                                                                        LINE  *"
        ].join("\n")

      toc = TOC::TableOfContents.new
      expect(toc.instance_values['beginning']).to eql beginning
    end
  end
end