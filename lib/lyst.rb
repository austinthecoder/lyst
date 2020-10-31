require "securerandom"
require 'forwardable'
require "json"

require "lyst/version"
require "ivo"
require "icy"
require "sequel"

module Lyst
  extend self

  def start
    db = Sequel.sqlite

    db.create_table(:events) do
      String :id
      Time :time
      String :name
      Sting :data
    end

    db.create_table(:items) do
      String :id
      String :name
      TrueClass :checked
    end

    Interface.new(db, [], [])
  end
end

Icy.require_tree("lyst")
