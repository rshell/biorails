require "tempfile"
require "open3"

module Alces
  module OpenOffice

    HTML = "html"
    PDF = "pdf"

    class MarcoRunner

       # The path to Executable

      @@program_path = "soffice"
      #
      # Results of running the command
      attr_reader :results

      # The last error messages generate by the command.
      attr_reader :errors

      # Format to output
      attr_reader :template

      attr_reader :macro

      # Creates a blank  wrapper, using <tt>format</tt> to
      # indicate whether the output will be HTML, PDF or PS. The format
      # defaults to PDF, and can change using one of the module
      # contants.
      def initialize(template= "alces.odt",macro="macro:///Alces.format(%1)")
        @macro = macro
        @template = template
        reset
      end

      # Gets the current path for the unoconv executable.
      def self.program_path
        @@program_path
      end

      # Sets the current path for the unoconv executable.
      def self.program_path=(value)
        @@program_path = value
      end

      def format(filename)
        status = run("#{@@program_path} -headless #{@template} #{@macro} #{filename}" )
      end

        protected

        def run(command,input='')
          reset
          Open3.popen3(command) do |stdin,stdout,stderr|
            stdin.puts input
            stdin.close_write
            @results = stdout.read
            @errors << stderr.readlines
          end
          $?
        end

        def reset
          @output = nil
          @results = nil
          @errors = []
        end
    end

    class FormatConverterException < StandardError; end

    # The wrapper class around HTMLDOC, providing methods for setting
    # the options for the application and retriving the generate output
    # either as a file, diretory or string.
    class FormatConverter

      # The path to Executable

      @@program_path = "unoconv"
      #
      # List of allowed formats
      #
      @@formats = nil
      #
      # Results of running the command
      attr_reader :results

      # The last error messages generate by the command.
      attr_reader :errors

      # Format to output
      attr_reader :format

      attr_reader :output

      # Creates a blank  wrapper, using <tt>format</tt> to
      # indicate whether the output will be HTML, PDF or PS. The format
      # defaults to PDF, and can change using one of the module
      # contants.
      def initialize(format = PDF)
        @format = format
        reset
      end

      # Gets the current path for the unoconv executable.
      def self.program_path
        @@program_path
      end

      # Sets the current path for the unoconv executable.
      def self.program_path=(value)
        @@program_path = value
      end

      def convert(filename)
        status = run("#{@@program_path} -v --format=#{@format} #{filename}")
        case @results
        when /^Output file: (.*)$/
          @output = $1
        when /^unoconv: (.*)$/
          @errors << $1
        when /^Please start an (.*)$/
          @errors << line
        when /^Warning:(.*)$/
          @errors << line
        when /^Error:(.*)$/
          @errors << line
        else
          puts "no match [#{line}]"
        end

      ensure
          if @errors.size>0
            return nil
          elsif status!=0
            @errors << "Invalid exit status of #{status}"
            return nil
          else
            return @output
          end
        end

        def self.formats
          initialize_formats
          @@formats.keys
        end
      
        def self.format(name)
          initialize_formats
          @@formats[name]
        end
      
        def self.format?(name)
          initialize_formats
          !@@formats[name].nil?
        end
      
        protected

        def run(command,input='')
          reset
          Open3.popen3(command) do |stdin,stdout,stderr|
            stdin.puts input
            stdin.close_write
            @results = stdout.read || ""
            @results << stderr.read
          end
          $?
        end

        def reset
          @output = nil
          @results = nil
          @errors = []
        end

        def self.add_format(type,key,extension,mime,name,description=nil)
          @@formats ||={}
          mime ||= "application/#{name}"
          @@formats[key] = {:key=>key,:type=>type,:mime=>mime,:name=>name,:ext=>extension,:description=>description}
        end

        def self.initialize_formats
          return  @@formats if @@formats
          @@formats = {}
          ### Document / Writer
          add_format('document', 'bib',   'bib',nil, 'BibTeX', 'BibTeX_Writer')
          add_format('document', 'doc',   'doc', 'application/msword', 'Microsoft Word 97/2000/XP', 'MS Word 97')
          add_format('document', 'doc6',  'doc', 'application/msword', 'Microsoft Word 6.0', 'MS WinWord 6.0')
          add_format('document', 'doc95', 'doc', 'application/msword', 'Microsoft Word 95', 'MS Word 95')
          add_format('document', 'docbook', 'xml',nil, 'DocBook', 'DocBook File')
          add_format('document', 'html',  'html', nil, 'HTML Document (OpenOffice.org Writer)', 'HTML (StarWriter)')
          add_format('document', 'odt',   'odt',  nil, 'Open Document Text', 'writer8')
          add_format('document', 'ott',   'ott',  nil, 'Open Document Text', 'writer8_template')
          add_format('document', 'ooxml', 'xml',  nil,'Microsoft Office Open XML', 'MS Word 2003 XML')
          add_format('document', 'pdf',   'pdf',  'application/pdf' 'Portable Document Format', 'writer_pdf_Export')
          add_format('document', 'rtf',   'rtf',  'application/rtf', 'Rich Text Format', 'Rich Text Format')
          add_format('document', 'latex', 'ltx',  nil, 'LaTeX 2e', 'LaTeX_Writer')
          add_format('document', 'text',   'txt',  nil, 'Text Encoded', 'Text (encoded)')
          add_format('document', 'mediawiki','txt',nil, 'Mediawiki', 'Mediawiki')
          add_format('document', 'txt',   'txt',  nil, 'Plain Text', 'Text')
          add_format('document', 'xhtml', 'html', nil, 'XHTML Document', 'XHTML Writer File')

          ### Spreadsheet
          add_format('spreadsheet', 'csv', 'csv',nil, 'Text CSV', 'Text - txt - csv (StarCalc)')
          add_format('spreadsheet', 'dif', 'dif',nil, 'Data Interchange Format', 'DIF')
          add_format('spreadsheet', 'ods', 'ods',nil, 'Open Document Spreadsheet', 'calc8')
          add_format('spreadsheet', 'xls', 'xls',nil, 'Microsoft Excel 97/2000/XP', 'MS Excel 97')
          add_format('spreadsheet', 'xls5', 'xls',nil, 'Microsoft Excel 5.0', 'MS Excel 5.0/95')
          add_format('spreadsheet', 'xls95', 'xls',nil, 'Microsoft Excel 95', 'MS Excel 95')
          add_format('spreadsheet', 'xlt', 'xlt',nil, 'Microsoft Excel 97/2000/XP Template', 'MS Excel 97 Vorlage/Template')
          add_format('spreadsheet', 'xlt5', 'xlt',nil, 'Microsoft Excel 5.0 Template', 'MS Excel 5.0/95 Vorlage/Template')
          add_format('spreadsheet', 'xlt95', 'xlt',nil, 'Microsoft Excel 95 Template', 'MS Excel 95 Vorlage/Template')

          ### Graphics
          add_format('graphics', 'bmp', 'bmp',nil, 'Windows Bitmap', 'draw_bmp_Export')
          add_format('graphics', 'emf', 'emf',nil, 'Enhanced Metafile', 'draw_emf_Export')
          add_format('graphics', 'eps', 'eps',nil, 'Encapsulated PostScript', 'draw_eps_Export')
          add_format('graphics', 'gif', 'gif',nil, 'Graphics Interchange Format', 'draw_gif_Export')
          add_format('graphics', 'jpg', 'jpg',nil, 'Joint Photographic Experts Group', 'draw_jpg_Export')
          add_format('graphics', 'odd', 'odd',nil, 'OpenDocument Drawing', 'draw8')
          add_format('graphics', 'pbm', 'pbm',nil, 'Portable Bitmap', 'draw_pbm_Export')
          add_format('graphics', 'pct', 'pct',nil, 'Mac Pict', 'draw_pct_Export')
          add_format('graphics', 'pgm', 'pgm',nil, 'Portable Graymap', 'draw_pgm_Export')
          add_format('graphics', 'png', 'png',nil, 'Portable Network Graphic', 'draw_png_Export')
          add_format('graphics', 'ppm', 'ppm',nil, 'Portable Pixelmap', 'draw_ppm_Export')
          add_format('graphics', 'svg', 'svg','image/svg+xml', 'Scalable Vector Graphics', 'draw_svg_Export')
          add_format('graphics', 'swf', 'swf','application/x-shockwave-flash', 'Macromedia Flash (SWF)', 'draw_flash_Export')
          add_format('graphics', 'tiff', 'tiff','image/tiff', 'Tagged Image File Format', 'draw_tif_Export')
          add_format('graphics', 'wmf', 'wmf',nil, 'Windows Metafile', 'draw_wmf_Export')
          add_format('graphics', 'xpm', 'xpm',nil, 'X PixMap', 'draw_xpm_Export')

          ### Presentation
          add_format('presentation', 'ppt', 'ppt',nil, 'Microsoft PowerPoint 97/2000/XP', 'MS PowerPoint 97')
          add_format('presentation', 'stp', 'stp',nil, 'OpenDocument Presentation Template', 'impress8_template')
        end

      end
    end
  end
