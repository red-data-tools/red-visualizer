require_relative 'helper'

module Charty
  module Colors
    class RGB
      include Helper

      def self.from_hex_string(hex_string)
        case hex_string.to_str.match(/\A#(\h+)\z/) { $1 }.length
        when 3  # rgb
          r, g, b = hex_string.scan(/\h/).map {|h| h.hex * 17 }
          new(r, g, b)
        when 6  # rrggbb
          r, g, b = hex_string.scan(/\h{2}/).map(&:hex)
          new(r, g, b)
        else
          raise ArgumentError, "Invalid hex string: #{hex_string.inspect}"
        end
      rescue NoMethodError
        raise ArgumentError, "hex_string must be a hexadecimal string of `#rrggbb` or `#rgb` form"
      end

      def initialize(r, g, b)
        @r, @g, @b = canonicalize(r, g, b)
      end

      attr_reader :r, :g, :b

      def components
        [r, g, b]
      end

      def r=(r)
        @r = if r.instance_of?(Integer)
               check_range(r, 0..255, :r) / 255r
             else
               Rational(check_range(r, 0..1, :r))
             end
      end

      def g=(g)
        @g = if g.instance_of?(Integer)
               check_range(g, 0..255, :g) / 255r
             else
               Rational(check_range(g, 0..1, :g))
             end
      end

      def b=(b)
        @b = if b.instance_of?(Integer)
               check_range(b, 0..255, :b) / 255r
             else
               Rational(check_range(b, 0..1, :b))
             end
      end

      alias red r
      alias green g
      alias blue b

      alias red= r=
      alias green= g=
      alias blue= b=

      def ==(other)
        case other
        when RGBA
          other == self
        when RGB
          r == other.r && g == other.g && b == other.b
        else
          super
        end
      end

      def to_hex_string
        "##{[r, g, b].map {|c| "%02x" % (255*c).to_i }.join('')}"
      end

      def to_rgb
        self
      end

      def to_rgba(alpha: 1.0)
        case alpha
        when Integer
          alpha = check_range(alpha, 0..255, :alpha)/255r
        else
          alpha = Rational(check_range(alpha, 0..1, :alpha))
        end
        RGBA.new(r, g, b, alpha)
      end

      def to_hsl
        m1, m2 = [r, g, b].minmax
        c = m2 - m1
        hh = case
             when c == 0
               0r
             when m2 == r
               ((g - b) / c) % 6r
             when m2 == g
               ((b - r) / c + 2) % 6r
             when m2 == b
               ((r - g) / c + 4) % 6r
             end
        h = 60r * hh
        l = 0.5r * m2 + 0.5r * m1
        s = if l == 1 || l == 0
              0r
            else
              c / (1 - (2*l - 1).abs)
            end
        Charty::Colors::HSL.new(h, s, l)
      end

      private def canonicalize(r, g, b)
        if [r, g, b].map(&:class) == [Integer, Integer, Integer]
          canonicalize_from_integer(r, g, b)
        else
          [
            Rational(check_range(r, 0..1, :r)),
            Rational(check_range(g, 0..1, :g)),
            Rational(check_range(b, 0..1, :b))
          ]
        end
      end

      private def canonicalize_from_integer(r, g, b)
        check_type(r, Integer, :r)
        check_type(g, Integer, :g)
        check_type(b, Integer, :b)
        [
          check_range(r, 0..255, :r)/255r,
          check_range(g, 0..255, :g)/255r,
          check_range(b, 0..255, :b)/255r
        ]
      end
    end
  end
end