require 'active_support/concern'
module SeemsRateable

	extend ActiveSupport::Concern
			
		def rate(stars, user_id, dimension = nil)
			if update_permission && !permission(user_id, dimension)
				allow_update_average stars, user_id, dimension
			else
				rate_cannot_update stars, user_id, dimension	
			end				
		end
		
		def rate_cannot_update(stars, user_id, dimension = nil)
			if permission user_id, dimension
				rates(dimension).build do |r|
				 r.stars = stars
				 r.rater_id = user_id
				 r.save!
				end   
				update_average(stars, dimension)
			else
			  #raise "User has already voted."
			  return false
		  end	
		end
		
		def update_average(stars, dimension=nil)
			 if average(dimension).nil?
			  CachedRating.create(:avg => stars, :dimension => dimension) do |r|
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
		
		def allow_update_average(stars, user_id, dimension=nil)
			obj = rates(dimension).where(:rater_id => user_id).first!
			r = average(dimension)
			r.avg = (r.avg*r.cnt - obj.stars + stars) / (r.cnt)
			r.save!
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
		
		def permission(user_id, dimension=nil)
			#record = connection.select_one("SELECT id FROM rates WHERE rateable_id=#{self.id} and rateable_type='#{self.class.name}' and rater_id=#{user_id} and dimension#{dimension ? "='#{dimension.to_s}'" : " IS NULL"}")            
			record = Rate.where(:rateable_id => self.id, :rateable_type => self.class.name, :rater_id => user_id, :dimension => dimension)  
			record.empty? ? true : false				       
		end 
		
		def rates(dimension=nil)
			 if dimension.nil?
				self.send "rates_without_dimension"
			 else
			  self.send "#{dimension}_rates"
			 end
		end
		  
		
	def update_permission
		self.class.update_permission
	end

	module ClassMethods
	  def seems_rateable(opts={})               
		  has_many :rates_without_dimension, :as => :rateable, :class_name => "Rate",
					     :dependent => :destroy, :conditions => {:dimension => nil}
					     
		  has_many :raters_without_dimension, :through => :rates_without_dimension, :source => :rater
		  
		  has_one :rate_average_without_dimension, :as => :cacheable, :class_name => "CachedRating",
              :dependent => :destroy, :conditions => {:dimension => nil}
		  
		  @allow = opts[:allow_update] ? true : false		 
		  
		  def self.update_permission	 		 
		    @update_permission = @allow
		  end
		  
			if opts[:dimensions].is_a?(Array)
				   opts[:dimensions].each do |dimension|        
					  has_many "#{dimension}_rates", :dependent => :destroy, 
					  :conditions => {:dimension => dimension.to_s}, :class_name => "Rate", :as => :rateable
					  has_many "#{dimension}_raters", :through => "#{dimension}_rates", :source => :rater         
					  has_one "#{dimension}_average", :as => :cacheable, :class_name => "CachedRating", 
					  :dependent => :destroy, :conditions => {:dimension => dimension.to_s}
				end
		  end	 	 					
		 end
	  
		 def seems_rateable_rater
			 has_many :ratings_given, :class_name => "Rate", :foreign_key => :rater_id
		 end
	  
	end
end


class ActiveRecord::Base
	include SeemsRateable
end
