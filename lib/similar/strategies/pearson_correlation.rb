module Similar
  module Strategies
    module PearsonCorrelation
      extend self

      def distance(p, q)
        raise InvalidDimension if p.size != q.size
        return 0 if p.empty?

        sum1 = sum(p)
        sum2 = sum(q)

        sum1_sq = sum_of_squares(p)
        sum2_sq = sum_of_squares(q)

        p_sum = sum_of_product(p, q)

        n = p.size

        num = p_sum - (sum1*sum2/n)
        d = Math.sqrt((sum1_sq - (sum1**2)/n)*(sum2_sq - (sum2**2)/n))
        d == 0 ? 0 : num/d
      end

      private

      def sum(p)
        sum = 0.0
        p.each { |pn| sum += pn }
        sum
      end

      def sum_of_squares(p)
        sum(p.map { |pn| pn**2 })
      end

      def sum_of_product(p, q)
        sum(p.zip(q).map { |pn, qn| pn * qn })
      end
    end
  end
end
