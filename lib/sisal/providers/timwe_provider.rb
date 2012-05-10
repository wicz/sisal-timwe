require "sisal/provider"
require "rest-client"

module Sisal
  module Providers
    def self.timwe(options)
      TimweProvider.new(options)
    end

    class TimweProvider < Provider
      def initialize(options = {})
        @partner_role_id  = options[:partner_role_id]
        @password         = options[:password]
        @product_id       = options[:product_id]
        @price_point_id   = options[:price_point_id]
      end

      def send(message, options = {})
        params = {
          PartnerRoleId:  @partner_role_id,
          Password:       @password,
          ProductId:      @product_id,
          PricePointId:   @price_point_id,
          Destination:    message.to,
          Text:           message.text,
          ExtTxId:        options[:exttxid] || Time.now.to_i,
          OpId:           options[:opid]    || "1"
        }

        begin
          response = RestClient.get(API_URL, params: params)
          code = response.to_s.dup.to_i

          Sisal::Response.new((code > 0), code, status_code(code))
        rescue ::SocketError, ::Errno::ETIMEDOUT, ::RestClient::Exception => e
          Sisal::Response.new(false, nil, e.message)
        end
      end

      private

      API_URL       = "http://mb.timwe.com/sendMT"
      STATUS_CODES  = {
          0 => "General Error",
         -1 => "Invalid Destination",
         -2 => "Invalid Operator",
         -3 => "Invalid Credentials",
         -4 => "Invalid Price Point",
         -6 => "Invalid Partner Product",
        -10 => "Transaction in process",
        -12 => "Blacklisted destination",
        -19 => "Invalid Message Priority",
        -20 => "Invalid Message Purpose",
        -81 => "Blocked Billing MT for Unsubscribed Customer",
        -82 => "Blacklisted destination (Backoffice)",
        -83 => "Blacklisted destination (User Request)",
        -84 => "Blacklisted destination (User Chargeable Limit)",
        -85 => "Blacklisted destination (User MT Limit reach)",
        -86 => "Blacklisted destination (Operator Request)",
        -87 => "Blacklisted destination (Fraud)",
        -88 => "Invalid Partner External Id",
        -89 => "Invalid Sender Id",
        -90 => "Invalid Text"
      }

      def status_code(code)
        code > 0 ? "Success" : STATUS_CODES[code]
      end
    end
  end
end
