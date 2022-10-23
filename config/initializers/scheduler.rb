require 'rufus-scheduler'
require './lib/get_api_data.rb'

scheduler = Rufus::Scheduler.new
scheduler.in '4h' do
  gas_price = (GetApiData.get_gas_price * GetApiData.get_exchange_rate('usd')).round(2)
  electricity_price = (GetApiData.get_electricity_price).round(2)
  coal_price = (GetApiData.get_coal_price * GetApiData.get_exchange_rate('usd')).round(2)
  fuel_prices = GetApiData.get_fuel_prices

  
  last_gas_price = Entry.where(name: 'gas').order(:date).last&.price
  last_coal_price = Entry.where(name: 'coal').order(:date).last&.price
  last_electricity_price = Entry.where(name: 'electricity').order(:date).last&.price

  last_gas_price != gas_price ? GetApiData.insert_record(gas_price, 'gas') : GetApiData.insert_record(last_gas_price, 'gas')
  last_coal_price != coal_price ? GetApiData.insert_record(coal_price, 'coal') : GetApiData.insert_record(coal_price, 'coal')
  last_electricity_price != electricity_price ? GetApiData.insert_record(electricity_price, 'electricity') : GetApiData.insert_record(last_electricity_price, 'electricity')

  fuel_prices.each do |key, value|
    rounded_value = value.round(2)
    last_fuel_price = Entry.where(name: key.to_s).order(:date).last&.price
    last_fuel_price != rounded_value ? GetApiData.insert_record(rounded_value, key.to_s) : GetApiData.insert_record(last_fuel_price, key.to_s)
  end
end