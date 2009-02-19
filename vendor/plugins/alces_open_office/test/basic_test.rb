require File.dirname(__FILE__) + '/test_helper.rb'

class BasicTest <Test::Unit::TestCase

  INVALID_FILE ='xxxx.html'
  CSV_FILE = File.dirname(__FILE__) + '/fixtures/test1.csv'
  GIF_FILE = File.dirname(__FILE__) + '/fixtures/test2.gif'
  ODS_FILE = File.dirname(__FILE__) + '/fixtures/test3.ods'
  ODT_FILE = File.dirname(__FILE__) + '/fixtures/test4.odt'
  XLS_FILE = File.dirname(__FILE__) + '/fixtures/test5.xls'
  PNG_FILE = File.dirname(__FILE__) + '/fixtures/test6.png'
  JPG_FILE = File.dirname(__FILE__) + '/fixtures/test7.jpg'
  DOC_FILE = File.dirname(__FILE__) + '/fixtures/test8.doc'
  HTML_FILE = File.dirname(__FILE__) + '/fixtures/test9.html'



 def test_new
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   assert "pdf",converter.format
 end

 def test_formats
   keys = Alces::OpenOffice::FormatConverter.formats
   assert keys.is_a?(Array)
   assert keys.size>10
 end

 def test_format?
   assert Alces::OpenOffice::FormatConverter.format?('pdf')
 end

 def test_format
   entry = Alces::OpenOffice::FormatConverter.format('pdf')
   assert entry
   assert entry[:name]
   assert entry[:description]
   assert entry[:extension]
   assert entry[:type]
 end

 def test_path
   file = Alces::OpenOffice::FormatConverter.program_path
   assert file   
 end

 def test_convert_invalid_file
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   ret = converter.convert(INVALID_FILE)
   assert_nil ret
   assert converter.errors
   assert converter.errors.is_a?(Array)
   assert_equal 1,converter.errors.size, "[ #{converter.errors.join(' , ')}]"
   assert_equal "file `xxxx.html' does not exist.",converter.errors.first
   assert converter.results
 end


  def test_convert_odt_to_pdf
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   ret = converter.convert(ODT_FILE)
   assert_equal 0,converter.errors.size, converter.errors.join("\n")
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

  def test_convert_hmtl_to_pdf
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   ret = converter.convert(HTML_FILE)
   assert_equal 0,converter.errors.size, converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

  def test_convert_doc_to_html
   converter = Alces::OpenOffice::FormatConverter.new("html")
   assert converter
   ret = converter.convert(DOC_FILE)
   assert_equal 0,converter.errors.size,converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

  def test_convert_doc_to_pdf
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   ret = converter.convert(DOC_FILE)
   assert_equal 0,converter.errors.size, converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

  def test_convert_doc_to_png_fails
   converter = Alces::OpenOffice::FormatConverter.new("png")
   assert converter
   ret = converter.convert(DOC_FILE)
   assert_equal 1,converter.errors.size, converter.results
   assert_nil ret
 end

  def test_convert_png_to_jpg
   converter = Alces::OpenOffice::FormatConverter.new("jpg")
   assert converter
   ret = converter.convert(PNG_FILE)
   assert_equal 0,converter.errors.size, converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

  def test_convert_odt_to_doc
   converter = Alces::OpenOffice::FormatConverter.new("doc")
   assert converter
   ret = converter.convert(ODT_FILE)
   assert_equal 0,converter.errors.size, converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

  def test_convert_ods_to_pdf
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   ret = converter.convert(ODT_FILE)
   assert_equal 0,converter.errors.size, converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

 def test_convert_xls_to_pdf
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   ret = converter.convert(XLS_FILE)
   assert_equal 0,converter.errors.size, converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

 def test_convert_png_to_pdf
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   ret = converter.convert(PNG_FILE)
   assert_equal 0,converter.errors.size,converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

 def test_convert_jpg_to_pdf
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   ret = converter.convert(JPG_FILE)
   assert_equal 0,converter.errors.size, converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end

 def test_convert_gif_to_pdf
   converter = Alces::OpenOffice::FormatConverter.new
   assert converter
   ret = converter.convert(GIF_FILE)
   assert_equal 0,converter.errors.size, converter.results
   assert ret
   assert File.exists?(ret)
   File.delete(ret)
 end


end
