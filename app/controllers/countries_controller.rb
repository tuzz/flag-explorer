class CountriesController < ApplicationController

  def index
    @countries = Country.all
  end

  def show
    @country = Country.find(params[:id])

    svg = Net::HTTP.get(URI(@country.image_url))
    @histogram = SVGProfiler.new(svg).histogram
  end

end
