require 'helper'

class TestSantizeCSS < Test::Unit::TestCase
  
  def setup
    SanitizeCSS.allowed_selectors = %W( .post .comment h1 h2 h3 #title )
  end
  
  should "only return rule with whitelisted selector" do
    assert_sanitized ".post{color:#FFF;}", "#home { background-color: #000; } .post { color: #FFF }"
  end
  
  should "clean up bad css" do
    assert_sanitized ".post{color:#FFF;}", ".post { color: #FFF; behavior: url(http://foo.com); }"
  end
  
protected
  
  def assert_sanitized(expected, input)
    assert_equal expected.gsub(/\s/, ''), SanitizeCSS.sanitize(input).gsub(/\s/, '')
  end
  
end
