require 'test_helper'

class PearsonCorrelationTest < MiniTest::Unit::TestCase
  def setup
    @pearson = Similar::Strategies::PearsonCorrelation
  end

  def test_return_zero_if_dimension_zero
    d = @pearson.distance([], [])
    assert_equal 0, d
  end

  def test_raise_error_with_different_dimension
    assert_raises Similar::Strategies::InvalidDimension do
      @pearson.distance([1], [])
    end
  end

  def test_max_score_if_the_same
    score = @pearson.distance([1, 2, 3], [1, 2, 3])
    assert_equal 1, score
  end

  def test_lowest_score_if_inverse
    score = @pearson.distance([1, 2, 3, 4], [4, 3, 2, 1])
    assert_equal -1, score
  end

  def test_no_correlation_results_zero
    score = @pearson.distance([-1], [1])
    assert_equal 0, score

    score = @pearson.distance([-1, -1, -1], [0, 0, 0])
    assert_equal 0, score
  end

  def test_some_peason_cases
    d = @pearson.distance([1, 2, 3, 5, 8], [0.11, 0.12, 0.13, 0.15, 0.18])
    assert_in_delta 0.99, d, 0.01

    d = @pearson.distance([2.5, 3.5, 3.0, 3.5, 2.5, 3.0], [3.0, 3.5, 1.5, 5.0, 3.5, 3.0])
    assert_in_delta 0.39, d, 0.01
  end
end
