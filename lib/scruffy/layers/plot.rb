module Scruffy::Layers
  # ==Scruffy::Layers::Line
  #
  # Author:: Brasten Sager
  # Date:: August 7th, 2006
  #
  # Line graph.
  class Plot < Base
    
    
    # Renders line graph.
    def draw(svg, coords, options={})
      svg.g(:class => 'shadow', :transform => "translate(#{relative(0.5)}, #{relative(0.5)})") {
        svg.polyline( :points => stringify_coords(coords).join(' '), :fill => 'transparent', 
                      :stroke => 'black', 'stroke-width' => relative(2), 
                      :style => 'fill-opacity: 0; stroke-opacity: 0.35' )

        coords.each { |coord| svg.circle( :cx => coord.first, :cy => coord.last + relative(0.9), :r => relative(2), 
                                          :style => "stroke-width: #{relative(2)}; stroke: black; opacity: 0.35;" ) }
      }


      svg.polyline( :points => stringify_coords(coords).join(' '), :fill => 'none', 
                    :stroke => color.to_s, 'stroke-width' => relative(2) )

      coords.each { |coord| svg.circle( :cx => coord.first, :cy => coord.last, :r => relative(2), 
                                        :style => "stroke-width: #{relative(2)}; stroke: #{color.to_s}; fill: #{color.to_s}" ) }
    end
    
    # The highest data point on this layer, or nil if relevant_data == false
    def top_value
      @relevant_data ? points.collect{|point|point[1]}.sort.last : nil
    end
  
    # The lowest data point on this layer, or nil if relevant_data == false
    def bottom_value
      @relevant_data ? points.collect{|point|point[1]}.sort.first : nil
    end
    
    # The left data point on this layer
    def left_value
       points.collect{|point|point[0]}.sort.first 
    end
  
    # The right data point on this layer,
    def right_value
       points.collect{|point|point[0]}.sort.last
    end

      

    protected

      # Optimistic generation of coordinates for layer to use.  These coordinates are
      # just a best guess, and can be overridden or thrown away (for example, this is overridden
      # in pie charting and bar charts).
      def generate_coordinates(options = {})        
        x_range = (right_value - left_value).to_f
        options[:point_distance] = width / x_range
        coords = points.collect do |point| 
          x_coord = (options[:point_distance] * point[0]) + (width /  x_range * 0.5)
          y_coord = percentage(point[1])
          puts "#{x_coord},#{y_coord}" 
          [x_coord, y_coord]
        end
      
        coords
      end

  end


end