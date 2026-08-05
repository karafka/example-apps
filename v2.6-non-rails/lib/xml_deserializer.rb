# frozen_string_literal: true

require 'active_support/isolated_execution_state'
require 'active_support/core_ext/hash'
require 'active_support/xml_mini'
require 'rexml/document'

# Xml deserializer class
class XmlDeserializer
  # @param params [Karafka::Params::Params] params to de-serialize
  # @return [Hash] deserialized xml
  # @example:
  #   XmlDeserializer.new.call('<node>n</node>')
  def call(params)
    ::Hash.from_xml(params.raw_payload)
  end
end
