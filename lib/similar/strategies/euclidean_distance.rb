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

      def magnitude(p)
        sum = 0.0
        p.each { |pn| sum += pn**2 }
        sum
      end

      # TODO: move from here, this is not responsability of Euclidean algorithm
      def normalize(p, q)
        intersection = (p.keys & q.keys)
        vp, vq = Array.new(intersection.size), Array.new(intersection.size)
        intersection.each_with_index do |k,i|
          vp[i] = p[k]
          vq[i] = q[k]
        end
        [vp, vq]
      end

      def similarity(p, q)
        1/(1 + self.distance(p, q))
      end
    end
  end
end
