require './config/boot.rb'
require 'sinatra'

before do
  Time.zone = "Eastern Time (US & Canada)"
  @date_counts = DB[:tweets].group_and_count(Sequel.cast(:created_at,Date))
                            .order(:created_at)
                            .all
                            .reverse
                            .map &:values
end

get '/:date?' do
  if params[:date]
    @date = Date.parse(params[:date]) rescue Date.today
  else
    @date = Date.today
  end

  bod = @date.beginning_of_day
  eod = @date.end_of_day

  @tweets = DB[:tweets].where{created_at > bod}.where{created_at < eod}

  erb :"index.html"
end
