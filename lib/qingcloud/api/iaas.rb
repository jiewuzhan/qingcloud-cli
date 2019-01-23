module Qingcloud
  module Api
    class Iaas < Base
      def invoke
        _full_request_body = "#{request_body}&signature=#{CGI.escape(sign)}"

        puts "Request: "
        ap _full_request_body.split('&').map { |a| a.split('=') }.to_h
       
        self.class.get("/iaas/?#{_full_request_body}")
      end

      def sign
        sign_by("GET\n/iaas/\n")
      end

    end 
  end 
end 