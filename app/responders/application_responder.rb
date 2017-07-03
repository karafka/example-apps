# frozen_string_literal: true

# Application responder from which all Karafka responders should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
class ApplicationResponder < Karafka::BaseResponder
end
