require 'spec_helper'

describe Alphavantage::IpoCalendar do
  context "#new" do
    it "create a new calendar without client" do
      ipo_calendar = Alphavantage::IpoCalendar.new key: @config["key"]
      expect(ipo_calendar.class).to eq Alphavantage::IpoCalendar
    end

    it "create a new calendar from client" do
      calendar = @client.calendar
      expect(calendar.class).to eq Alphavantage::IpoCalendar
    end

    it "can change datatype" do
      bool = []
      ipo_calendar = @client.ipo_calendar
      bool << ipo_calendar.datatype
      begin
        ipo_calendar.datatype = "ciao"
      rescue Alphavantage::Error => e
        bool << "error"
      end
      ipo_calendar.datatype = "csv"
      bool << stock.datatype
      ipo_calendar.datatype = "json"
      expect(bool).to eq ["json", "error", "csv"]
    end

    it "can check its calendar" do
      dates = @client.calendar symbol: "BTC", market: "DKK"
      calendar = dates.calendar
      expect(calendar.count).to eq 1
    end
  end
end
