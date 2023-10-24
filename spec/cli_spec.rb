# frozen_string_literal: true

require 'cli'
require 'rspec'

describe CLI do
  describe '#option_parser' do
    it do
      expect(subject.option_parser).to be_kind_of(OptionParser)
    end

    describe '#parse' do
      %w[-V --version].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          it "must print the CLI's version" do
            expect(subject).to receive(:exit)

            expect { subject.option_parser.parse(argv) }
              .to output("#{described_class::PROGRAM_NAME} #{described_class::VERSION}#{$/}")
              .to_stdout
          end
        end
      end

      %w[-h --help].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          it 'must print the option parser --help output' do
            expect(subject).to receive(:exit)

            expect { subject.option_parser.parse(argv) }
              .to output(subject.option_parser.to_s)
              .to_stdout
          end
        end
      end
    end
  end

  describe '.run' do
    subject { described_class }

    context 'when Interrupt is raised' do
      before do
        expect_any_instance_of(described_class).to receive(:run).and_raise(Interrupt)
      end

      it 'must exit with 130' do
        expect(subject.run([])).to eq(130)
      end
    end

    context 'when Errno::EPIPE is raised' do
      before do
        expect_any_instance_of(described_class).to receive(:run).and_raise(Errno::EPIPE)
      end

      it 'must exit with 0' do
        expect(subject.run([])).to eq(0)
      end
    end
  end

  describe '#run' do
    context 'when an valid option is given' do
      let(:opt) { '--u users.json --c clients.json' }

      it 'returns 0 exit code' do
        expect { expect(subject.run(opt)).to eq(0) }
      end
    end

    context 'when an invalid option is given' do
      let(:opt) { '--foo' }

      it "prints '#{described_class::PROGRAM_NAME}: invalid option ...' to $stderr and exit with -1" do
        expect { expect(subject.run(opt)).to eq(-1) }
          .to output("#{described_class::PROGRAM_NAME}: invalid option: #{opt}\n").to_stderr
      end
    end

    context 'when another type of Exception is raised' do
      let(:exception) { RuntimeError.new('error!') }

      before do
        expect(subject).to receive(:generate_report).and_raise(exception)
      end

      it 'must print a backtrace and exit with -1' do
        expect { expect(subject.run([])).to eq(-1) }
          .to output(/Please report the following text to: #{Regexp.escape(described_class::BUG_REPORT_URL)}/)
          .to_stderr
      end
    end
  end
end
