module Scruffy::Layers
  # ==Scruffy::Layers::Bar
  #
  # Author:: Brasten Sager
  # Date:: August 6th, 2006
  #
  # Standard candle plot graph.
  # 
  #   points  map[:low=>1,:high=>2, :avg=>2, :err=>2]
  #   
  class HighLow < Base

    # The highest data point on this layer, or nil if relevant_data == false
    def top_value
      @relevant_data ? points.collect{|point|point[:min]}.sort.last : nil
    end
  
    # The lowest data point on this layer, or nil if relevant_data == false
    def bottom_value
      @relevant_data ? points.collect{|point|point[:max]}.sort.first : nil
    end

  
    # Draw candle graph.
    def draw(svg, coords, options = {})
      coords.each do |coord|
        x = coord[0]-(@bar_width * 0.5)
        min = coord[1]
        max = coord[2]
        low = coord[3]
        high = coord[4]
        y = coord[5]
        bar_height= (height - y)

        svg.g(:transform => "translate(-#{relative(0.5)}, -#{relative(0.5)})") {
          svg.rect( :x => x, :y => y, :width => @bar_width + relative(1), 
                    :height => bar_height + relative(1), 
                    :style => "fill: black; fill-opacity: 0.15; stroke: none;" )
          svg.rect( :x => x+relative(0.5), :y => y+relative(2), 
                    :width => @bar_width + relative(1), :height => bar_height - relative(0.5), 
                    :style => "fill: black; fill-opacity: 0.15; stroke: none;" )

        }
        
        svg.rect( :x => x, :y => y, :width => @bar_width, :height => bar_height, 
                  :fill => color.to_s, 'style' => "opacity: #{opacity}; stroke: none;" )
      end
    end

    protected
    
      # Due to the size of the bar graph, X-axis coords must 
      # be squeezed so that the bars do not hang off the ends
      # of the graph.
      #
      # Unfortunately this just mean that bar-graphs and most other graphs
      # end up on different points.  Maybe adding a padding to the coordinates
      # should be a graph-wide thing?
      def generate_coordinates(options = {})
        @bar_width = (width / points.size) * 0.9
        options[:point_distance] = (width - (width / points.size)) / (points.size - 1).to_f

        coords = (0...points.size).map do |idx| 
          x_coord = (options[:point_distance] * idx) + (width / points.size * 0.5)
          y_coord = percentage(points[idx][:avg])
          low = percentage(points[idx][:low])
          high = percentage(points[idx][:high])
          err = percentage(points[idx][:err])
          [x_coord, low, high, avg-err, avg+err, high, y_coord]
        end
        coords
      end
      
  end
end