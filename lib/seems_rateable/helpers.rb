module Helpers
  	def seems_rateable_style
  		stylesheet_link_tag "rateable/jRating.jquery"
  	end
  		
  	def rating_for(obj, opts={:dimension => nil, :static => false, :id => nil}) 	  
  	   begin
  			kls = opts[:dimension].nil? ? obj.average : obj.average(opts[:dimension])
  			avg = kls ? kls.avg : 0
  			content_tag :div, "", "data-average" => avg,
  			:id => opts[:id],
        :class => "rateable#{opts[:static] ? " jDisabled" : nil}#{current_user ? nil : " jDisabled"}",
        "data-id" => obj.id, "data-kls" => obj.class.name,
        "data-dimension" => opts[:dimension]      
  		rescue StandardError => error
  			eval "raise 'Rateable object #{obj.inspect} does not exist'"
  		end
  	end
  end

class ActionView::Base
	include Helpers
end	
