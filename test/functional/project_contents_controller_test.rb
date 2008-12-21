require File.dirname(__FILE__) + '/../test_helper'
require "project_contents_controller"

# Re-raise errors caught by the controller.
class ProjectContentsController; def rescue_action(e) raise e end; end

class ProjectContentsControllerTest < Test::Unit::TestCase

  CHARSET_TEXT = <<TEXT
  <table class=\"widthFull\" style=\"border-bottom: 1px solid rgb(102,
 153,
 204);\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td><h3><a name=\"ax\">Appendix</a>
A B Latin alphabet no. 1 B ISO 8859-1:1987</h3></td>\r\n<td class=\"alignBottom\">
<a href=\"http://www.tbs-sct.gc.ca/its-nit/standards/tbits03/crit03-eng.asp#tphp\">
<img src=\"http://www.tbs-sct.gc.ca/cioscripts/images/uparrow.gif\" alt=\"Top of Page\" class=\"image-right\"></a>
</td>\r\n</tr>\r\n</tbody></table>\r\n\r\n<table class=\"widthFull\" border=\"1\" cellspacing=\"0\">\r\n
<tbody><tr>\r\n    <td>&nbsp;</td>\r\n    <td><small>000</small></td>\r\n    <td><small>016</small></td>\r\n
<td><small>032</small></td>\r\n    <td><small>048</small></td>\r\n    <td><small>064</small></td>\r\n
<td><small>080</small></td>\r\n    <td><small>096</small></td>\r\n    <td><small>112</small></td>\r\n
<td><small>128</small></td>\r\n    <td><small>144</small></td>\r\n    <td><small>160</small></td>\r\n
<td><small>176</small></td>\r\n    <td><small>192</small></td>\r\n    <td><small>208</small></td>\r\n
<td><small>224</small></td>\r\n    <td><small>240</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>0</small></td>\r\n
<td><small>NUL</small></td>\r\n    <td><small>DLE</small></td>\r\n    <td><small>SP</small></td>\r\n
<td><small>0</small></td>\r\n    <td><small>@</small></td>\r\n    <td><small>P</small></td>\r\n
<td><small>?</small></td>\r\n    <td><small>p</small></td>\r\n    <td><small>O</small></td>\r\n
<td><small>DCS</small></td>\r\n    <td><small>NBSP</small></td>\r\n    <td><small>E</small></td>\r\n
<td><small>À</small></td>\r\n    <td><small>Ð</small></td>\r\n    <td><small>à</small></td>\r\n
<td><small>ð</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>1</small></td>\r\n
<td><small>SOH</small></td>\r\n    <td><small>DC1</small></td>\r\n    <td><small>!</small></td>\r\n
<td><small>1</small></td>\r\n    <td><small>A</small></td>\r\n    <td><small>Q</small></td>\r\n
<td><small>a</small></td>\r\n    <td><small>q</small></td>\r\n    <td><small>O</small></td>\r\n
<td><small>PU1</small></td>\r\n    <td><small>(</small></td>\r\n    <td><small>\"</small></td>\r\n
<td><small>Á</small></td>\r\n    <td><small>Ñ</small></td>\r\n    <td><small>á</small></td>\r\n
<td><small>ñ</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>2</small></td>\r\n
<td><small>STX</small></td>\r\n    <td><small>DC2</small></td>\r\n    <td><small>\"</small></td>\r\n
<td><small>2</small></td>\r\n    <td><small>B</small></td>\r\n    <td><small>R</small></td>\r\n
<td><small>b</small></td>\r\n    <td><small>r</small></td>\r\n    <td><small>O</small></td>\r\n
<td><small>PU2</small></td>\r\n    <td><small>4</small></td>\r\n    <td><small>5</small></td>\r\n
<td><small>Â</small></td>\r\n    <td><small>Ò</small></td>\r\n    <td><small>â</small></td>\r\n
<td><small>ò</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>3</small></td>\r\n
<td><small>ETX</small></td>\r\n    <td><small>DC3</small></td>\r\n    <td><small>#</small></td>\r\n
<td><small>3</small></td>\r\n    <td><small>C</small></td>\r\n    <td><small>S</small></td>\r\n
<td><small>c</small></td>\r\n    <td><small>s</small></td>\r\n    <td><small>O</small></td>\r\n
<td><small>STS</small></td>\r\n    <td><small>,</small></td>\r\n    <td><small>;</small></td>\r\n
<td><small>Ã</small></td>\r\n   <td><small>Ó</small></td>\r\n    <td><small>ã</small></td>\r\n
<td><small>ó</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>4</small></td>\r\n
<td><small>EOT</small></td>\r\n    <td><small>DC4</small></td>\r\n
<td><small>$</small></td>\r\n    <td><small>4</small></td>\r\n    <td><small>D</small></td>\r\n
<td><small>T</small></td>\r\n    <td><small>d</small></td>\r\n    <td><small>t</small></td>\r\n
<td><small>IND</small></td>\r\n    <td><small>CCH</small></td>\r\n    <td><small>9</small></td>\r\n
<td><small>?</small></td>\r\n    <td><small>Ä</small></td>\r\n    <td><small>Ô</small></td>\r\n
<td><small>ä</small></td>\r\n    <td><small>ô</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>5</small></td>\r\n
 <td><small>ENQ</small></td>\r\n    <td><small>NAK</small></td>\r\n    <td><small>%</small></td>\r\n
 <td><small>5</small></td>\r\n    <td><small>E</small></td>\r\n    <td><small>U</small></td>\r\n
<td><small>e</small></td>\r\n    <td><small>u</small></td>\r\n    <td><small>NEL</small></td>\r\n
<td><small>MW</small></td>\r\n    <td><small>-</small></td>\r\n    <td><small>F</small></td>\r\n
<td><small>Å</small></td>\r\n    <td><small>Õ</small></td>\r\n    <td><small>å</small></td>\r\n
 <td><small>õ</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>6</small></td>\r\n    <td><small>ACK</small></td>\r\n
  <td><small>SYN</small></td>\r\n    <td><small>&amp;</small></td>\r\n    <td><small>6</small></td>\r\n
  <td><small>F</small></td>\r\n    <td><small>V</small></td>\r\n    <td><small>f</small></td>\r\n
  <td><small>v</small></td>\r\n    <td><small>SSA</small></td>\r\n    <td><small>SPA</small></td>\r\n
  <td><small>|</small></td>\r\n    <td><small>&amp;</small></td>\r\n    <td><small>Æ</small></td>\r\n
  <td><small>Ö</small></td>\r\n    <td><small>æ</small></td>\r\n    <td><small>ö</small></td>\r\n  </tr>\r\n  <tr>\r\n
   <td><small>7</small></td>\r\n    <td><small>BEL</small></td>\r\n    <td><small>ETB</small></td>\r\n
    <td><small>'</small></td>\r\n    <td><small>7</small></td>\r\n    <td><small>G</small></td>\r\n
 <td><small>W</small></td>\r\n    <td><small>g</small></td>\r\n    <td><small>w</small></td>\r\n
   <td><small>ESA</small></td>\r\n    <td><small>EPA</small></td>\r\n    <td><small>'</small></td>\r\n
  <td><small>C</small></td>\r\n    <td><small>Ç</small></td>\r\n    <td><small>H</small></td>\r\n
   <td><small>ç</small></td>\r\n    <td><small>)</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>8</small></td>\r\n
    <td><small>BS</small></td>\r\n    <td><small>CAN</small></td>\r\n    <td><small>(</small></td>\r\n
  <td><small>8</small></td>\r\n    <td><small>H</small></td>\r\n    <td><small>X</small></td>\r\n
   <td><small>h</small></td>\r\n    <td><small>x</small></td>\r\n    <td><small>HTS</small></td>\r\n
  <td><small>O</small></td>\r\n    <td><small>?</small></td>\r\n    <td><small>?</small></td>\r\n
   <td><small>È</small></td>\r\n    <td><small>Ø</small></td>\r\n    <td><small>è</small></td>\r\n
   <td><small>ø</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>9</small></td>\r\n    <td><small>HT</small></td>\r\n
 <td><small>EM</small></td>\r\n    <td><small>)</small></td>\r\n    <td><small>9</small></td>\r\n
   <td><small>I</small></td>\r\n    <td><small>Y</small></td>\r\n    <td><small>i</small></td>\r\n
  <td><small>y</small></td>\r\n    <td><small>HTJ</small></td>\r\n    <td><small>O</small></td>\r\n
  <td><small>8</small></td>\r\n    <td><small>o</small></td>\r\n    <td><small>É</small></td>\r\n
  <td><small>Ù</small></td>\r\n    <td><small>é</small></td>\r\n    <td><small>ù</small></td>\r\n  </tr>\r\n
 <tr>\r\n    <td><small>10</small></td>\r\n    <td><small>LF</small></td>\r\n    <td><small>SUB</small></td>\r\n
 <td><small>*</small></td>\r\n    <td><small>:</small></td>\r\n    <td><small>J</small></td>\r\n
  <td><small>Z</small></td>\r\n    <td><small>j</small></td>\r\n    <td><small>z</small></td>\r\n
  <td><small>VTS</small></td>\r\n    <td><small>O</small></td>\r\n    <td><small>0</small></td>\r\n
    <td><small>1</small></td>\r\n    <td><small>Ê</small></td>\r\n    <td><small>Ú</small></td>\r\n
  <td><small>ê</small></td>\r\n    <td><small>ú</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>11</small></td>\r\n
    <td><small>VT</small></td>\r\n    <td><small>ESC</small></td>\r\n    <td><small>+</small></td>\r\n
    <td><small>;</small></td>\r\n    <td><small>K</small></td>\r\n    <td><small>[</small></td>\r\n
 <td><small>k</small></td>\r\n    <td><small>{</small></td>\r\n    <td><small>PLD</small></td>\r\n
  <td><small>CSI</small></td>\r\n    <td><small>*</small></td>\r\n    <td><small>+</small></td>\r\n
  <td><small>Ë</small></td>\r\n    <td><small>Û</small></td>\r\n    <td><small>ë</small></td>\r\n
 <td><small>û</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>12</small></td>\r\n    <td><small>FF</small></td>\r\n
  <td><small>FS</small></td>\r\n    <td><small>,
</small></td>\r\n    <td><small>&lt;</small></td>\r\n    <td><small>L</small></td>\r\n
<td><small>\\</small></td>\r\n    <td><small>l</small></td>\r\n    <td><small>|</small></td>\r\n
    <td><small>PLU</small></td>\r\n    <td><small>ST</small></td>\r\n    <td><small>5</small></td>\r\n
   <td><small>3</small></td>\r\n    <td><small>Ì</small></td>\r\n    <td><small>Ü</small></td>\r\n
 <td><small>ì</small></td>\r\n    <td><small>ü</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>13</small></td>\r\n
 <td><small>CR</small></td>\r\n    <td><small>GS</small></td>\r\n    <td><small>-</small></td>\r\n
  <td><small>=</small></td>\r\n    <td><small>M</small></td>\r\n    <td><small>]</small></td>\r\n
 <td><small>m</small></td>\r\n    <td><small>}</small></td>\r\n    <td><small>RI</small></td>\r\n
  <td><small>OSC</small></td>\r\n    <td><small>SHY</small></td>\r\n    <td><small>2</small></td>\r\n
  <td><small>Í</small></td>\r\n    <td><small>Ý</small></td>\r\n    <td><small>í</small></td>\r\n
 <td><small>ý</small></td>\r\n  </tr>\r\n  <tr>\r\n    <td><small>14</small></td>\r\n    <td><small>LS1</small></td>\r\n
  <td><small>RS</small></td>\r\n    <td><small>.</small></td>\r\n    <td><small>&gt;</small></td>\r\n
  <td><small>N</small></td>\r\n    <td><small>^</small></td>\r\n    <td><small>n</small></td>\r\n
 <td><small>~</small></td>\r\n    <td><small>SS2</small></td>\r\n    <td><small>PM</small></td>\r\n
 <td><small>7</small></td>\r\n    <td><small>:</small></td>\r\n    <td><small>Î</small></td>\r\n
<td><small>Þ</small></td>\r\n    <td><small>î</small></td>\r\n    <td><small>þ</small></td>\r\n  </tr>\r\n  <tr>\r\n
  <td><small>15</small></td>\r\n    <td><small>LS0</small></td>\r\n    <td><small>US</small></td>\r\n
 <td><small>/</small></td>\r\n    <td><small>?</small></td>\r\n    <td><small>O</small></td>\r\n
 <td><small>_</small></td>\r\n    <td><small>o</small></td>\r\n    <td><small>DEL</small></td>\r\n
  <td><small>SS3</small></td>\r\n    <td><small>APC</small></td>\r\n    <td><small>?</small></td>\r\n
  <td><small>)</small></td>\r\n    <td><small>Ï</small></td>\r\n    <td><small>ß</small></td>\r\n
 <td><small>ï</small></td>\r\n    <td><small>ÿ</small></td>\r\n  </tr>\r\n</tbody></table>\r\n\r\n<p>Notes:</p>"
TEXT
  def setup
    @controller = ProjectContentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    User.current = User.find(3)
    @item = ProjectContent.list(:first,:conditions=>"parent_id is not null")
    @folder = @item.parent    
  end  

  def test_show_article
    get :show, :style=>'html',  :id=>@item.id
    assert_response :success
  end
  
  def test_setup
    assert_not_nil @folder
    assert_not_nil @item
    assert_not_nil @item.element_type
    assert_not_nil @item.id
    assert_not_nil @item.parent
    assert_not_nil @item.name
  end

  def test_show
    get :show,:style=>'html', :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:project_element)
  end

  def test_show_invalid_id
    get :show,:style=>'html', :id => 32589568923895890
    assert_response :success
    assert_template 'access_denied'
  end

  def test_new
    get :new,:style=>'html', :id=> @folder.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:project_element)
  end

  def test_new_js
    get :new,:style=>'html', :id=> @folder.id,:format=>'js'
    assert_response :success
    assert_template '_messages'
    assert_not_nil assigns(:project_element)
  end

  def test_tree
    get :tree, :id=> @folder.id
    assert_response :success
  end

  def test_tree_invalid
    get :tree, :id=>777777
    assert_response :success
  end


  def test_state_bar
    get :state, :id=> @folder.id,:state_id=>3,:display=>'bar'
    assert_response :success
  end

 def test_state_combo
    get :state, :id=> @folder.id,:state_id=>3,:display=>'combo'
    assert_response :success
  end

  def test_state_text
    get :state, :id=> @folder.id,:state_id=>3
    assert_response :success
  end


  def test_create
    post :create,:style=>'html', :id=> @folder.id,
      :project_element => {:name=>'dfdsfd',:title=>'testing',:content_data=>'body'}
    assert_response  :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:project_element)
    assert assigns(:project_element).valid?
    assert !assigns(:project_element).new_record?
  end

  def test_create_charset
    post :create,:style=>'html', :id=> @folder.id,
      :project_element => {:name=>'charset',:title=>'testing',:content_data=>CHARSET_TEXT}
    assert_response  :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:project_element)
    assert assigns(:project_element).valid?
    assert !assigns(:project_element).new_record?
    assert_equal CHARSET_TEXT,assigns(:project_element).html
  end

  def test_create_js
    post :create,:style=>'html', :id=> @folder.id,:format=>'js', 
       :project_element => {:name=>'dfds2',:title=>'testing',:content_data=>'body'}
    assert_response :success
    assert_not_nil assigns(:project_element)
    assert assigns(:project_element).valid?
    assert !assigns(:project_element).new_record?
  end

  def test_create_failed_js
    post :create,:style=>'html', :id=>@folder.id,:format=>'js', 
       :project_element => {:name=>nil}
    assert_response :success
    assert_not_nil assigns(:project_element)
    assert !assigns(:project_element).valid?
  end

  def test_edit
    get :edit, :style=>'html', :id =>  @item.id
    assert_response :success
    assert_template 'edit'
  end
  
  def test_edit_js
    get :edit,:style=>'html', :id =>  @item.id, :format=>'js'
    assert_response :success
  end
  
  def test_create_invalid
    post :create,:style=>'html', :id=>@folder.id, 
       :project_element => {:id=>@item.id,:name=>'',:title=>'testing',:data=>'body'}
    assert :success #reloads the existing page
    assert_not_nil assigns(:project_element)
    assert !assigns(:project_element).valid? 
    assert assigns(:project_element).errors
    assert assigns(:project_element).errors[:name]
    assert_empty_error_field('project_element[name]')
    assert_tag :tag=>'li', :content=>"Name can't be blank"
  end 
    
  def test_update_without_name_should_not_be_valid
    post :update,:style=>'html', :id=>@item.id, 
    :project_element => {:id=>@item.id,:name=>nil,:title=>'testing',:data=>'body'}
    assert_redirected_to :action=>:show
    assert !assigns(:project_element).valid? 
    assert flash[:error]
  end

  def test_update_with_new_name
    post :update,:style=>'html', :id=>@item.id, 
    :project_element => {:id=>@item.id,:name=>'new_name',:title=>'testing',:data=>'body'}
    assert :redirected
    assert_nil flash[:error]
  end

  def test_update_with_new_name_js
    post :update,:style=>'html', :id=>@item.id, :format=>'js', 
    :project_element => {:id=>@item.id,:name=>'new_name',:title=>'testing',:data=>'body'}
    assert :redirected
    assert_nil flash[:error]
  end

end
