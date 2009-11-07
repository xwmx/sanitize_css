require 'helper'

class TestSanitizeCSS < Test::Unit::TestCase
  
  def setup
    SanitizeCSS.allowed_selectors = %W[
      .post
      .comment
      h1
      h2
      h3
      #title
      .good-selector
    ]
  end
  
  should "only return rule with whitelisted selector" do
    assert_sanitized ".post{color:#FFF;}", "#home { background-color: #000; } .post { color: #FFF }"
  end
  
  should "clean up bad css" do
    assert_sanitized ".post{color:#FFF;}", ".post { color: #FFF; behavior: url(http://foo.com); }"
  end
  
  # From Rails
  should "sanitize div style expression" do
    assert_sanitized '', "width: expression(alert('XSS'));"
    assert_sanitized '', ".bad-selector { width: expression(alert('XSS')); }"
    assert_sanitized '.good-selector {}', ".good-selector { width: expression(alert('XSS')); }"
    
  end
  
  should "sanitize div background image unicode encoded" do
    assert_sanitized '', "background-image:\0075\0072\006C\0028'\006a\0061\0076\0061\0073\0063\0072\0069\0070\0074\003a\0061\006c\0065\0072\0074\0028.1027\0058.1053\0053\0027\0029'\0029"
    assert_sanitized '', ".bad-selector { background-image:\0075\0072\006C\0028'\006a\0061\0076\0061\0073\0063\0072\0069\0070\0074\003a\0061\006c\0065\0072\0074\0028.1027\0058.1053\0053\0027\0029'\0029 }"
    assert_sanitized '.good-selector {}', ".good-selector { background-image:\0075\0072\006C\0028'\006a\0061\0076\0061\0073\0063\0072\0069\0070\0074\003a\0061\006c\0065\0072\0074\0028.1027\0058.1053\0053\0027\0029'\0029 }"
  end
  
  should "sanitize xul style attributes" do
    assert_sanitized '', "-moz-binding:url('http://ha.ckers.org/xssmoz.xml#xss')"
    assert_sanitized '', ".bad-selector { -moz-binding:url('http://ha.ckers.org/xssmoz.xml#xss') }"
    assert_sanitized '.good-selector {}', ".good-selector { -moz-binding:url('http://ha.ckers.org/xssmoz.xml#xss') }"
  end
  
  should "sanitize illegal style properties" do
    full_list = [ 
      "display:block",
      "position:absolute",
      "left:0",
      "top:0",
      "width:100%",
      "height:100%",
      "z-index:1",
      "background-color:black",
      "background-image:url(http://www.ragingplatypus.com/i/cam-full.jpg)",
      "background-x:center",
      "background-y:center",
      "background-repeat:repeat"
    ].join(";")
    sanitized_list = [
      "background-color: black",
      "display: block",
      "background-image: ",
      "height: 100%",
      "background-x: center",
      "background-y: center",
      "width: 100%",
    ].join(";")
    raw      = ".good-selector { #{full_list}; }"
    expected = ".good-selector { #{sanitized_list}; }"
    assert_sanitized expected, raw
  end
  
protected
  
  def assert_sanitized(expected, input)
    assert_equal expected.gsub(/\s/, ''), SanitizeCSS.sanitize(input).gsub(/\s/, '')
  end
  
end
