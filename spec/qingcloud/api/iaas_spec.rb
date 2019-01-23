RSpec.describe Qingcloud::Api::Iaas do
  let :demo_client { Qingcloud::Api::Client.new('QYACCESSKEYIDEXAMPLE', 'SECRETACCESSKEY', 'pek1') }
  let :demo_time { "2013-08-27T14:30:10Z" }
  let :demo_action { "RunInstances" }
  let :demo_params do  
    {
      "count":1,
      "vxnets.1":"vxnet-0",
      "instance_type":"small_b",
      "signature_version":1,
      "signature_method":"HmacSHA256",
      "instance_name":"demo",
      "image_id":"centos64x86a",
      "login_mode":"passwd",
      "login_passwd":"QingCloud20130712",
      "version":1
    }
  end
  let :demo_signature { "32bseYy39DOlatuewpeuW5vpmW51sD1A%2FJdGynqSpP8%3D" }
  let :demo_request { Qingcloud::Api::Iaas.new(demo_client, demo_action, demo_params, demo_time) }

  describe ".sign" do
    it "official signature demo should eq to “32bseYy39DOlatuewpeuW5vpmW51sD1A%2FJdGynqSpP8%3D”" do
      signature = demo_request.sign

      expect(CGI.escape(signature)).to eq demo_signature
    end
  end
  
  describe ".invoke" do
    it "official RunInstances request should return RequestHasExpired" do 
      ret = demo_request.invoke 
      resp = ret.parsed_response 

      expect(resp["ret_code"]).to eq 1300
      expect(resp["message"]).to eq "RequestHasExpired"
    end
  end
end
