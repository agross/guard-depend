require 'guard'
require 'guard/depend'

describe Guard::Depend do
  let(:command) {}
  let(:output_paths) { [] }
  let(:run_on_start) { false }

  subject { described_class.new(cmd: command, output_paths: output_paths, run_on_start: run_on_start) }

  before { subject.runner.stub(:run) }

  before { Guard::UI.stub(:info) }

  describe 'defaults' do
    subject { described_class.new }

    its(:options) { should include(cmd: nil) }
    its(:options) { should include(output_paths: []) }
    its(:options) { should include(run_on_start: false) }
    its(:runner) { should be_an_instance_of(Guard::Depend::Runner) }
    its(:detect) { should be_an_instance_of(Guard::Depend::Detect) }
  end

  describe 'overriding defaults' do
    let(:command) { 'command' }
    let(:output_paths) { '1' }
    let(:run_on_start) { true }

    its(:options) { should include(cmd: 'command') }
    its(:options) { should include(output_paths: '1') }
    its(:options) { should include(run_on_start: true) }
    its(:runner) { should be_an_instance_of(Guard::Depend::Runner) }
    its(:detect) { should be_an_instance_of(Guard::Depend::Detect) }
  end

  describe '#start' do
    before { subject.stub(:run_all) }
    before { subject.start }

    it 'should write info' do
      expect(Guard::UI).to have_received(:info).with("#{described_class} is running")
    end

    context 'run_on_start enabled' do
      let(:run_on_start) { true }

      it 'should run' do
        expect(subject).to have_received(:run_all)
      end
    end

    context 'run_on_start disabled' do
      let(:run_on_start) { false }

      it 'should not run' do
        expect(subject).to_not have_received(:run_all)
      end
    end
  end

  describe '#run_all' do
    let(:command) { 'command' }

    before { subject.runner.stub(:run) }

    before { subject.run_all }

    it 'should run command' do
      expect(subject.runner).to have_received(:run).with('command')
    end
  end

  describe '#run_on_changes' do
    let(:command) { 'command' }

    context 'outdated' do
      before {
        subject.detect.stub(:out_of_date?).and_return(true)
        subject.run_on_changes
      }

      it 'should run command' do
        expect(subject.runner).to have_received(:run).with('command')
      end
    end

    context 'not outdated' do
      before {
        subject.detect.stub(:out_of_date?).and_return(false)
        subject.run_on_changes
      }

      it 'should not run command' do
        expect(subject.runner).to_not have_received(:run)
      end
    end
  end
end
