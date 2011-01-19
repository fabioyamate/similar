module Similar
  module Strategies
    class EuclideanDistance
      def initialize(prefs)
        @prefs = prefs
      end

      def distance(p1, p2)
        Math.hypot(p1[0] - p2[0], p1[1] - p2[1])
      end

      def similarity(p1, p2)
        matches = matches(p1, p2)
        return 0 if matches.empty?

        puts matches
        sum = 0
        matches.each_key do |k|
          sum += (@prefs[p1][k] - @prefs[p2][k])**2
        end
        sum

        1/(1 + Math.sqrt(sum))
      end

      def matches(p1, p2)
        map = {}
        @prefs[p1].each_key do |i|
          map[i] = 1 if @prefs[p2][i]
        end
        map
      end
    end
  end
end
