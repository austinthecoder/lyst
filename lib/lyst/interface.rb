module Lyst
  Interface = Ivo.new(:db, :add_item_events, :check_item_events) do
    def add_item(name)
      event = Events::AddItem.build(item_id: generate_id, item_name: name)
      save_add_item_event(event)
      process_add_item_event(event)
    end

    def check_item(item)
      event = Events::CheckItem.build(item_id: item.id)
      save_check_item_event(event)
      process_check_item_event(event)
    end

    def get_items
      db[:items].map do |item|
        Item.new(item[:id], item[:name], !!item[:checked])
      end
    end

    private

    def save_add_item_event(event)
      event_id = generate_id
      db.transaction do
        db[:events].insert(id: event_id, time: event.time)
        db[:add_item_events].insert(
          id: generate_id,
          event_id: event_id,
          item_id: event.item_id,
          item_name: event.item_name
        )
      end
    end

    def save_check_item_event(event)
      event_id = generate_id
      db.transaction do
        db[:events].insert(id: event_id, time: event.time)
        db[:check_item_events].insert(id: generate_id, event_id: event_id, item_id: event.item_id)
      end
    end

    def process_add_item_event(event)
      db[:items].insert(id: event.item_id, name: event.item_name)
    end

    def process_check_item_event(event)
      db[:items].where(id: event.item_id).update(checked: true)
    end

    def generate_id
      SecureRandom.uuid.gsub(/-/, "")
    end
  end
end
