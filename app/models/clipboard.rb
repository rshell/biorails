# Files and folders can be stored temporary on the clipboard.
# 
# Objects are not persisted to the database as the nature of a clipboard object
# is that it's temporary.
# 
# This is a basic collection of ProjectElements for addition to other folders.
# 
# 
class Clipboard
  attr_reader :elements
##
# Initialize clipboard object, with the @elements as empty
#
  def initialize
    @elements = []
  end
##
# Add given element on clipboard unless it's already there
# 
  def add(element)
    @elements << element unless @elements.find{ |f| f.id == element.id }
  end

##
# Remove given element from clipboard
# 
  def remove(element)
    @elements.delete(element)
  end

##
# filtered list of items
# 
  def filter(model)
    @elements.collect{ |f| f if f['reference_type'] == model.class }.uniq
  end
end