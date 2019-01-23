module Qingcloud
  module Api
    class Base
      include HTTParty

      base_uri "https://api.qingcloud.com"

      attr_accessor :client, :action, :options, :now

      def initialize(client, action, options={}, now=nil)
        @client = client
        @action = action 
        @options = options
        @now = now || Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
      end

      protected
      def base_parameters  
        { 
          access_key_id: client.access_key_id, zone: client.zone, action: action,
          signature_version: 1, signature_method: "HmacSHA256", version: 1, 
          time_stamp: now
        }
      end

      def request_body 
        options.merge(base_parameters).sort.map { |key, value|
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