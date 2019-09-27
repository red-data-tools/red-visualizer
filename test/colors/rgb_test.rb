require_relative '../test_helper'

class ColorsRGBTest < Test::Unit::TestCase
  sub_test_case(".new") do
    test("with integer values") do
      c = Charty::Colors::RGB.new(1, 128, 255)
      assert_equal(1/255r, c.red)
      assert_equal(128/255r, c.green)
      assert_equal(255/255r, c.blue)

      assert_raise(ArgumentError) do
        Charty::Colors::RGB.new(0, 0, 0x100)
      end

      assert_raise(ArgumentError) do
        Charty::Colors::RGB.new(0, 0, -1)
      end
    end

    test("with float values") do
      c = Charty::Colors::RGB.new(0.0.next_float, 0.55, 1)
      assert_equal(0.0.next_float.to_r, c.red)
      assert_equal(0.55.to_r, c.green)
      assert_equal(1.0.to_r, c.blue)

      assert_raise(ArgumentError) do
        Charty::Colors::RGB.new(0.0, 0.0, 1.0.next_float)
      end

      assert_raise(ArgumentError) do
        Charty::Colors::RGB.new(0, 0, -0.1)
      end
    end

    test("with rational values") do
      c = Charty::Colors::RGB.new(1/1000r, 500/1000r, 1)
      assert_equal(1/1000r, c.red)
      assert_equal(500/1000r, c.green)
      assert_equal(1r, c.blue)

      assert_raise(ArgumentError) do
        Charty::Colors::RGB.new(0.0, 0.0, 1001/1000r)
      end

      assert_raise(ArgumentError) do
        Charty::Colors::RGB.new(0, 0, -1/1000r)
      end
    end
  end

  test("#red=") do
    c = Charty::Colors::RGB.new(0, 0, 0)
    c.red = 1r
    assert_equal(1r, c.red)
    c.red = 1.0r
    assert_equal(1r, c.red)
    c.red = 1
    assert_equal(1/255r, c.red)
    assert_raise(ArgumentError) do
      c.red = 1001/1000r
    end
    assert_raise(ArgumentError) do
      c.red = -1/1000r
    end
    assert_raise(ArgumentError) do
      c.red = -0.1
    end
    assert_raise(ArgumentError) do
      c.red = 1.0.next_float
    end
    assert_raise(ArgumentError) do
      c.red = 256
    end
    assert_raise(ArgumentError) do
      c.red = -1
    end
  end

  test("#green=") do
    c = Charty::Colors::RGB.new(0, 0, 0)
    c.green = 1r
    assert_equal(1r, c.green)
    c.green = 1.0r
    assert_equal(1r, c.green)
    c.green = 1
    assert_equal(1/255r, c.green)
    assert_raise(ArgumentError) do
      c.green = 1001/1000r
    end
    assert_raise(ArgumentError) do
      c.green = -1/1000r
    end
    assert_raise(ArgumentError) do
      c.green = -0.1
    end
    assert_raise(ArgumentError) do
      c.green = 1.0.next_float
    end
    assert_raise(ArgumentError) do
      c.green = 256
    end
    assert_raise(ArgumentError) do
      c.green = -1
    end
  end

  test("#blue=") do
    c = Charty::Colors::RGB.new(0, 0, 0)
    c.blue = 1r
    assert_equal(1r, c.blue)
    c.blue = 1.0r
    assert_equal(1r, c.blue)
    c.blue = 1
    assert_equal(1/255r, c.blue)
    assert_raise(ArgumentError) do
      c.blue = 1001/1000r
    end
    assert_raise(ArgumentError) do
      c.blue = -1/1000r
    end
    assert_raise(ArgumentError) do
      c.blue = -0.1
    end
    assert_raise(ArgumentError) do
      c.blue = 1.0.next_float
    end
    assert_raise(ArgumentError) do
      c.blue = 256
    end
    assert_raise(ArgumentError) do
      c.blue = -1
    end
  end

  test("==") do
    assert { Charty::Colors::RGB.new(0, 0, 0) == Charty::Colors::RGB.new(0, 0, 0) }
    assert { Charty::Colors::RGB.new(0, 0, 0) == Charty::Colors::RGBA.new(0, 0, 0, 1r) }
  end

  test("!=") do
    assert { Charty::Colors::RGB.new(0, 0, 0) != Charty::Colors::RGB.new(1, 0, 0) }
    assert { Charty::Colors::RGB.new(0, 0, 0) != Charty::Colors::RGB.new(0, 1, 0) }
    assert { Charty::Colors::RGB.new(0, 0, 0) != Charty::Colors::RGB.new(0, 0, 1) }
    assert { Charty::Colors::RGB.new(0, 0, 0) != Charty::Colors::RGBA.new(0, 0, 0, 0) }
  end

  test(".from_hex_string") do
    assert_equal(Charty::Colors::RGB.new(0, 0, 0),
                 Charty::Colors::RGB.from_hex_string("#000"))
    assert_equal(Charty::Colors::RGB.new(0, 0, 0),
                 Charty::Colors::RGB.from_hex_string("#000000"))
    assert_equal(Charty::Colors::RGB.new(1, 0, 0),
                 Charty::Colors::RGB.from_hex_string("#010000"))
    assert_equal(Charty::Colors::RGB.new(0, 1, 0),
                 Charty::Colors::RGB.from_hex_string("#000100"))
    assert_equal(Charty::Colors::RGB.new(0, 0, 1),
                 Charty::Colors::RGB.from_hex_string("#000001"))
    assert_equal(Charty::Colors::RGB.new(0x33, 0x66, 0x99),
                 Charty::Colors::RGB.from_hex_string("#369"))
    assert_equal(Charty::Colors::RGB.new(255, 255, 255),
                 Charty::Colors::RGB.from_hex_string("#fff"))

    # `#rgba` is error
    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string("#0000")
    end

    # `#rrggbbaa` is error
    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string("#00000000")
    end

    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string("#00")
    end

    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string("#00000")
    end

    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string("#0000000")
    end

    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string(nil)
    end

    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string(1)
    end

    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string("")
    end

    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string("333")
    end

    assert_raise(ArgumentError) do
      Charty::Colors::RGB.from_hex_string("#xxx")
    end
  end

  test("#to_hex_string") do
    assert_equal("#000000",
                 Charty::Colors::RGB.new(0, 0, 0).to_hex_string)
    assert_equal("#ff0000",
                 Charty::Colors::RGB.new(1r, 0, 0).to_hex_string)
    assert_equal("#00ff00",
                 Charty::Colors::RGB.new(0, 1r, 0).to_hex_string)
    assert_equal("#0000ff",
                 Charty::Colors::RGB.new(0, 0, 1r).to_hex_string)
    assert_equal("#ffffff",
                 Charty::Colors::RGB.new(1r, 1r, 1r).to_hex_string)
    assert_equal("#7f7f7f",
                 Charty::Colors::RGB.new(0.5, 0.5, 0.5).to_hex_string)
    assert_equal("#333333",
                 Charty::Colors::RGB.new(0x33, 0x33, 0x33).to_hex_string)
  end

  test("to_rgb") do
    black = Charty::Colors::RGB.new(0, 0, 0)
    assert_same(black, black.to_rgb)
  end

  test("#to_rgba") do
    black = Charty::Colors::RGB.new(0, 0, 0)
    assert_equal(Charty::Colors::RGBA.new(0, 0, 0, 255),
                 black.to_rgba)
    assert_equal(Charty::Colors::RGBA.new(0, 0, 0, 0),
                 black.to_rgba(alpha: 0))
    assert_equal(Charty::Colors::RGBA.new(0, 0, 0, 0.5),
                 black.to_rgba(alpha: 0.5))

    assert_raise(ArgumentError) do
      black.to_rgba(alpha: nil)
    end

    assert_raise(ArgumentError) do
      black.to_rgba(alpha: 256)
    end

    assert_raise(ArgumentError) do
      black.to_rgba(alpha: -0.1)
    end

    assert_raise(ArgumentError) do
      black.to_rgba(alpha: 1.0.next_float)
    end
  end
end
