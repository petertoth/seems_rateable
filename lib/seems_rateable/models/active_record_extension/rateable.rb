module SeemsRateable
  module Models
    module ActiveRecordExtension
      module Rateable
        %w[rates raters].each do |m|
          define_method m do |dimension=nil|
            if respond_to? "#{dimension}_#{m}"
              send "#{dimension}_#{m}"
            else
              raise Errors::NonExistentDimension, "Dimension '#{dimension.inspect}' does not exist for #{self.class}"
            end
          end
        end

        def rating(dimension=nil)
          SeemsRateable::Rating.new rates(dimension)
        end

        def rated_by?(rater, dimension=nil)
          return unless rater
          raters(dimension).include? rater
        end
      end
    end
  end
end
