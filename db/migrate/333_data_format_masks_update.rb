class DataFormatMasksUpdate < ActiveRecord::Migration
  def self.up
    for format in DataFormat.find(:all)
      puts "!!! #{format.name} in #{format.format_regex} out #{format.format_sprintf} "

      if format.format_sprintf =='%d %s'
        format.format_sprintf ='%d'
        puts "    update data_formats set format_sprintf = '%d' where id=#{format.id};"
        format.save
      end
      if format.data_type_id==3
        format.format_sprintf = '%Y-%m-%d'
        puts "    update data_formats set format_sprintf = '%Y-%m-%d' where id=#{format.id};"
        format.save
      end
    end
  end

  def self.down
  end
end
