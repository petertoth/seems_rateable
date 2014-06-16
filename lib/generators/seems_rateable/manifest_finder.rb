module SeemsRateable
  module Generators
    module ManifestFinder
      private

      def detect_css
        manifest = 'app/assets/stylesheets/application'

        return [manifest + '.css', ' *='] if File.exist?(manifest + '.css')
        return [manifest + '.css.sass', ' //='] if File.exist?(manifest + '.css.sass')
        return [manifest + '.sass', ' //='] if File.exist?(manifest + '.sass')
        return [manifest + '.css.scss', ' //='] if File.exist?(manifest + '.css.scss')
        return [manifest + '.scss', ' //='] if File.exist?(manifest + '.scss')
      end

      def detect_js
        manifest = 'app/assets/javascripts/application'

        return [manifest + '.coffee', '//='] if File.exist?(manifest + '.coffee')
        return [manifest + '.js.coffee', '//='] if File.exist?(manifest + '.js.coffee')
        return [manifest + '.js', '//='] if File.exist?(manifest + '.js')
      end
    end
  end
end
