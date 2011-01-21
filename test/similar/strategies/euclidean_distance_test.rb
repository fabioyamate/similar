require 'test_helper'

class EuclideanDistanceTest < MiniTest::Unit::TestCase
  MOVIE_LIST = ["Lady in the Water", "Snakes on a Plane", "Just My Luck",
                "Superman Returns", "You, me and Dupree", "The Night Listener"]

  def setup
    @reviews = movie_crititcs_dataset
    @euclidean = Similar::Strategies::EuclideanDistance
  end

  def test_zero_magnitude
    m = @euclidean.magnitude([0, 0, 0, 0])
    assert_equal 0, m
  end

  def test_one_magnitude
    m = @euclidean.magnitude([1])
    assert_equal 1, m
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
    assert_raises Similar::Strategies::EuclideanDistance::InvalidDimension do
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

  def test_matches_collection_between_two_entries
    n = @euclidean.normalize(@reviews["Gene Seymour"], @reviews["Michael Phillips"])
    assert_equal [[3.0, 3.5, 5.0, 3.0], [2.5, 3.0, 3.5, 4.0]], n
  end

  def test_similarity
    p, q = @euclidean.normalize(@reviews["Lisa Rose"], @reviews["Gene Seymour"])
    d = @euclidean.similarity(p, q)
    assert_in_delta 0.29, d, 0.01
  end

  def movie_crititcs_dataset
    {
      "Lisa Rose"         => review_movie_list(2.5, 3.5, 3.0, 3.5, 2.5, 3.0),
      "Gene Seymour"      => review_movie_list(3.0, 3.5, 1.5, 5.0, 3.5, 3.0),
      "Michael Phillips"  => review_movie_list(2.5, 3.0, nil, 3.5, nil, 4.0),
      "Claudia Puig"      => review_movie_list(nil, 3.5, 3.0, 4.0, 2.5, 4.5),
      "Mick LaSalle"      => review_movie_list(3.0, 4.0, 2.0, 3.0, 2.0, 3.0),
      "Jack Matthews"     => review_movie_list(3.0, 4.0, 3.0, 5.0, 3.5, nil),
      "Toby"              => review_movie_list(nil, 4.5, nil, 4.0, 1.0, nil),
    }
  end

  def review_movie_list(*ratings)
    review = {}
    MOVIE_LIST.each_with_index do |movie, index|
      review[movie] = ratings[index] if ratings[index]
    end
    review
  end
end
