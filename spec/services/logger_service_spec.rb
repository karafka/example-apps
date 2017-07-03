# frozen_string_literal: true

RSpec.describe LoggerService do
  subject(:logger_service) { described_class.new }

  let(:controller) { double }
  let(:path) { '/test/path_to_file.log' }
  let(:file) { double }

  before do
    allow(controller)
      .to receive(:to_h)
      .and_return(message: 'message')
  end

  describe '#write_to_file' do
    before do
      allow(File)
        .to receive(:open)
        .with(path, 'a+')
        .and_return(file)

      allow(file).to receive_messages(write: true, close: true)
    end

    it 'writes to file' do
      logger_service.write_to_file(controller, path)
    end
  end

  describe '#clear_file' do
    it 'clears file' do
      allow(File).to receive(:open).with(path, 'w').and_yield
      logger_service.clear_file(path)
    end
  end
end
