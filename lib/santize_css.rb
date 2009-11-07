require 'css_parser'
require 'action_controller'

class SanitizeCSS
  @@allowed_selectors = []
  @@white_list_sanitizer = HTML::WhiteListSanitizer.new
  
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
        sanitized = @@white_list_sanitizer.sanitize_css(rs.declarations_to_s)
        dest_parser.add_rule_set!(CssParser::RuleSet.new(rs.selectors.join(" "), sanitized))
      end
    end
    dest_parser.to_s
  end
  
end