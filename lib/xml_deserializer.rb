# frozen_string_literal: true

require 'active_support/core_ext/hash'
require 'rexml/document'

# Xml deserializer class
class XmlDeserializer
  # @param params [Karafka::Params::Params] params to de-serialize
  # @return [Hash] deserialized xml
  # @example:
  #   XmlDeserializer.new.call('<node>n</node>')
  def call(params)
    ::Hash.from_xml(params.payload)
  end
end
