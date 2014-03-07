require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class Strava < OmniAuth::Strategies::OAuth2
      option :name, "strava"

      option :client_options, {
          site: 'https://www.strava.com',
          authorize_url: 'https://www.strava.com/oauth/authorize',
          token_url: 'https://www.strava.com/oauth/token'
      }

      uid { raw_info['id'] }

      info do {
          name: "#{raw_info['firstname']} #{raw_info['lastname']}",
          firstname: raw_info['firstname'],
          lastname: raw_info['lastname'],
          email: raw_info['email'],
          measurement_preference: raw_info["measurement_preference"],
          location: "#{raw_info["city"]} #{raw_info["state"]}, #{raw_info["country"]}"
          }
      end

      extra { raw_info }
      
      def raw_info
        @raw_info ||= access_token.get('https://www.strava.com/api/v3/athlete').parsed
      end

     def token_params
        super.tap do |params|
          params[:client_id] = options[:client_id]
          params[:client_secret] = client.secret
          params[:access_token] = options.access_token
        end
     end
    end
  end
end

OmniAuth.config.add_camelization 'strava', 'Strava'