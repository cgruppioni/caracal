require 'caracal/core/models/style_model'
require 'caracal/errors'


module Caracal
  module Core
    
    # This module encapsulates all the functionality related to defining
    # paragraph styles.
    #
    module Styles
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------
          
          def self.default_styles
            [
              { id: 'Normal',   name: 'normal',    font: 'Arial',    size: 20, spacing: 276, color: '333333' },
              { id: 'Heading1', name: 'heading 1', font: 'Palatino', size: 32, top: 200 },
              { id: 'Heading2', name: 'heading 2', font: 'Palatino', size: 26, top: 200, bold: true },
              { id: 'Heading3', name: 'heading 3', font: 'Palatino', size: 24, top: 160, color: '666666', bold: true },
              { id: 'Heading4', name: 'heading 4', font: 'Palatino', size: 22, top: 160, color: '666666', underline: true },
              { id: 'Heading5', name: 'heading 5', font: 'Palatino', size: 22, top: 160, color: '666666' },
              { id: 'Heading6', name: 'heading 6', font: 'Palatino', size: 22, top: 160, color: '666666', italic: true },
              { id: 'Title',    name: 'title',     font: 'Palatino', size: 60 },
              { id: 'Subtitle', name: 'subtitle',  font: 'Arial',    size: 28, bottom: 200, color: '666666', italic: true }
            ]           
          end
          
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          #============== ATTRIBUTES ==========================
          
          def style(**options, &block)
            model = Caracal::Core::Models::StyleModel.new(options, &block)
            
            if model.valid?
              register_style(model)
            else
              raise Caracal::Errors::InvalidModelError, 'style must define an :id and :name.'
            end
          end
          
          
          #============== GETTERS =============================
          
          def styles
            @styles ||= []
          end
          
          def default_style
            styles.find { |s| s.style_default }
          end
          
          def find_style(id)
            styles.find { |s| s.matches?(id) }
          end
          
          
          #============== REGISTRATION ========================
          
          def register_style(model)
            unregister_style(model.style_id)
            styles << model
            model
          end
          
          def unregister_style(id)
            if s = find_style(id)
              styles.delete(s)
            end
          end
          
        end
      end
    end
    
  end
end