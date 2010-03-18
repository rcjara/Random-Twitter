require 'kconv'

class HTMLDecoder  
  HTML_CODES_FILE = File.expand_path(File.dirname(__FILE__) + '/../config/HTMLCodes')
  HTML_NUM_CODES_FILE = File.expand_path(File.dirname(__FILE__) + '/../config/HTMLNumCodes')
  HTML_ENTITIES_FILE = File.expand_path(File.dirname(__FILE__) + '/../config/HTMLEntities')
  
  @@entities_hash = nil
  
  class << self
    def create_entities_hash
      codes_array = File.open(HTML_CODES_FILE, 'r') do |file|
        file.map { |line| line.chomp }
      end
      entities_array = File.open(HTML_ENTITIES_FILE, 'r') do |file|
        file.map { |line| line.chomp }
      end
      num_codes_array = File.open(HTML_NUM_CODES_FILE, 'r') do |file|
        file.map { |line| line.chomp }
      end
      @@entities_hash = {}
      codes_array.each_with_index { |code, i| @@entities_hash[code] = entities_array[i]; }
      num_codes_array.each_with_index { |code, i| @@entities_hash[code] = entities_array[i]; }
    end
    
    
    def decode(string)
      create_entities_hash if @@entities_hash.nil?
      
      string = string.toutf8
            
      begin
        entity_codes = string.scan(/&\S+?;/)
      rescue Exception => e
        raise "String Encoding: #{string.encoding}" + "\n" + e.to_s
      end
      
      return string if entity_codes.empty?
      
      entity_codes.uniq!
      entity_codes.each do |code| 
        begin
          string.gsub!(code, @@entities_hash[code]) 
        rescue
          raise "Unknown html code: #{code}"
        end
      end
      string
    end
    
  end
end