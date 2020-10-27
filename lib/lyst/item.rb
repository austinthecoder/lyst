module Lyst
  Item = Ivo.new(:id, :name, :checked) do
    def checked?
      checked
    end
  end
end
