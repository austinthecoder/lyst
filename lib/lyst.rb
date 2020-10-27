require "securerandom"

require "lyst/version"
require "ivo"
require "icy"

module Lyst
  extend self

  def start
    Interface.new([], [])
  end
end

Icy.require_tree("lyst")
