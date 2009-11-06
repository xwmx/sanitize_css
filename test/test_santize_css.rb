require 'helper'

class TestSantizeCSS < Test::Unit::TestCase
  def setup
    SanitizeCSS.allowed_selectors = %W( #home )
    @css = %Q[#home { background-color: #000; } #post { color: #FFF }]
  end
  
  should "strip selector not whitelisted" do
    @sanitized = SanitizeCSS.sanitize(@css)
    assert_equal "#home { background-color: #000; }", @sanitized 
  end
end
