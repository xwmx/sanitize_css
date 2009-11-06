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
    @raw
  end
  
end