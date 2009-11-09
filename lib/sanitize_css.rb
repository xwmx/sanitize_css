require 'action_controller'

class SanitizeCSS
  
  @@parser = defined?(PARSER) ? PARSER : 'CSSPool'
  @@allowed_selectors = defined?(SELECTORS) ? SELECTORS : []
  @@white_list_sanitizer = HTML::WhiteListSanitizer.new
  
  def self.allowed_selectors=(selectors = [])
    @@allowed_selectors += selectors
  end
  
  def self.parser=(parser)
    @@parser = parser
  end
  
  def self.sanitize(raw)
    new(raw).sanitize
  end
  
  def initialize(raw)
    @raw = raw
    
    case @@parser
    when 'CSSPool'
      require 'sanitizers/csspool.rb'
      class_eval { include CSSPoolSanitizer }
    when 'CssParser'
      require 'sanitizers/css_parser.rb'
      class_eval { include CssParserSanitizer }
    end
  end
  
  def sanitize
    parse_and_sanitize(@raw, @@white_list_sanitizer, @@allowed_selectors)
  end
  
end