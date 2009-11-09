require 'csspool'
module CSSPoolSanitizer
private
  def parse_and_sanitize(raw, sanitizer, allowed_selectors)
    source_doc = CSSPool.CSS raw
    dest_doc = ""
    
    source_doc.rule_sets.each do |rs|
      if rs.selectors.all? { |s| allowed_selectors.include?(s.to_s) }
        sanitized = sanitizer.sanitize_css(rs.declarations.to_s)
        dest_doc << "#{rs.selectors.join(", ").to_s}\n  {\n    #{sanitized}\n}\n"
      end
    end
    dest_doc.to_s
  end
end