# frozen_string_literal: true

require 'active_support/core_ext/hash'
require 'rexml/document'

# Xml deserializer class
class XmlDeserializer
  # @param [String] message to deserialize
  # @return [Hash] deserialized xml
  # @example:
  #   XmlDeserializer.new.call('<node>n</node>')
  def call(message)
    ::Hash.from_xml(message)
  end
end
