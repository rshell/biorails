# 
# Based on mephiso code by Rick Olson
#   License =>  public domain
#
class BaseDrop < Liquid::Drop
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::CaptureHelper
#
# extra method driven attrbuties
#
  class_inheritable_reader :extra_attributes
  write_inheritable_attribute :extra_attributes, [:id]
#
# Attributes to hidden from the user
#
  class_inheritable_reader :hidden_attributes
  write_inheritable_attribute :hidden_attributes,[]

  attr_reader :source
  delegate :hash, :to => :source
  
  def initialize(source)
    @source = source
    @liquid = source.attributes
    extra_attributes.each{|i| @liquid[i.to_s] = @source.send(i)}
    hidden_attributes.each{|i| @liquid[i.to_s] = "<!--Blanked #{i}-->"}
  end
  
  def protect_against_forgery?
    false
  end
  
  def context=(current_context)
    current_context.registers[:controller].send(:cached_references) << @source if @source && current_context.registers[:controller]
    # @site is set for every drop except SiteDrop, or you get into an infinite loop
    super
  end
  
  def logger
    @source.logger
  end   

  def before_method(method)
    @liquid[method.to_s]
  end

  def eql?(comparison_object)
    self == (comparison_object)
  end
  
  def ==(comparison_object)
    self.source == (comparison_object.is_a?(self.class) ? comparison_object.source : comparison_object)
  end

  # converts an array of records to an array of liquid drops, and assigns the given context to each of them
  def self.liquify(current_context, *records, &block)
    i = -1
    records = 
      records.inject [] do |all, r|
        i+=1
        attrs = (block && block.arity == 1) ? [r] : [r, i]
        all << (block ? block.call(*attrs) : r.to_liquid)
        all.last.context = current_context if all.last.is_a?(Liquid::Drop)
        all
      end
    records.compact!
    records
  end

  protected
    def self.timezone_dates(*attrs)
      attrs.each do |attr_name|
        module_eval <<-end_eval
          def #{attr_name}
            class << self; attr_reader :#{attr_name}; end
            @#{attr_name} = (@source.#{attr_name} ? @site.timezone.utc_to_local(@source.#{attr_name}) : nil)
          end
        end_eval
      end
    end
    
    def liquify(*records, &block)
      self.class.liquify(@context, *records, &block)
    end
end
