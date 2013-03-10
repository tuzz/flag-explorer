# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'google_drive'
require 'io/console'

class CountrySeeder < Struct.new(:username, :password)

  DOCS_KEY = "0AmHC-getEWGbdGRRSmFnV2RjWko5SE5CZWpUS1g2OEE"

  def self.seed
    if ENV["USER"] && ENV["PASS"]
      username = ENV["USER"]
      password = ENV["PASS"]
    else
      print "Google username: "
      username = STDIN.gets.chomp

      print "Google password: "
      password = STDIN.noecho(&:gets).chomp
      puts
    end

    new(username, password).seed
  end

  def seed
    Country.destroy_all
    reset_auto_increment

    rows_with_flags.each do |row|
      Country.create!(
        continent:  row[0],
        name:       row[1],
        population: row[2].to_i,
        area:       row[3].to_i,
        image_url:  row[4]
      )

      print "."
      $stdout.flush
    end

    puts
  end

  private
  def rows_with_flags
    rows.select do |row|
      row.any? { |s| s.match(/http/) }
    end
  end

  def rows
    session = GoogleDrive.login(username, password)
    spreadsheet = session.spreadsheet_by_key(DOCS_KEY)
    worksheet = spreadsheet.worksheets.first

    worksheet.rows
  end

  def reset_auto_increment
    ActiveRecord::Base.connection.execute(
      "ALTER TABLE countries AUTO_INCREMENT = 1"
    )
  end

end

CountrySeeder.seed
