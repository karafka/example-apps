# frozen_string_literal: true

# Xml parser class
class XmlParser
  # @param [String] message to parse
  # @return [Hash] parsed xml
  # @example:
  #   XmlParser.parse('<node>n</node>')
  def self.parse(message)
    Hash.from_xml(message)
  end
end
