require 'test_helper'

class Reviewer
  include Similar::HashSimilarity

  attr_accessor :name

  def initialize(name)
    self.name = name
    self.id = self.name
  end
end

class HashSimilarityTest < MiniTest::Unit::TestCase
  def setup
    @lisa = build_reviewer("Lisa Rose", 'A' => 2.5, 'B' => 3.5, 'C' => 3.0,
                           'D' => 3.5, 'E' => 2.5, 'F' => 3.0)

    @gene = build_reviewer("Gene Seymour", 'A' => 3.0, 'B' => 3.5, 'C' => 1.5,
                           'D' => 5.0, 'E' => 3.5, 'F' => 3.0)
  end

  def test_matches_collection_between_two_entries
    n = @lisa.normalize(@gene)
    assert_equal [[2.5, 3.5, 3.0, 3.5, 2.5, 3.0], [3.0, 3.5, 1.5, 5.0, 3.5, 3.0]], n
  end

  def test_similarity
    score = @lisa.similarity(@gene)
    assert_in_delta 0.29, score, 0.01
  end

  def build_reviewer(name, reviews={})
    r = Reviewer.new(name)
    r.strategy = Similar::Strategies::EuclideanDistance
    r.data = reviews
    r
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
