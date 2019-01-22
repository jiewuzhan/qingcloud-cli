module Qingcloud
  module Api
    class Base
      include HTTParty

      base_uri "https://api.qingcloud.com"

      attr_accessor :client, :action, :options

      def initialize(client, action, options)
        @client = client
        @action = action 
        @options = options
      end

      def base_parameters  
        options.merge(access_key_id: client.access_key_id, zone: client.zone, action: action,
          signature_version: 1, signature_method: "HmacSHA256", version: 1, 
          time_stamp: Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
          )
      end

      def request_body 
        base_parameters.sort.map { |key, value|
          "#{CGI.escape key.to_s}=#{CGI.escape value.to_s}"
        }.join('&')
      end

      def sign_by(str)
        digest = OpenSSL::Digest.new('sha256')
        hmac = OpenSSL::HMAC.digest(digest, client.secret_access_key, "#{str}#{request_body}")
        signature = Base64.encode64(hmac).strip
      end

    end 
  end 
end 