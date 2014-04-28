require 'csv'
require 'plist'
require './router'

def walk_data(csv_file)
  p "Reading data from #{csv_file}"

  data = CSV.read(csv_file, :encoding => 'windows-1251:utf-8')
  column_names = data[0].select {|e| !e.nil?}.map {|e| e.downcase}
  attraction_data = data[1..-1]

  # Get overall route data
  walk = {
    name: "",
    description: "",
    distanceKm: 0,
    overviewImage: "",
    providerImage: "",
    attractions: []
  }

  puts "Route name?"
  walk[:name] = $stdin.gets.chomp

  puts "Route description?"
  walk[:description] = $stdin.gets.chomp

  puts "Route distanceKm?"
  walk[:distanceKm] = $stdin.gets.chomp.to_f

  puts "Route overview image name (without extension)?"
  walk[:overviewImage] = $stdin.gets.chomp

  puts "Route provider image name (without extension)?"
  walk[:providerImage] = $stdin.gets.chomp

  # Get data for attractions
  attraction_template = {
    name: "",
    entryDescription: "",
    openingTimes: "",
    lat: 0,
    long: 0,
    bearing: 0,
    distanceMeters: 0.0,
    typeImage: "",
    image: "",
    details: ""
  }

  attraction_data.each do |attraction|
    data = {}

    attraction_template.each_key do |attribute|
      column_name = attribute.to_s.downcase
      index = column_names.index(column_name)
      next unless index and !attraction[index].nil?
      p "Setting #{attraction[index]} for attribute #{attribute}"

      if column_name == "lat" or column_name == "long"
        data[attribute] = attraction[index].to_f
      else
        data[attribute] = attraction[index]
      end
    end


    unless data.empty?
      data[:entryDescription] ||= "Free Entry"
      data[:openingTimes] ||= "All Day"
      walk[:attractions] << data
    end
  end

  # Get routes between attractions
  p "Calculating route"
  router = Router.new
  attractions = walk[:attractions]
  route = []
  attractions.each_with_index do |attraction, index|
    previous_attraction = attractions[index]
    next_leg = router.route(previous_attraction, attraction)
    p "Leg has #{next_leg.length} points"
    route += next_leg unless next_leg.length < 3
  end
  p "Overal route is #{route.length} points long"

  walk[:route] = route unless route.empty?

  walk
end

walks = []
ARGV.each do |file|
  walks << walk_data(file)
end

# Store to plist
File.open("GlasgowWalking/Support/Walks.plist", 'w') do |file|
  file.puts walks.to_plist
end
