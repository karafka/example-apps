# frozen_string_literal: true

# Service gor logging params to file
class LoggerService
  # @param controller [Karafka::BaseController instance]
  # @param path [String] path to file
  def write_to_file(controller, path)
    file = File.open(path, 'a+')
    file.write "Controller topic details: #{controller.topic.to_h}\n"
    file.close
  end

  # Clears all data from log file
  # @param path [String] path to file
  def clear_file(path)
    File.open(path, 'w') {}
  end
end
