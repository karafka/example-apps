# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
class ApplicationConsumer < ::DummyKafka::BaseConsumer
  # Lets assume that there are many services and each consumes some messages.
  # There is a need for the same additional logic in each consumers
  # To avoid duplication everything is inside new base class for consumers (DummyKafka::BaseConsumer)
end
