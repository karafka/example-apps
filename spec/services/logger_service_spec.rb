require 'spec_helper'

RSpec.describe LoggerService do
  let(:controller) { double }
  let(:path) { '/test/path_to_file.log' }
  let(:file) { double }
  subject(:logger_service) { described_class.new }

  before do
    allow(controller)
      .to receive(:to_h)
      .and_return(message: 'message')
  end

  describe '#write_to_file' do
    it 'writes to file' do
      expect(File)
        .to receive(:open)
        .with(path, 'a+')
        .and_return(file)

      expect(file).to receive_messages(write: true, close: true)

      logger_service.write_to_file(controller, path)
    end
  end

  describe '#clear_file' do
    it 'clears file' do
      expect(File).to receive(:open).with(path, 'w').and_yield
      logger_service.clear_file(path)
    end
  end
end
