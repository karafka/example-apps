# frozen_string_literal: true

RSpec.describe TransactionalProducer do
  after { described_class.close }

  it 'builds one transactional producer per process' do
    producer = described_class.instance

    expect(producer.transactional?).to be(true)
    expect(described_class.instance).to be(producer)
  end

  describe '.close' do
    it 'closes the producer and builds a new one on the next use' do
      producer = described_class.instance

      described_class.close

      expect(producer.status.closed?).to be(true)
      expect(described_class.instance).not_to be(producer)
    end

    it 'does nothing when no producer was built' do
      described_class.close

      expect { described_class.close }.not_to raise_error
    end

    it 'runs when the Karafka app stops' do
      producer = described_class.instance

      Karafka.monitor.instrument('app.stopped', server_id: Karafka::Server.id)

      expect(producer.status.closed?).to be(true)
    end
  end
end
