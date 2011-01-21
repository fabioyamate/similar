require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'similar/hash_similarity'
require 'similar/strategies'
require 'similar/strategies/euclidean_distance'
require 'similar/strategies/pearson_correlation'

module Similar
  NotImplemented = Class.new(StandardError)
end
