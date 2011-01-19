require 'test_helper'

class TestEuclideanDistance < MiniTest::Unit::TestCase
  MOVIE_LIST = ["Lady in the Water", "Snakes on a Plane", "Just My Luck",
                "Superman Returns", "You, me and Dupree", "The Night Listener"]

  def setup
    collection = movie_crititcs_dataset
    @pearson = Similar::Strategies::EuclideanDistance.new(collection)
  end

  def test_calculate_distance_between_two_points
    d = @pearson.distance([4.5, 1], [4, 2])
    assert_equal 1.118033988749895, d
  end

  def test_matches_collection_between_two_entries
    m = @pearson.matches("Gene Seymour", "Michael Phillips")

    assert_includes m, "Lady in the Water"
    assert_includes m, "Superman Returns"
    assert_includes m, "The Night Listener"
    refute_includes m, "You, me and Dupree"
  end

  def test_similarity
    d = @pearson.similarity("Lisa Rose", "Gene Seymour")
    assert_equal 0.29429805508554946, d
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
      review[movie] = ratings[index]
    end
    review
  end
end
