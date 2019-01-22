module Qingcloud
  module Api
    class Client 
      attr_accessor :access_key_id, :secret_access_key, :zone

      def initialize(access_key_id, secret_access_key, zone)
        @access_key_id = access_key_id
        @secret_access_key = secret_access_key
        @zone = zone
      end
    end 
  end 
end