class CreateDataImportDefinitions < ActiveRecord::Migration
  def self.up
    create_table :data_import_definitions do |t|
      t.string :name, :null => false  	            #   Name of the import definition (unique)
      t.string :description, :null => false 	    # 	Description of the import definition
      t.string :default_folder_path,:default=>'.', :null => false  #	Default file polling location
      t.string :file_format,:default=>:csv, :null => false 	    # 	csv, pdf, xls, txt
      t.integer :file_header_count,:default=>0, :null => false   #	Number of file headers
      t.integer :data_header_count,:default=>0, :null => false   #	Number of headers in each area of data
      t.integer :data_header_name_row,:default=>0, :null => false # The row number within the data header section for the name of the data
      t.integer :data_header_name_col,:default=>0, :null => false #	The column number within the data header section for the name of the data
      t.integer :data_areas_count,:default=>0, :null => false     #	The number of data areas on the file (Optional)
      t.boolean :data_areas_across,:default=>false, :null => false    #	If true the data areas written across the file in columns or areas of columns
      t.integer :data_start_col,:default=>0, :null => false       # The column in which the data area actually starts
      t.integer :data_col_count,:default=>0, :null => false       # The number of columns in each data
      t.integer :data_row_count,:default=>0, :null => false       # the number of rows in each data area
      t.boolean :data_read_across,:default=>false, :null => false     #	read the data area columns across then down (true) or down then across (false)
      t.integer :file_footer_count,:default=>0, :null => false
      t.integer :lock_version, :default => 0, :null => false
      t.time    :created_at
      t.integer :created_by_user_id, :default => 1, :null => false
      t.time    :updated_at
      t.integer :updated_by_user_id, :default => 1, :null => false
    end
  end

  def self.down
    drop_table :data_import_definitions
  end
end
