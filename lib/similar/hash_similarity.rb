module Similar
  module HashSimilarity
    attr_accessor :id, :data, :strategy

    def intersection(q)
      self.data.keys & q.data.keys
    end

    def normalize(q)
      intersection = intersection(q)
      vp, vq = Array.new(intersection.size), Array.new(intersection.size)
      intersection.each_with_index do |k,i|
        vp[i] = self.data[k]
        vq[i] = q.data[k]
      end
      [vp, vq]
    end

    def similarity(q)
      strategy.similarity(*normalize(q))
    end
  end
end
