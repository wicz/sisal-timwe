require "spec_helper"

describe Sisal::Providers::TimweProvider do
  let(:timwe)   { Sisal::Providers::TimweProvider.new }
  let(:message) { stub(:message, to: "1234", text: "ohai") }

  before(:each) do
    stub_request(:get, /.*OpId=connfail.*/).to_raise(::SocketError)
    stub_request(:get, /.*OpId=timeout.*/).to_raise(::Errno::ETIMEDOUT)
    stub_request(:get, /.*OpId=notfound.*/).to_raise(::RestClient::Exception)
    stub_request(:get, /.*OpId=error.*/).to_return(body: "0")
    stub_request(:get, /.*OpId=success.*/).to_return(body: "123")
  end

  describe "#send" do
    it "handles connection failure" do
      response = timwe.send(message, opid: "connfail")
      response.success?.should be_false
    end

    it "handles timeout" do
      response = timwe.send(message, opid: "timeout")
      response.success?.should be_false
    end

    it "handles rest-client's exceptions" do
      response = timwe.send(message, opid: "notfound")
      response.success?.should be_false
    end

    it "sets status codes and messages on error" do
      response = timwe.send(message, opid: "error")
      response.success?.should be_false
      response.code.should eq(0)
      response.message.should eq("General Error")
    end

    it "succeeds when return code greater than zero" do
      response = timwe.send(message, opid: "success")
      response.success?.should be_true
      response.code.should eq(123)
      response.message.should eq("Success")
    end
  end
end
