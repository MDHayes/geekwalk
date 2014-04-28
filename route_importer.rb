require 'csv'
require 'httparty'

class MapQuest
  include HTTParty
  base_uri 'www.mapquestapi.com'

  def initialize
    @options = { :key => "Fmjtd%7Cluur2q0r2d%2C20%3Do5-9aaw1z", routeType: 'pedestrian'}
    # Fmjtd%257Cluur2q0r2d%252C20%253Do5-9aaw1z
  end

  def directions(from, to, opts={})
    opts.merge!({
      from: from,
      to: to
    })
    opts.merge!(@options)

    query = ""
    opts.each do |key, value|
      query += "&#{key}=#{value}"
    end
    response = self.class.get("/directions/v2/route?#{query}")
    response
  end
end

class Router
  attr_accessor :mapquest

  def initialize
    @mapquest = MapQuest.new
  end

  def route(from, to)
    p "Routing from #{from} to #{to}"
    directions = mapquest.directions(from, to)
    route = directions['route']
    return unless route['legs']
    points = []
    legs = route['legs']
    legs.each do |leg|
      maneuvers = leg['maneuvers']
      next unless maneuvers
      points += maneuvers.map do |maneuver|
        "#{maneuver['startPoint']['lat']},#{maneuver['startPoint']['lng']}"
      end
    end
    Route.new(points)
  end
end

class Route
  attr_accessor :points

  def initialize(route_points)
    @points = route_points
  end

  def export_to(file_name)
    return unless @points.is_a? Array and @points.length > 0
    File.open(file_name, 'w') do |file|
      file.puts '<array>'
      @points.each do |point|
        lat = point.split(',').first
        long = point.split(',').last

        file.puts '<dict>'
        file.puts '<key>lat</key>'
        file.puts "<real>#{lat}</real>"
        file.puts '<key>long</key>'
        file.puts "<real>#{long}</real>"
        file.puts '</dict>'
      end
      file.puts '</array>'
    end
  end
end

in_file = ARGV[0]
p in_file
lat_col = nil
long_col = nil
points = []
CSV.foreach(in_file) do |line|
  if lat_col and long_col
    lat = line[lat_col]
    long = line[long_col]

    points << "#{lat},#{long}" if lat and long
  else
    lat_col = line.index('lat')
    long_col = line.index('long')
  end
end

router = Router.new
route = Route.new([])
points[1..-1].each_with_index do |point, index|
  previous_point = points[index]
  next_leg = router.route(previous_point, point)
  p "Leg has #{next_leg.points.length} points"
  route.points += next_leg.points unless next_leg.points.length < 3
end

route.export_to('route.plist')

# from = "55.538,-4.59"
# to = "55.539,-4.13"
# router.route(from, to).export_to('route.plist')
