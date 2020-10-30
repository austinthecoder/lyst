module Lyst
  module Events
    CheckItem = Ivo.new(:event, :item_id) do
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
