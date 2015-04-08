require 'spec_helper'

describe 'TOC::Generator' do 
  before(:each) do 
    @generator = TOC::Generator.new(File.expand_path('../support/example1.js', __FILE__))
    @output    = File.read(File.expand_path('../support/example1-after.js', __FILE__ ))
  end

  it 'identifies sections' do 
    expect(@generator.get_sections).to eq([['Core Properties', 10], ['Special Properties', 16]])
  end

  describe 'create_table method' do 
    before(:each) do 
      @table = File.read(File.expand_path('../support/table.txt', __FILE__))
    end

    it 'returns the table' do 
      expect(@generator.create_table).to eql @table
    end
  end

  describe 'first_after method' do
    before(:each) do 
      @generator = TOC::Generator.new(File.expand_path('../support/example2.txt', __FILE__))
    end

    it 'returns a numeric' do 
      expect(@generator.first_after(2)).to be_a(Numeric)
    end

    it 'returns the appropriate line number' do 
      expect(@generator.first_after(2)).to be(5)
    end
  end

  describe 'no_content? method' do 
    it 'returns true for a line consisting of whitespace' do
      line = '      '
      expect(@generator.no_content? line).to be true
    end

    it 'returns false for a line consisting of code' do
      line = '  var foo = "bar";'
      expect(@generator.no_content? line).to be false
    end

    context 'lines consisting of comments' do
      it 'returns true for the // comment style' do
        line = '// this line is only a comment'
        expect(@generator.no_content? line).to be true
      end

      it 'returns true for the /* comment style' do 
        line = '  /* This is the beginning of a multi-line comment'
        expect(@generator.no_content? line).to be true
      end

      it 'returns true for the end of a multi-line comment' do 
        line = 'and this is the end of the same comment */'
        expect(@generator.no_content? line).to be true
      end

      it 'returns true for a single-line comment using the multi-line syntax' do 
        line = "  /* This is a full-line comment with multi-line syntax */\t"
        expect(@generator.no_content? line).to be true
      end
    end

    context 'lines partially consisting of comments' do 
      it 'returns false for lines containing a // comment' do 
        line = 'var foo = "bar";  // define foo'
        expect(@generator.no_content? line).to be false
      end

      it 'returns false for lines ending with part of a /* comment' do 
        line = 'var foo = bar; /* this is a comment'
        expect(@generator.no_content? line).to be false
      end

      it 'returns false for lines beginning with part of a /* comment' do
        line = 'this is the end of a comment */ var foo = bar;'
        expect(@generator.no_content? line).to be false
      end

      it 'returns false for lines containing a full /* */ comment' do 
        line = 'var foo = /* this is a comment */ bar'
        expect(@generator.no_content? line).to be false
      end
    end
  end
end