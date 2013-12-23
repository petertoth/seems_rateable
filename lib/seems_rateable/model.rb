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
	if average(dimension).nil?
	 CachedRating.create do |r|
	  r.avg = stars
	  r.dimension = dimension
	  r.cacheable_id = self.id
	  r.cacheable_type = self.class.name
	  r.cnt = 1
	 end						                   
	else
	 r = average(dimension)
	 r.avg = (r.avg * r.cnt + stars) / (r.cnt+1)
	 r.cnt += 1
	 r.save!
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
	if dimension.nil?
	 self.send "rate_average_without_dimension"
	else
	 self.send "#{dimension}_average"
	end      
  end
  
  def user_rate (rateable_id, dimension=nil, user_id)
  	record = self.rates(dimension).where(:rateable_id => rateable_id, rater_id: user_id)
  	if record.empty?
  		return false
  	else
  		return record.first
  	end
  end
			
  def rates(dimension=nil)
	if dimension.nil?
	 self.send "rates_without_dimension"
   else
	 self.send "#{dimension}_rates"
	end
  end
		
  def raters(dimension=nil)
	if dimension.nil?
	 self.send "raters_without_dimension"
	else
	 self.send "#{dimension}_raters"
	end
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
	 #has_many :rates_without_dimension, -> { where(dimension: nil) }, :as => :rateable, :class_name => SeemsRateable::Rate, :dependent => :destroy			  
	 has_many :rates_without_dimension, :conditions => { dimension: nil }, :as => :rateable, :class_name => SeemsRateable::Rate, :dependent => :destroy			  
	 has_many :raters_without_dimension, :through => :rates_without_dimension, :source => :rater 
	 has_one :rate_average_without_dimension, :conditions => { dimension: nil }, :as => :cacheable, :class_name => SeemsRateable::CachedRating, :dependent => :destroy
	  	  
	 @permission = opts[:allow_update] ? true : false		 
	  	 
	 def self.can_update?	 		 
	  @permission
	 end
			  
	 def self.rateable?
	  true
	 end
	  	  
	 if opts[:dimensions].is_a?(Array)
	  opts[:dimensions].each do |dimension|        
	   has_many :"#{dimension}_rates", :conditions => { dimension: dimension.to_s }, :dependent => :destroy, :class_name => SeemsRateable::Rate, :as => :rateable
	   has_many :"#{dimension}_raters", :through => :"#{dimension}_rates", :source => :rater         
	   has_one :"#{dimension}_average", :conditions => { dimension: dimension.to_s }, :as => :cacheable, :class_name => SeemsRateable::CachedRating, :dependent => :destroy
	  end
	 end	 	 					
   end
		  
	def seems_rateable_rater
	 has_many :ratings_given, :class_name => SeemsRateable::Rate, :foreign_key => :rater_id
	end	
  end
 end
end
