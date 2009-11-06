require 'css_parser'

class SanitizeCSS
  @@allowed_selectors = []
  
  def self.allowed_selectors=(selectors = [])
    @@allowed_selectors += selectors
  end
  
  def self.sanitize(raw)
    new(raw).sanitize
  end
  
  def initialize(raw)
    @raw = raw
  end
  
  def sanitize
    source_parser = CssParser::Parser.new
    dest_parser = CssParser::Parser.new
    source_parser.add_block!(@raw)
    source_parser.each_rule_set do |rs|
      if rs.selectors.all? { |s| @@allowed_selectors.include?(s) }
        dest_parser.add_rule_set!(rs)
      end
    end
    dest_parser.to_s
  end
  
end