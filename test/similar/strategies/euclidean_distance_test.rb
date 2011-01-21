require 'test_helper'

class EuclideanDistanceTest < MiniTest::Unit::TestCase
  def setup
    @euclidean = Similar::Strategies::EuclideanDistance
  end

  def test_distance_zero_if_points_with_zero_dimension
    d = @euclidean.distance([], [])
    assert_equal 0, d
  end

  def test_distance_zero_if_points_are_same
    d = @euclidean.distance([1,0], [1,0])
    assert_equal 0, d
  end

  def test_calculate_distance_from_famous_triagle_3_4_5
    d = @euclidean.distance([4, 3], [0, 0])
    assert_equal 5, d
  end

  def test_calculate_distance_on_2_dimension
    d = @euclidean.distance([4.5, 1], [4, 2])
    assert_in_delta 1.11, d, 0.01
  end

  def test_calculate_distance_of_n_dimension
    d = @euclidean.distance([0, 0, 0], [1, 1, 1])
    assert_in_delta 1.73, d, 0.01
  end

  def test_raise_error_when_different_dimension
    assert_raises Similar::Strategies::InvalidDimension do
      @euclidean.distance([0, 0, 0], [1])
    end
  end

  def test_max_score_if_they_are_identical
    score = @euclidean.similarity([1, 2.3, 5.1, 2], [1, 2.3, 5.1, 2])
    assert_equal 1, score
  end

  def test_simple_similarity
    score = @euclidean.similarity([4.5, 1], [4, 2])
    assert_in_delta 0.47, score, 0.01
  end

  def test_not_similar_when_distance_is_huge
    score = @euclidean.similarity([1000], [0])
    assert_in_delta 0.00, score, 0.01
  end
end
