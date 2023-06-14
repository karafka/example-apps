# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
class ApplicationConsumer < Karafka::BaseConsumer
    def consume
        @messages = messages
        messages.each do |message|
            Rails.logger.tagged(SecureRandom.uuid) do
                check_visit
                consume_one
                mark_as_consumed(message)
            end
        end
    end

    private 

    attr_reader :messages

    # Dummy method to run some SQL queries
    def check_visit
        Rails.logger.info "Test print log with UUID tagged"
        Visit.first
    end
end
