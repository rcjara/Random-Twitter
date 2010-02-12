class TwitterConnector
  def initialize(config_file)
    load_config_file(config_file)
  end
  
  def load_config_file(config_file)
    File.open(config_file, 'r') do |file|
      first_regex_result = file.read_line.scan(/(username:)(\s*)(\S+)/)
      second_regex_result = file.read_line.scan(/(password:)(\s*)(\S+)/)
      begin
        @username = first_regex_result[0][2]
        @password = second_regex_result[0][2]
      rescue
        throw "Bad Config File"
      end
    end
  end
  
  
end