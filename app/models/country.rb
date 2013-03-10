class Country < ActiveRecord::Base
  attr_accessible :name, :continent, :population, :area, :image_url
end
