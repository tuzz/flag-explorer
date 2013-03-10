class CountriesController < ApplicationController

  def index
    @countries = Country.all
  end

  def show
    @country = Country.find(params[:id])

    svg = Net::HTTP.get(URI(@country.image_url))
    profile = SVGProfiler.new(svg)
    @histogram = profile.histogram(threshold = 0.01)
  end

end
