module Lyst
  Interface = Ivo.new(:add_item_events, :check_item_events) do
    def add_item(name)
      id = SecureRandom.uuid.gsub(/-/, "")
      add_item_events << Events::AddItem.new(id, name, Time.now.utc)
      :ok
    end

    def check_item(item)
      check_item_events << Events::CheckItem.new(item.id, Time.now.utc)
      :ok
    end

    def get_items
      add_item_events.map do |event|
        checked = check_item_events.any? { |e| e.id == event.id }
        Item.new(event.id, event.name, checked)
      end
    end
  end
end
