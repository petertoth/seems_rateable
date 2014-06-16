module SeemsRateable
  module Models
    module ActiveRecordExtension
      def seems_rateable(*dimensions)
        has_many :_rates, -> { where dimension: nil }, as: :rateable, class_name: SeemsRateable::Rate, dependent: :destroy
        has_many :_raters, through: :_rates, source: :rater, dependent: :destroy

        dimensions.each do |dimension|
          has_many :"#{dimension}_rates", -> { where dimension: dimension }, as: :rateable, class_name: SeemsRateable::Rate, dependent: :destroy
          has_many :"#{dimension}_raters", through: :"#{dimension}_rates", source: :rater, dependent: :destroy
        end

        include Rateable
      end

      def seems_rateable_rater
        has_many :rates_given, class_name: SeemsRateable::Rate, foreign_key: :rater_id

        include Rater
      end
    end
  end
end
