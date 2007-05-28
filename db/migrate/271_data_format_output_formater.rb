class DataFormatOutputFormater < ActiveRecord::Migration

  def self.up
     add_column :data_formats, :format_sprintf, :string
  end

  def self.down
     remove_column :data_formats, :format_sprintf
  end

end
