require 'css_parser'
module CssParserSanitizer
private
  def parse_and_sanitize(raw, sanitizer, allowed_selectors)
    source_parser = CssParser::Parser.new
    dest_parser   = CssParser::Parser.new
    
    source_parser.add_block!(raw)
    
    source_parser.each_rule_set do |rs|
      if rs.selectors.all? { |s| allowed_selectors.include?(s.strip) }
        sanitized = sanitizer.sanitize_css(rs.declarations_to_s)
        new_rule_set = CssParser::RuleSet.new(rs.selectors.join(','), sanitized)
        dest_parser.add_rule_set!(new_rule_set)
      end
    end
    dest_parser.to_s
  end
end