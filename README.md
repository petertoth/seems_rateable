# SeemsRateable

Star rating gem for Rails application using jQuery plugin [jRating](http://www.myjqueryplugins.com/jquery-plugin/jrating)

## Demo

[Demo](http://seemsrateable.herokuapp.com/) application, requires to sign up before rating.

### Important! If you are upgrading from 1.x.x please do accordingly :

Run :

    $ rails g seems_rateable:uninstall_old

Then follow as instructed.

## Installation

Add this line to your application's Gemfile:

    gem 'seems_rateable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seems_rateable

### Generation

Generate required files :

	$ rails generate seems_rateable:install
	
And run :

    $ rake db:migrate

## Prepare

To prepare model add `seems_rateable` to your rateable model file. You can also pass a hash of dimensions
e.g `:quality, :price`

    Post < ActiveRecord::Base
      seems_rateable # :quality, :speed, :effectiveness
	end

	
To track user's given rates add `seems_rateable_rater` to your rater model.

    User < ActiveRecord::Base
      seems_rateable_rater
    end

## Usage

To display star rating use helper method `rating_for` in your view

    #show.html.erb

    rating_for @post

    rating_for @post, dimension: :quality, disabled: true, html_options

You can specify these options :

* `dimension` The dimension of the rating object
* `disabled` Set to true to display static star rating meaning *no* user would be allowed to rate
* `html_options` HTML options of the selector

To edit the javascript options locate rateable.js file in `app/assets/javascripts/rateable/`.
The javascript options are explained directly in the file.

## Configuration

In *config/initializers/seems_rateable.rb* you can configure these options :

* **rate\_owner_class** - Usually `User`, name of the model you put `seems_rateable_rater`
* **current\_rater_method** - The method representing a rater instance, `current_user` by default
* **default\_selector_class** - Default HTML class of the rating div


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
