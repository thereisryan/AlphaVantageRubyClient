require_relative './../../spec_helper'

describe Alphavantage::EarningsCalendar do
  it "fetches earnings without client" do
    endpoint = Alphavantage::EarningsCalendar.new key: @config["key"]
    expect(endpoint).to be_a Alphavantage::EarningsCalendar
    result = endpoint.call
    expect(result.output).to be_a Hash
    expect(result.output[:headers]).to eq %w(symbol name reportDate fiscalDateEnding estimate currency)
    expect(result.output[:items].count).to be > 1
  end

  it "fetches earnings with a client" do
    endpoint = @client.earnings_calendar
    expect(endpoint).to be_a Alphavantage::EarningsCalendar
    result = endpoint.call
    expect(result.output).to be_a Hash
    expect(result.output[:headers]).to eq %w(symbol name reportDate fiscalDateEnding estimate currency)
    expect(result.output[:items].count).to be > 1
  end
end
