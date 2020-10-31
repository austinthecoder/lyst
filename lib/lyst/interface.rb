module Lyst
  Interface = Ivo.new(:db, :add_item_events, :check_item_events) do
    def add_item(name)
      event = Events::AddItem.build(item_id: generate_id, item_name: name)
      save_event(event)
      process_event(event)
    end

    def check_item(item)
      event = Events::CheckItem.build(item_id: item.id)
      save_event(event)
      process_event(event)
    end

    def get_items
      db[:items].map do |row|
        Item.new(row[:id], row[:name], !!row[:checked])
      end
    end

    def clear_state
      db[:items].delete
    end

    def restore_state
      db[:events].order(:time).each do |row|
        event = Event.new(name: row[:name], time: row[:time])
        data = JSON.parse(row[:data], symbolize_names: true)
        event =
          case row[:name]
          when "add_item"
            Events::AddItem.new(event, data[:item_id], data[:item_name])
          when "check_item"
            Events::CheckItem.new(event, data[:item_id])
          else
            raise "Unexpected event: #{row.inspect}"
          end
        process_event(event)
      end
    end

    private

    def save_event(event)
      event_id = generate_id
      name =
        case event
        when Events::AddItem
          "add_item"
        when Events::CheckItem
          "check_item"
        else
          raise "Unexpected event: #{event.inspect}"
        end
      data =
        case event
        when Events::AddItem
          { item_id: event.item_id, item_name: event.item_name }
        when Events::CheckItem
          { item_id: event.item_id }
        else
          raise "Unexpected event: #{event.inspect}"
        end
      data = JSON.generate(data)
      db[:events].insert(id: event_id, time: event.time, name: name, data: data)
    end

    def process_event(event)
      case event
      when Events::AddItem
        db[:items].insert(id: event.item_id, name: event.item_name)
      when Events::CheckItem
        db[:items].where(id: event.item_id).update(checked: true)
      else
        raise "Unexpected event: #{event.inspect}"
      end
    end

    def generate_id
      SecureRandom.uuid.gsub(/-/, "")
    end
  end
end
