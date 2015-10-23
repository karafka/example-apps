require 'active_support/core_ext/hash'

# Xml parser class
class XmlParser
  # Error raised when message is not valid xml
  class ParserError < StandardError; end

  # @param [String] message to parse
  # @return [Hash] parsed xml
  # @example:
  #   XmlParser.parse('<node>n</node>')
  def self.parse(message)
    Hash.from_xml(message)
  rescue REXML::ParseException
    raise ParserError
  end
end
