require 'guard'
require 'guard/depend'

describe Guard::Depend::Detect do
  before {
    Guard::UI.stub(:info)
    Guard::UI.stub(:debug)
  }

  describe 'defaults' do
    its(:output_paths) { should be_nil }
  end

  describe 'overriding defaults' do
    subject { described_class.new(1) }

    its(:output_paths) { should == 1 }
  end

  context 'nil changed paths' do
    it 'should not be out of date' do
      subject.out_of_date?(nil).should == false
    end
  end

  context 'omitted changed paths' do
    it 'should not be out of date' do
      subject.out_of_date?.should == false
    end
  end

  context 'no changed paths' do
    it 'should not be out of date' do
      subject.out_of_date?([]).should == false
    end
  end

  shared_examples :reports_files do
    it 'should report newest input' do
      expect(Guard::UI).to have_received(:debug).with(/^Newest input file/)
    end

    it 'should report oldest output' do
      expect(Guard::UI).to have_received(:debug).with(/^Oldest output file/)
    end
  end

  shared_examples :outdated do
    it 'should be out of date' do
      @outdated.should == true
    end

    it 'should not report non-outdatedness' do
      expect(Guard::UI).to_not have_received(:debug).with(/is not outdated with regard to/)
    end
  end

  shared_examples :not_outdated do
    it 'should not be out of date' do
      @outdated.should == false
    end

    it 'should report non-outdatedness' do
      expect(Guard::UI).to have_received(:debug).with('output is not outdated with regard to input')
    end
  end

  context '#out_of_date?' do
    describe 'single input and output' do
      let(:input_mtime) {}
      let(:output_mtime) {}

      before {
        File.stub(:readable?).and_return(false)

        if input_mtime
          File.stub(:readable?).with('input').and_return(true)
          File.stub(:mtime).with('input').and_return(input_mtime)
        end

        if output_mtime
          File.stub(:readable?).with('output').and_return(true)
          File.stub(:mtime).with('output').and_return(output_mtime)
        end
      }

      subject { described_class.new('output') }

      before { @outdated = subject.out_of_date?(%w(input)) }

      context 'output was deleted' do
        let(:input_mtime) { Time.now }

        it_behaves_like :reports_files
        it_behaves_like :outdated
      end

      context 'input was deleted' do
        let(:output_mtime) { Time.now }

        it_behaves_like :reports_files
        it_behaves_like :outdated
      end

      context 'input is newer than output' do
        let(:input_mtime) { Time.at(1) }
        let(:output_mtime) { Time.at(0) }

        it_behaves_like :reports_files
        it_behaves_like :outdated
      end

      context 'input is older than output' do
        let(:input_mtime) { Time.at(0) }
        let(:output_mtime) { Time.at(1) }

        it_behaves_like :reports_files
        it_behaves_like :not_outdated
      end

      context 'input has the same mtime as output' do
        let(:input_mtime) { Time.at(0) }
        let(:output_mtime) { Time.at(0) }

        it_behaves_like :reports_files
        it_behaves_like :not_outdated
      end

      context 'output is callable' do
        let(:output_mtime) { Time.at(0) }

        subject { described_class.new(Proc.new { 'output' }) }

        it 'should call' do
          expect(File).to have_received(:mtime).with('output').at_least(:once)
        end
      end

      context 'output is nil' do
        subject { described_class.new(nil) }

        it_behaves_like :outdated
      end

      context 'output is empty' do
        subject { described_class.new([]) }

        it_behaves_like :outdated
      end
    end

    describe 'multiple inputs' do
      before {
        File.stub(:readable?).and_return(true)

        File.stub(:mtime).with('input old').and_return(Time.at(0))
        File.stub(:mtime).with('input new').and_return(Time.at(1))
        File.stub(:mtime).with('output').and_return(Time.at(0))
      }

      subject { described_class.new(['output']) }

      before { @outdated = subject.out_of_date?(['input old', 'input new']) }

      it 'should use newest input' do
        expect(Guard::UI).to have_received(:debug).with(/^Newest input.+input new$/)
      end
    end

    describe 'multiple outputs' do
      before {
        File.stub(:readable?).and_return(true)

        File.stub(:mtime).with('input').and_return(Time.at(0))
        File.stub(:mtime).with('output old').and_return(Time.at(0))
        File.stub(:mtime).with('output new').and_return(Time.at(1))
      }

      subject { described_class.new(['output new', 'output old']) }

      before { @outdated = subject.out_of_date?(%w(input)) }

      it 'should use oldest output' do
        expect(Guard::UI).to have_received(:debug).with(/^Oldest output.+output old$/)
      end
    end
  end
end
