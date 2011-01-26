module Similar
  module Reflection
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def similar_reflections
        @similar_reflections ||= {}
      end

      def similar_reflections=(value)
        @similar_reflections = value
      end

      def create_similar_reflection(macro, name, options, active_record)
        case macro
        when :similarity_on
          reflection = SimilarityMacroReflection.new(macro, name, options, active_record)
        end

        self.similar_reflections = self.similar_reflections.merge(name => reflection)
        reflection
      end

      def similar_reflect_on_association(association)
        similar_reflections[association]
      end
    end

    class SimilarityMacroReflection < ActiveRecord::Reflection::MacroReflection
    end
  end
end
