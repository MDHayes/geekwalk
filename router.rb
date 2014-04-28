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
    directions = mapquest.directions("#{from[:lat]},#{from[:long]}", "#{to[:lat]},#{to[:long]}")
    route = directions['route']
    return unless route['legs']
    points = []
    legs = route['legs']
    legs.each do |leg|
      maneuvers = leg['maneuvers']
      next unless maneuvers
      points += maneuvers.map do |maneuver|
        {
          lat: maneuver['startPoint']['lat'],
          long: maneuver['startPoint']['lng']
        }
      end
    end

    return unless points.length > 0

    points
  end
end
