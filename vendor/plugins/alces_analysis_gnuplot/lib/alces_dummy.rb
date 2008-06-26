require "faster_csv"
require 'matrix'

module Alces
  module Processor
    #
    # Example Dummy Template for Analysis plugin
    #
    class Dummy     
       attr_accessor :task
       attr_accessor :dirname
       attr_accessor :config
       attr_accessor :matrix
       
    
       #
       # Setup should return a default close to working configuration for the plugin this is build of a AnalysisMethod definition with a collection
       # of associated AnalysisSetting object to allow customization of the analysis. These
       #
       # Settings options
       #
       #   :name => name of the setting to display in application
       #
       #   :data_type_id => Type of data these setting needs to be linked to see DataType constants for values
       #
       #   :mode =>    1 input
       #               2 output
       #               3 both
       #
       #   :column_no => which column in protocol to read from
       #
       #   :default_value => default value
       #
       #   :options => Array of allowed options for the value
       #
       #   :mandatory => is needed to work
       #
       #   :level_no => nil manually entered
       #               0 read from each root context
       #               1 read as vector from 1st child level
       #    
       #
       def self.setup(name=nil)
         name ||= self.name
         defaults = AnalysisMethod.new(:name=>name,:description=>self.description,:class_name=>self.to_s)
         defaults.settings << AnalysisSetting.new(:name=> 'filename',  :data_type_id=>Biorails::Type::TEXT, :mode=>3, :default_value=>'grid.csv')
         defaults
       end
       
       def self.name
         'csv-export'
       end
       
       def self.description
         'Simple Code Template for plugin generatea a csv text file and add it as a asset'
       end
       #
       # Initialize Analysis Processor with a task to run 
       #  
       # task => a Task object to get the data from
       # config => options AnalysisMethod instance to configure the process
       #
       def initialize(task,config=nil)
         @task = task
         @config = config || self.setup
       end
       
       #
       # Get the current matrix of data to process
       #
       def matrix
         @matrix = @task.to_matrix unless @matrix  
         @matrix
       end
          
        #
        # Get a single setting from the configuration by name
        #
       def setting(name)
         unless @config
           @config = self.defaults
         end  
         @config.setting(name)
       end
       #
       # Get the value of a setting from the configuration
       # This may return a single item of a array of values depending of the level of the setting 
       #
       def get(name)
         param = setting(name)
         if param.nil?
            return nil 
     
          elsif param.level_no.nil? or param.column_no.nil?
            return param.default_value
            
         else
           return self.matrix.column(param.column_no.to_i).to_a if param.level_no>0
           self.matrix[param.column_no.to_i,0]
           
         end
       end
       #
       # The the parameter/setting name for display
       #
       def get_name(name)
         param = setting(name)
         return nil  if param.nil?
         return param.parameter.name if param.parameter
         param.name
       end
       #
       # Create a directory for files used in this processing operation  
       #
       def dirname
          return @dirname if @dirname
          @dirname = File.join(RAILS_ROOT,'public',task.project.dom_id,task.dom_id)
          FileUtils.mkdir_p(dirname)
          return @dirname
       end
       ##
       # For each matching context run the analysis process
       #
       def run
          filename = get('filename') || "snapshot.csv"
          data = FasterCSV.generate do |csv|
              csv << task.to_titles
              matrix.each do |row|
                  a = row.to_a 
                  csv << a if a 
              end
          end          
          return task.folder.add_asset(filename,filename,'text/csv',data.to_s)
       end
       #
       # Rport on the analysis
       #
       def to_html
          out = " <b> Plots of Data </b><br/>"
          out << "<table class='report'>"
          out << "<tr><th>row</th>"
          for title in @task.to_titles
             out << "<th>#{title} </th>"
          end
          out << "</tr>"
          
          matrix.each do |row|
            if row
             out << "<tr><th>#{row[0]}</th>"
             row.each {|col| "<td>#{col}</td>"}
             out << "</tr>"
            end
          end
          out << "</table>"
          out << "<br/>"
          out     
       end
         
    end
  end
end