require 'httparty'
require 'polylines'

class GoogleDirections
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api'

  def initialize
    @options = {
      key: "AIzaSyC11jATkVy3rCtRhdXR_PuQ_8McefP96ts",
      sensor: 'false',
      mode: 'walking'
    }
  end

  def directions(from, to, opts={})
    opts.merge!({
      origin: from,
      destination: to
    })
    opts.merge!(@options)

    query = ""
    opts.each do |key, value|
      query += "&#{key}=#{value}"
    end
    response = self.class.get("/directions/json?#{query}")
    p response.request.last_uri.to_s
    response
  end
end


class Router
  attr_accessor :api

  def initialize
    @api = GoogleDirections.new
  end

  def route(from, to)
    directions = @api.directions("#{from[:lat]},#{from[:long]}", "#{to[:lat]},#{to[:long]}")
    routes = directions['routes']
    route = routes.first
    return unless route
    points = []
    legs = route['legs']
    legs.each do |leg|
      steps = leg['steps']
      next unless steps
      steps.each_with_index do |step, index|
        polyline = step['polyline']['points']
        decoded_poly = Polylines::Decoder.decode_polyline(polyline)
        points += decoded_poly.map do |coord|
          {
            lat: coord.first,
            long: coord.last
          }
        end
      end
    end

    return unless points.length > 0

    points
  end
end
