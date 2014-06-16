module SeemsRateable
  def self.config
    @config ||= Configuration.new
  end

  def self.configure(&block)
    yield config if block_given?
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor :rate_owner_class
    config_accessor :current_rater_method
    config_accessor :default_selector_class
  end

  configure do |config|
    config.rate_owner_class = 'User'
    config.current_rater_method = :current_user
    config.default_selector_class = 'rateable'
  end
end
