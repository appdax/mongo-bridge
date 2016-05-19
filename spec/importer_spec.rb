RSpec.describe Importer do
  it { is_expected.to be_a(Client) }

  context 'initialization' do
    describe 'batch_size:' do
      subject { client.batch_size }

      context 'when initialized without batch_size' do
        let(:client) { described_class.new }
        describe('#batch_size') { it { is_expected.to_not be_nil } }
      end

      context 'when initialized with batch_size of 10' do
        let(:client) { described_class.new batch_size: 10 }
        describe('#batch_size') { it { is_expected.to eq(10) } }
      end
    end

    describe 'path:' do
      subject { client.path }

      context 'when initialized without path' do
        let(:client) { described_class.new }
        describe('#path') { it { is_expected.to_not be_nil } }
      end

      context 'when initialized with path "tmp"' do
        let(:client) { described_class.new path: 'tmp' }
        describe('#path') { it { is_expected.to eq('tmp') } }
      end
    end
  end

  describe '#files_to_import' do
    context 'when assigning an non existing folder' do
      let(:importer) { Importer.new path: 'abd/dfbfg' }
      subject { importer.files_to_import }
      it { is_expected.to be_empty }
    end

    context 'when assigning an file instead of an folder' do
      let(:importer) { Importer.new path: 'abc.txt' }
      subject { importer.files_to_import }
      it { is_expected.to be_empty }
    end

    context 'when assigning an file instead of an folder' do
      let(:importer) { Importer.new path: 'abc.txt' }
      subject { importer.files_to_import }
      it { is_expected.to be_empty }
    end

    context 'when assigning an folder with 2 files' do
      let(:importer) { Importer.new path: 'tmp/data' }
      subject { importer.files_to_import.count }

      before do
        FileUtils.mkdir_p importer.path
        IO.write File.join(importer.path, 'f1.json'), ''
        IO.write File.join(importer.path, 'f2.json'), ''
        IO.write File.join(importer.path, 'f3.txt'), ''
      end

      after { FileUtils.rm_rf importer.path }

      it { is_expected.to eq(2) }
    end
  end
end
