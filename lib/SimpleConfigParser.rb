module SimpleConfigParser
  
  def parse_config_file(config_path, *items)
    File.open(config_path, 'r') do |file|
      items.each do |item|  
        result = file.readline.scan(/(#{item.to_s}:)(\s*)(\S+)/)
        begin
          instance_variable_set("@#{item.to_s}".to_sym, result[0][2])
        rescue
          raise "Bad Config File"
        end
      end      
    end
  end
  
end
