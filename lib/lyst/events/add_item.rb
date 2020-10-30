module Lyst
  module Events
    AddItem = Ivo.new(:event, :item_id, :item_name) do
      extend Forwardable

      class << self
        def build(**attrs)
          with(event: Event.build, **attrs)
        end
      end

      def_delegators(:event, :time)
    end
  end
end
