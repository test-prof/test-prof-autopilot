# frozen_string_literal: true

module TestProf
  module Autopilot
    class Registry
      @items = {}

      class << self
        def register(key, klass)
          @items[key] = klass
        end

        def fetch(key)
          @items.fetch(key)
        end
      end
    end
  end
end
