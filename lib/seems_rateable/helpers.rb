module SeemsRateable
 	module Helpers  		
		def rating_for(obj, opts={})
			raise Errors::InvalidRateableObjectError unless obj.class.respond_to?(:rateable?)
			
			options = {
	 			:dimension => nil,
				:static => false,
	 			:class => 'rateable',
	 			:id => nil
			}.update(opts)
				  	
			content_tag :div, "", "data-average" => obj.average(options[:dimension]) ? obj.average(options[:dimension]).avg : 0, :id => options[:id],
				:class => "#{options[:class]}#{jdisabled?(options[:static])}",
				"data-id" => obj.id, "data-kls" => obj.class.name, "data-dimension" => options[:dimension]
		end
		
		def seems_rateable_stylesheet
			stylesheet_link_tag    "seems_rateable/application", media: "all", "data-turbolinks-track" => true
		end
   	
		private
		def jdisabled?(option)
			" jDisabled" if option || !current_user
		end
	end
end
