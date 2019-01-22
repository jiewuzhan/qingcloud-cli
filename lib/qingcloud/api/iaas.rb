module Qingcloud
  module Api
    class Iaas < Base
      def invoke
        self.class.get("/iaas/?#{request_body}&signature=#{CGI.escape(sign)}")
      end

      def sign
        sign_by("GET\n/iaas/\n")
      end

    end 
  end 
end 