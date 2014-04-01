require 'guard'
require 'guard/depend'

describe Guard::Depend::Runner do
  before {
    allow(Guard::UI).to receive(:info)
    allow(Guard::UI).to receive(:error)
    allow(Guard::UI).to receive(:debug)

    allow(Guard::Notifier).to receive(:notify)
  }

  let(:error) { nil }

  before {
    next allow(subject).to receive(:sh).and_raise(error) if error
    allow(subject).to receive(:sh)
  }

  describe 'command execution' do
    context 'no command' do
      before { subject.run(nil) }

      it 'should not run' do
        expect(subject).to_not have_received(:sh)
      end
    end

    context 'command without parameters' do
      before { subject.run('command') }

      it 'should run using #sh' do
        expect(subject).to have_received(:sh).with('command')
      end
    end

    context 'command with parameters' do
      before { subject.run(%w(command arg)) }

      it 'should run using #sh' do
        expect(subject).to have_received(:sh).with('command', 'arg')
      end
    end
  end

  describe 'reporting' do
    before { subject.run(%w(command arg)) }

    context 'success' do
      it 'should report command running info' do
        expect(Guard::UI).to have_received(:info).with("Running 'command arg'")
      end

      it 'should notify running' do
        expect(Guard::Notifier).to have_received(:notify).with('command arg', title: 'Running', image: :success)
      end

      it 'should notify success' do
        expect(Guard::Notifier).to have_received(:notify).with('command arg succeeded', title: 'Success', image: :success)
      end
    end

    context 'failure' do
      let(:error) { StandardError.new('something bad happened') }

      it 'should report command running info' do
        expect(Guard::UI).to have_received(:info).with("Running 'command arg'")
      end

      it 'should report command failure error' do
        expect(Guard::UI).to have_received(:error).with("Failed to run 'command arg'. Exception was: StandardError: something bad happened")
      end

      it 'should report command failure backtrace' do
        expect(Guard::UI).to have_received(:debug)
      end

      it 'should notify running' do
        expect(Guard::Notifier).to have_received(:notify).with('command arg', title: 'Running', image: :success)
      end

      it 'should notify failure' do
        expect(Guard::Notifier).to have_received(:notify).with('command arg failed with something bad happened', title: 'Failed', image: :failed)
      end
    end
  end
end
