class RatingsController < ApplicationController

def create   
    obj = eval "#{params[:kls]}.find(#{params[:idBox]})" rescue nil
    if obj.nil?
      raise "Object does not exist."
    end
    
    if obj && obj.rate(params[:rate].to_f, current_user.id, params[:dimension])
       render :json => true
    else  
       render :json => {:error => true}
    end
  end
end