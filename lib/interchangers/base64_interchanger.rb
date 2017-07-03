# frozen_string_literal: true

# Sample interchahnger class which decode/encode with Base64
# It resolve problem for issue
# https://github.com/karafka/karafka/issues/30
class Base64Interchanger
  class << self
    # Load params with encoding to base64
    # @param [Karafka::Params::Params] params
    # @return [String] Base64 encoded string
    def load(params)
      Base64.encode64(Marshal.dump(params))
    end

    # Load params with encoding to base64
    # @param [String] params
    # @return [Karafka::Params::Params] decoded params
    def parse(params)
      Marshal.load(Base64.decode64(params))
    end
  end
end
