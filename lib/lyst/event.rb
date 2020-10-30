Event = Ivo.new(:time) do
  class << self
    def build
      new(Time.now.utc)
    end
  end
end
