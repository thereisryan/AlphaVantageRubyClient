require_relative './../../spec_helper'

describe Alphavantage::Earnings do
  context "#show" do
    it "fetches earnings without client" do
      earnings = Alphavantage::Earnings.new symbol: "IBM", key: @config["key"]
      expect(earnings).to be_a Alphavantage::Earnings
    end

    it "fetches earnings with a client" do
      endpoint = @client.earnings symbol: "IBM"
      expect(endpoint).to be_a Alphavantage::Earnings
      earnings_results = endpoint.earnings[:output]

      expect(earnings_results).to be_a Hash
      expect(earnings_results).to have_key("symbol")
      expect(earnings_results["quarterlyEarnings"].length).to eq(100)
      first_quarterly_earnings_result = earnings_results["quarterlyEarnings"][0]
      expect(first_quarterly_earnings_result).to have_key("estimatedEPS")
      expect(first_quarterly_earnings_result).to have_key("fiscalDateEnding")
      expect(first_quarterly_earnings_result).to have_key("reportedDate")
      expect(first_quarterly_earnings_result).to have_key("reportedEPS")
      expect(first_quarterly_earnings_result).to have_key("surprise")
      expect(first_quarterly_earnings_result).to have_key("surprisePercentage")
    end
  end
end
