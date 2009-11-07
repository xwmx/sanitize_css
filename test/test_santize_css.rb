require 'helper'

class TestSantizeCSS < Test::Unit::TestCase
  
  def setup
    SanitizeCSS.allowed_selectors = %W( .post )
    @css = File.read(File.join(File.dirname(__FILE__), 'test.css'))
  end
  
  should "only return rule with whitelisted selector" do
    sanitized = SanitizeCSS.sanitize(@css)
    assert_equal ".post {\ncolor: #FFF;\n}\n", sanitized
  end
  
  should "clean up bad css" do
    sanitized = SanitizeCSS.sanitize(".post { color: #FFF; behavior: url(http://foo.com); }")
    assert_equal ".post {\ncolor: #FFF;\n}\n", sanitized
  end
  
end
