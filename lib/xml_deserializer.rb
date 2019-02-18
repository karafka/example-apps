# frozen_string_literal: true

# Xml deserializer class
class XmlDeserializer
  # @param [String] message to deserialize
  # @return [Hash] deserialized xml
  # @example:
  #   XmlDeserializer.new.call('<node>n</node>')
  def call(message)
    Hash.from_xml(message)
  end
end
