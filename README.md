# SeemsRateable

Star rating gem for Rails application using jQuery plugin <a href="http://www.myjqueryplugins.com/jquery-plugin/jrating">jRating</a>

## Demo

<a href="http://rateable.herokuapp.com/">Demo</a> application, requires to sign up before rating 

## Instructions

### Installation

Add this line to your application's Gemfile:

    gem 'seems_rateable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seems_rateable

### Generation

    $ rails g seems_rateable User
    
Generator takes one argument which is name of an existing user model e.g User, Client, Player ... <br>
The generator creates necessary model, controller and asset files. It also creates route and migration files that are already migrated

### Prepare
    
Include Javascript files adding these lines to application.js
     
     #application.js    
     //= require rateable/jRating.jquery
     //= require rateable/rateable.jquery
     
Include CSS file adding <code><%= seems_rateable_style %></code> to your layaut head tag

Also make sure you have an existing <code>current_user</code> object. If not, add something like this to your application controller
    
    #application_controller.rb
    helper_method :current_user
    private
    def current_user
    	@current_user ||= User.find(session[:user_id]) if session[:user_id]
    end 

To prepare model be rateable add <code>seems_rateable</code> to your model file. You can also pass a hash of options to 
customize the functionality

<ul>
<li><code>:dimensions</code> Array of dimensions e.g. <code>:dimensions => [:quality, :price, :performance]</code></li>
<li><code>:allow_update</code> Allowing user to re-rate his own ratings, default set to false e.g <code>:allow_update=> true</code>
</ul>

    class Computer < ActiveRecord::Base
        seems_rateable :dimensions => [:quality, :price, :performance], :allow_update => true
    end

Each object of the model now gain these methods :
<ul>
<li><code>@computer.rates_without_dimension</code> returns array of ratings given to the object</li>
<li><code>@computer.raters_without_dimension</code> returns array of users that rated the object</li>
<li><code>@computer.rate_average_without_dimension</code> returns cached database object containing average rate and quantity of given ratings of the object</li>
</ul>

Depending on the passed dimensions your object also gain these methods :

<ul>
<li><code>@computer.dimension_rates</code> e.g <code>@computer.quality_rates</code></li>
<li><code>@computer.dimension_raters</code> e.g <code>@computer.price_raters</code></li>
<li><code>@computer.dimension_average</code> e.g <code>@computer.performance_average</code></li>
</ul>

To track user's given ratings add <code>seems_rateable_rater</code> to your user model.
Now you can access user's ratings by <code>@user.ratings_given</code>

### Usage

To display star rating use helper method <code>rating_for</code> in your view

    #index.html.erb
    
    rating_for @computer
    
    rating_for @computer, :dimension => :price, :id => "storage"
    
    rating_for @computer, :static => true

You can specify these options :
<ul>
<li><code>:dimension</code>The dimension of the object</li>
<li><code>:static</code>Set to true to display static star rating, default false</li>
<li><code>:id</code>ID of the div e.g <code>:id => "info"</code>, default nil</li>
</ul>

To edit the javascript options locate rateable.jquery.js file in /vendor/assets/javascripts/rateable/.
The javascript options are explained directly in the file

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
