require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'active_record'

require 'similar/associations'
require 'similar/hash_similarity'
require 'similar/reflection'
require 'similar/strategies'
require 'similar/strategies/euclidean_distance'
require 'similar/strategies/pearson_correlation'

module Similar
  NotImplemented = Class.new(StandardError)

  def self.included(base)
    base.send(:include, Associations)
    base.send(:include, Reflection)
  end
end

ActiveRecord::Base.send(:include, Similar)
