module SeemsRateable
  class Rating < Struct.new(:rates)
    def average
      sum/(count.nonzero? || 1)
    end

    def sum
      stars.inject(:+).to_f
    end

    def count
      stars.length
    end

    def stars
      @stars ||= rates.pluck(:stars)
    end
  end
end
