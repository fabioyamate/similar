module Similar
  module Associations
    module SimilarityAssociation
      def similarity_with(record)
        return 1.0 if record == self
        name, reflection = self.class.similar_reflections.first
        key, using = reflection.options[:key], reflection.options[:using]

        # if comparing record, have an empty collection
        return 0 unless record.send(name).count > 0

        data = Hash.new { |h, k| h[k] = [] }

        # mapping to a dictionary
        self.send(name).inject(data) do |h, r|
          h[r.send(key)] << r.send(using)
          h
        end

        # retrieving similar records
        record_input = record.send(name).send("find_all_by_#{key}", data.keys)
        return 0 if record_input.empty?

        # mapping data
        record_input.inject(data) do |h, r|
          h[r.send(key)] << r.send(using)
          h
        end

        # selecting interesections
        intersection = data.select { |k, v| v.size == 2 }

        # mapping data from pairs, to separated collections
        p, q = intersection.values.transpose

        reflection.options[:strategy].similarity(p, q)
      end

      def top_matches(count=5)
        # TODO: move to a pre-calculation for similarity
        users = User.all(:conditions => ['id != ?', self.id])
        return users if users.count <= count

        # process similarity with every user
        matches = users.map do |user|
          [self.similarity_with(user), user]
        end.sort_by(&:first).last(count).reverse

        # retrieve only users
        matches.map(&:last)
      end
    end
  end
end
