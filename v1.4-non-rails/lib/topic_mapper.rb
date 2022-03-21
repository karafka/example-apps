# frozen_string_literal: true

class TopicMapper

  def initialize(prefix)
    @prefix = prefix
  end

  def incoming(topic)
    return topic unless prefix

    result = topic.to_s.gsub("#{prefix}.", '')

    Karafka.logger.info("Incoming: #{result}")

    result
  end

  def outgoing(topic)
    return topic unless prefix

    result = "#{prefix}.#{topic}"

    Karafka.logger.info("Outgoing: #{result}")

    result
  end

  private

  attr_reader :prefix

end
