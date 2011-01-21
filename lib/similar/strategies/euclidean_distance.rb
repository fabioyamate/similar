module Similar
  module Strategies
    module EuclideanDistance
      extend self

      def distance(p, q)
        raise InvalidDimension if p.size != q.size
        squares = p.zip(q).map { |(pn, qn)| (pn - qn)**2 }
        sum = 0.0
        squares.each { |n| sum += n }
        Math.sqrt(sum)
      end

      def similarity(p, q)
        1/(1 + self.distance(p, q))
      end
    end
  end
end
