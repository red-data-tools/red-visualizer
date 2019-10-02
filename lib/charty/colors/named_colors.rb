require_relative 'color_data'

module Charty
  module Colors
    module NamedColors
      module ColorMapping
        def self.extended(obj)
          obj.instance_variable_set(:@cache, {})
        end

        attr_reader :cache

        def []=(key, value)
          super
        ensure
          cache.clear
        end

        def delete(key)
          super
        ensure
          cache.clear
        end

        def update(other)
          super
        ensure
          cache.clear
        end
      end

      MAPPING = {}
      MAPPING.extend(ColorMapping)
      MAPPING.update(Colors::ColorData::XKCD_COLORS)
      Colors::ColorData::XKCD_COLORS.each do |key, value|
        MAPPING[key.sub("grey", "gray")] = value if key.include? "grey"
      end
      MAPPING.update(Colors::ColorData::CSS4_COLORS)
      MAPPING.update(Colors::ColorData::TABLEAU_COLORS)
      Colors::ColorData::TABLEAU_COLORS.each do |key, value|
        MAPPING[key.sub("gray", "grey")] = value if key.include? "gray"
      end
      MAPPING.update(Colors::ColorData::BASE_COLORS)

      def self.[](name)
        if nth_color?(name)
          cycle = Colors::ColorData::DEFAULT_COLOR_CYCLE
          name = cycle[name[1..-1].to_i % cycle.length]
        end
        if MAPPING.cache.has_key?(name)
          color = MAPPING.cache[name]
        else
          color = lookup_no_color_cycle(name)
          MAPPING.cache[name] = color
        end
        color
      end

      def self.lookup_no_color_cycle(color)
        orig_color = color
        case color
        when /\Anone\z/i
          return Colors::RGBA.new(0, 0, 0, 0)
        when String
          # nothing to do
        when Symbol
          color = color.to_s
        else
          color = color.to_str
        end
        color = MAPPING.fetch(color, color)
        case color
        when /\A#\h+\z/
          case color.length - 1
          when 3, 6
            Colors::RGB.from_hex_string(color)
          when 4, 8
            Colors::RGBA.from_hex_string(color)
          else
            raise RuntimeError,
                  "[BUG] Invalid hex string form #{color.inspect} for #{name.inspect}"
          end
        when Array
          case color.length
          when 3
            Colors::RGB.new(*color)
          when 4
            Colors::RGBA.new(*color)
          else
            raise RuntimeError,
                  "[BUG] Invalid number of color components #{color} for #{name.inspect}"
          end
        else
          color
        end
      end

      # Return whether `name` is an item in the color cycle.
      def self.nth_color?(name)
        case name
        when String
          # do nothing
        when Symbol
          name = name.to_s
        else
          name = name.to_str
        end
        name.match?(/\AC\d+\z/)
      rescue NoMethodError, TypeError
        false
      end
    end
  end
end