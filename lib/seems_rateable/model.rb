require 'active_support/concern'

module SeemsRateable
  module Model
    extend ActiveSupport::Concern

    def rate(stars, user_id, dimension=nil)
      if !has_rated?(user_id, dimension)
        self.rates.create do |r|
          r.stars = stars
          r.rater_id = user_id
          r.dimension = dimension
        end
        update_overall_average_rating(stars, dimension)
      elsif has_rated?(user_id, dimension) && can_update?
        update_users_rating(stars, user_id, dimension)
      else
        raise Errors::AlreadyRatedError
      end
    end

    def update_overall_average_rating(stars, dimension=nil)
      r = average(dimension)
      if r.nil?
        self.rate_averages.create do |r|
          r.avg = stars
          r.dimension = dimension
          r.cnt = 1
        end
      else
        r.avg = (r.avg * r.cnt + stars) / (r.cnt+1)
        r.cnt += 1
        r.save!
        r
      end
    end

    def update_users_rating(stars, user_id, dimension=nil)
      obj = rates(dimension).where(:rater_id => user_id).first
      current_record = average(dimension)
      current_record.avg = (current_record.avg*current_record.cnt - obj.stars + stars) / (current_record.cnt)
      current_record.save!
      obj.stars = stars
      obj.save!
    end


    def average(dimension=nil)
      rate_averages.where(dimension: dimension).first
    end

    def rates(dimension=nil)
      rates_all.where(dimension: dimension)
    end

    def raters(dimension=nil)
      raters_all.where('seems_rateable_rates.dimension = ?', dimension)
    end

    def has_rated?(user_id, dimension=nil)
      record = self.rates(dimension).where(:rater_id => user_id)
      record.empty? ? false : true
    end

    def can_update?
      self.class.can_update?
    end

    module ClassMethods
      def seems_rateable(opts={})
        has_many :rates_all, :as => :rateable, :class_name => SeemsRateable::Rate, :dependent => :destroy
        has_many :raters_all, :through => :rates_all, :class_name => SeemsRateable::Engine.config.owner_class, :source => :rater
        has_many :rate_averages, :as => :cacheable, :class_name => SeemsRateable::CachedRating, :dependent => :destroy

        self.class_variable_set(:@@permission, opts[:allow_update] ? true : false)

        def self.can_update?
          self.class_variable_get(:@@permission)
        end

        def self.rateable?
          true
        end
      end

      def seems_rateable_rater
        has_many :ratings_given, :class_name => SeemsRateable::Rate, :foreign_key => :rater_id
      end
    end
  end
end
