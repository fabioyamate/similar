require 'test_helper'
require 'models/user'

class AssociationsTest < MiniTest::Unit::TestCase
  def test_raise_error_if_collection_association_not_found
    assert_raises Similar::Associations::SimilarityOnMissingCollectionAssociation do
      Class.new(ActiveRecord::Base).similarity_on(:reviews, :using => :rating)
    end
  end

  def test_raise_error_with_invalid_argument
    klass = Class.new(ActiveRecord::Base)
    klass.has_many :something
    assert_raises ArgumentError do
      klass.similarity_on(:something, :foo => :bar)
    end
  end

  def test_store_reflections_when_similarity_on_is_defined
    refute_empty User.similar_reflections
    assert_instance_of Similar::Reflection::SimilarityMacroReflection, User.similar_reflections[:reviews]
  end
end
