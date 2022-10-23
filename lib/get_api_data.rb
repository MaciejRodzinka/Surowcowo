require 'net/http'
require 'json'

module GetApiData
  def self.insert_record(price, name)
    Entry.create!(price: price, name: name, date: Time.current)
  end

  def self.api_request(api_link)
    uri = URI(api_link)
    response = Net::HTTP.get(uri)

    JSON.parse(response)
  end

  def self.get_exchange_rate(currency)
    response_hash = api_request("http://api.nbp.pl/api/exchangerates/rates/a/#{currency}/")

    response_hash['rates'][0]['mid']
  end

  def self.get_fuel_prices
    response_hash = api_request('https://www.wnp.pl/wykres/dane/paliwa/12/0_1_12_1_1_1_1')

    {
      pb95: get_pb95_price(response_hash),
      pb98: get_pb98_price(response_hash),
      on: get_on_price(response_hash),
      lpg: get_lpg_price(response_hash)
    }
  end

  def self.extract_fuel_price(data, fuel_position)
    data_series = data['series']
    count_datasets = data_series[fuel_position]['data'].count
    last_prices_sum = 0

    data_series[fuel_position]['data'].each do |single_dataset|
      last_prices_sum += single_dataset
    end

    last_prices_sum / count_datasets
  end

  def self.get_pb95_price(data)
    pb95_series_position = 1

    extract_fuel_price(data, pb95_series_position)
  end

  def self.get_pb98_price(data)
    pb98_series_position = 2

    extract_fuel_price(data, pb98_series_position)
  end

  def self.get_lpg_price(data)
    lpg_series_position = 3

    extract_fuel_price(data, lpg_series_position)
  end

  def self.get_on_price(data)
    on_series_position = 0

    extract_fuel_price(data, on_series_position)
  end

  def self.get_gas_price
    response_hash = api_request('https://www.wnp.pl/wykres/dane/cenygazu/3/')

    response_hash['series'][0]['data'].last
  end

  def self.get_electricity_price
    current_date = Time.now.strftime('%Y-%m-%d')
    response_hash = api_request("https://www.wnp.pl/wykres/dane/pserb/#{current_date}/pserb")
    
    if response_hash['series'][0]['data'].nil?
      current_date = (Time.now - 1.day).strftime('%Y-%m-%d')
      response_hash = api_request("https://www.wnp.pl/wykres/dane/pserb/#{current_date}/pserb")
    end
    mwh_price = response_hash['series'][0]['data'].last

    mwh_price / 1000
  end

  def self.get_coal_price
    response_hash = api_request('https://www.wnp.pl/wykres/dane/wegiel/3/')
    data_series = response_hash['series']
    count_datasets = data_series.count
    last_prices_sum = 0

    data_series.each do |single_dataset|
      last_prices_sum += single_dataset['data'].last
    end

    last_prices_sum / count_datasets
  end
end