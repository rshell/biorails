#--
# Copyright (c) 2006, Michael Schuerig, michael@schuerig.de
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'cgi'
require 'action_view/helpers/form_helper'

module BoilerPlate # :nodoc:
  module ActionViewExtensions # :nodoc:

    def self.client_side_validations(object, method_name)
      validations = object.class.reflect_on_validations_for(method_name.to_sym)
      validations.inject([]) do |memo, validation|
        # only handle unconditional validations
        unless validation.options && validation.options[:if]
          case validation.macro
          when :validates_presence_of
            memo << 'mandatory'
          when :validates_length_of
            if minlength = validation_minlength(validation.options)
              memo << encode_validation('minlength', minlength)
            end
            if maxlength = validation_maxlength(validation.options)
              memo << encode_validation('maxlength', maxlength)
            end
          when :validates_numericality_of
            if validation.options && validation.options[:only_integer]
              memo << 'integer'
            else
              memo << 'numeric'
            end
          when :validates_inclusion_of
            values = validation.options[:in]
            if values.kind_of?(Range)
  ### FIXME
              RAILS_DEFAULT_LOGGER.debug("Only inclusion validations for inclusive Ranges are supported") if values.exclude_end?
              memo << encode_validation('range', values.begin, values.end)
            else
  ### FIXME
              RAILS_DEFAULT_LOGGER.debug("Only inclusion validations for inclusive Ranges are supported")
            end
          when :validates_format_of
            memo << encode_validation('format', validation.options[:with])
          end
        end
        memo
      end
    end
    
    module InstanceTagValidationsSupport
      def self.included(instance_tag)
        return if instance_tag.kind_of? BoilerPlate::ActionViewExtensions::InstanceTagValidationsSupport
        instance_tag.send(:include, InstanceMethods)
        instance_tag.class_eval do
#          alias_method_chain :content_tag, :validation
          alias_method :content_tag_without_validation, :content_tag
          alias_method :content_tag, :content_tag_with_validation
#          alias_method_chain :tag, :validation
          alias_method :tag_without_validation, :tag
          alias_method :tag, :tag_with_validation
        end
      end

      module InstanceMethods
        def tag_with_validation(name, options = {})
          options = merge_validations!(options.dup)
          tag_without_validation(name, options)
        end
  
        def content_tag_with_validation(name, content, options = {})
          options = merge_validations!(options.dup)
          content_tag_without_validation(name, content, options)
        end
      end

      private

      def merge_validations!(options)
        if options.delete('ignore_validations')
          return options
        end
        unless method_name && object.class.respond_to?(:reflect_on_validations_for)
          return options
        end
        BoilerPlate::ActionViewExtensions.client_side_validations(object, method_name).each do |vali|
          add_class_name!(options, vali)
        end
        options
      end

      def add_class_name!(options, class_name)
        return options unless class_name
        options.stringify_keys! ### REMOVE when possible
        class_names = options['class']
        if class_names.blank?
          class_names = class_name
        else
          class_names += ' ' + class_name unless class_names.include?(class_name)
        end
        options['class'] = class_names
        options
      end

    end

    private    
    
    def self.encode_validation(name, *values)
      values = values.map {|v| CGI.escape(v.inspect).gsub('+', '%20')}.join('_')
      "validate_#{name}_#{values}"
    end

    def self.validation_minlength(options)
      minlength = options[:minimum]
      if minlength.nil?
        if range = options[:within]
          minlength = range.begin
        end
      end
      minlength
    end
  
    def self.validation_maxlength(options)
      maxlength = options[:maximum]
      if maxlength.nil?
        if range = options[:within]
          maxlength = range.exclude_end? ? range.end - 1 : range.end
        end
      end
      maxlength
    end
  end
end
