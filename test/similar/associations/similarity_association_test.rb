require 'test_helper'

require 'models/user'

dbconfig = {
  :adapter => 'sqlite3',
  :database => 'test.sqlite3'
}

ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Migration.verbose = false

class TestMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :name
    end

    create_table :reviews, :force => true do |t|
      t.integer :user_id
      t.string  :title
      t.decimal :rating, :precision => 6, :scale => 4
    end
  end

  def self.down
    drop_table :reviews
    drop_table :users
  end
end

class SimilarityAssociationTest < ActiveRecord::TestCase
  def setup
    TestMigration.up
  end

  def teardown
    TestMigration.down
  end

  def test_similarity_with_same_record_results_in_one
    lisa = build_lisa_reviews
    assert_equal 1, lisa.similarity_with(lisa)
  end

  def test_comparing_same_records_not_use_query
    pending "assert_no_queries always return true"
    build_lisa_reviews
    lisa = User.first
    assert_no_queries { lisa.similarity_with(lisa) }
  end

  def test_similarity_zero_with_records_with_empty_collection
    lisa = build_lisa_reviews
    jdoe = User.create(:name => "John Doe")
    assert_equal 0, lisa.similarity_with(jdoe)
  end

  def test_similarity_zero_with_records_without_intersection_in_collection
    lisa = build_lisa_reviews
    jdoe = User.create(:name => "John Doe")
    jdoe.reviews.create(:title => "Unknown Movie", :rating => 5.0)
    assert_equal 0, lisa.similarity_with(jdoe)
  end

  def test_similarity_between_users
    lisa = build_lisa_reviews
    gene = build_gene_reviews
    assert_in_delta 0.29, lisa.similarity_with(gene), 0.01
  end

  def test_similarity_known_scenarios
    User.similarity_on :reviews, :key => :title, :using => :rating,
      :strategy => Similar::Strategies::PearsonCorrelation

    toby = build_toby_reviews
    lisa = build_lisa_reviews
    mick = build_mick_reviews
    claudia = build_claudia_reviews

    assert_in_delta 0.99, toby.similarity_with(lisa), 0.01
    assert_in_delta 0.92, toby.similarity_with(mick), 0.01
    assert_in_delta 0.89, toby.similarity_with(claudia), 0.01
  end

  def test_returns_empty_matches_if_no_record_to_compare
    toby = build_toby_reviews
    assert_empty toby.top_matches
  end

  def test_return_limited_results_for_top_matches
    toby = build_toby_reviews
    build_lisa_reviews
    build_gene_reviews
    assert_equal 1, toby.top_matches(1).count
  end


  def test_ignores_top_matches_count_if_have_less_records_than_it
    toby = build_toby_reviews
    build_lisa_reviews
    build_gene_reviews
    assert_equal 2, toby.top_matches(10).count
  end

  def test_return_top_matches_with_euclidean_distance
    toby = build_toby_reviews
    lisa = build_lisa_reviews
    gene = build_gene_reviews
    michael = build_michael_reviews
    claudia = build_claudia_reviews
    mick = build_mick_reviews
    jack = build_jack_reviews

    matches = toby.top_matches

    assert_equal 5, matches.count
    assert_kind_of User, matches.first
    assert_equal mick, matches.first
    assert_equal claudia, matches.at(2)
    refute_includes matches, gene
  end

  # TODO: extract this factories to outside
  def build_lisa_reviews
    user = User.create(:name => 'Lisa Rose')
    user.reviews.create(:title => 'A', :rating => 2.5)
    user.reviews.create(:title => 'B', :rating => 3.5)
    user.reviews.create(:title => 'C', :rating => 3.0)
    user.reviews.create(:title => 'D', :rating => 3.5)
    user.reviews.create(:title => 'E', :rating => 2.5)
    user.reviews.create(:title => 'F', :rating => 3.0)
    user
  end

  def build_gene_reviews
    user = User.create(:name => 'Gene Saymour')
    user.reviews.create(:title => 'A', :rating => 3.0)
    user.reviews.create(:title => 'B', :rating => 3.5)
    user.reviews.create(:title => 'C', :rating => 1.5)
    user.reviews.create(:title => 'D', :rating => 5.0)
    user.reviews.create(:title => 'E', :rating => 3.5)
    user.reviews.create(:title => 'F', :rating => 3.0)
    user
  end

  def build_michael_reviews
    user = User.create(:name => 'Michael Phillips')
    user.reviews.create(:title => 'A', :rating => 2.5)
    user.reviews.create(:title => 'B', :rating => 3.0)
    user.reviews.create(:title => 'D', :rating => 3.5)
    user.reviews.create(:title => 'F', :rating => 4.0)
    user
  end

  def build_claudia_reviews
    user = User.create(:name => 'Claudia Puig')
    user.reviews.create(:title => 'B', :rating => 3.5)
    user.reviews.create(:title => 'C', :rating => 3.0)
    user.reviews.create(:title => 'D', :rating => 4.0)
    user.reviews.create(:title => 'E', :rating => 2.5)
    user.reviews.create(:title => 'F', :rating => 4.5)
    user
  end

  def build_mick_reviews
    user = User.create(:name => 'Mick LaSalle')
    user.reviews.create(:title => 'A', :rating => 3.0)
    user.reviews.create(:title => 'B', :rating => 4.0)
    user.reviews.create(:title => 'C', :rating => 2.0)
    user.reviews.create(:title => 'D', :rating => 3.0)
    user.reviews.create(:title => 'E', :rating => 2.0)
    user.reviews.create(:title => 'F', :rating => 3.0)
    user
  end

  def build_jack_reviews
    user = User.create(:name => 'Jack Matthews')
    user.reviews.create(:title => 'A', :rating => 3.0)
    user.reviews.create(:title => 'B', :rating => 4.0)
    user.reviews.create(:title => 'C', :rating => 3.0)
    user.reviews.create(:title => 'D', :rating => 5.0)
    user.reviews.create(:title => 'E', :rating => 3.5)
    user
  end

  def build_toby_reviews
    user = User.create(:name => 'Toby')
    user.reviews.create(:title => 'B', :rating => 4.5)
    user.reviews.create(:title => 'D', :rating => 4.0)
    user.reviews.create(:title => 'E', :rating => 1.0)
    user
  end
end
