require 'similar/associations/similarity_association'

module Similar
  module Associations
    def self.included(base)
      base.extend ClassMethods
    end

    class SimilarityOnMissingCollectionAssociation < ArgumentError
      def initialize(association_id)
        super("Cannot define a similarity for #{association_id} association without a collection association")
      end

    end

    module ClassMethods
      # similarity_on :reviews, :using => rating,
      #               :strategy => EuclideanDistance
      def similarity_on(association_id, options={})
        raise SimilarityOnMissingCollectionAssociation.new(association_id) unless self.reflections.has_key?(association_id)
        create_similarity_on_reflection(association_id, options)

        class_eval do
          include Similar::Associations::SimilarityAssociation
        end
      end

      private

      def create_similarity_on_reflection(association_id, options={})
        options.assert_valid_keys([:key, :using, :strategy])
        create_similar_reflection(:similarity_on, association_id, options, self)
      end
    end
  end
end

