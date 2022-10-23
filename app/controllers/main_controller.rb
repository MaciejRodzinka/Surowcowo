class MainController < ApplicationController
  def index
    @currency_exchange_rate = params[:currency].present? ? GetApiData.get_exchange_rate(params[:currency]) : 1
    @currency = params[:currency].present? ? translate_currency(params[:currency]) : translate_currency('pln')
    date_param = params[:date]&.to_i
    days_number = date_param.present? ? date_param : 30
    @days_filter = days_number.days.ago..Time.now
    handle_colors
  end

  private

  def get_color(name)
    week_avg_price = Entry.where(name: name, date: 7.days.ago..Time.now).order(:date)&.average(:price)
    current_price = Entry.where(name: name).order(:date).last&.price
    if current_price > week_avg_price
      'green'
    elsif current_price < week_avg_price
      'red'
    else
      'yellow'
    end
  end

  def handle_colors
    @coal_price_color = get_color('coal')
    @gas_price_color = get_color('gas')
    @electricity_price_color = get_color('electricity')
    @pb95_price_color = get_color('pb95')
    @pb98_price_color = get_color('pb98')
    @on_price_color = get_color('on')
    @lpg_price_color = get_color('lpg')
  end

  def translate_currency(currency)
    currencies = { pln: 'zł', eur: '€', usd: '$' }

    currencies[currency.to_sym]
  end
end
