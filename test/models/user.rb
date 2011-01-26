class User < ActiveRecord::Base
  has_many :reviews
  similarity_on :reviews,
                :key => :title,
                :using => :rating,
                :strategy => Similar::Strategies::EuclideanDistance,
end

class Review < ActiveRecord::Base
  belongs_to :user
end

