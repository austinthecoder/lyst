require "securerandom"
require 'forwardable'

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
    end

    db.create_table(:add_item_events) do
      String :id
      String :event_id
      String :item_id
      String :item_name
    end

    db.create_table(:check_item_events) do
      String :id
      String :event_id
      String :item_id
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
