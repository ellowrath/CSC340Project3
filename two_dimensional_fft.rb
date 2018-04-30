load('fft.rb')
require 'csv'
require 'complex'
require 'vips'
class TwoDimensionalFFT
  include(Math)
  include(FFT)
  attr_reader :width, :height, :test_signal, :test_pulse, :image, :c_data,\
              :pos_inf, :neg_inf, :log_c_data

  def initialize
    @width = 512
    @height = 512
    @pos_inf = +1.0/0.0
    @neg_inf = -1.0/0.0
    create_test_signal
    create_test_pulse
    @c_data = two_dimensional_correlate(@test_signal, @test_pulse)
    scale(@c_data)
    render(@c_data, 'c_data.jpg')
    render(@log_c_data, 'log_c_data.jpg')

  end

  def create_test_signal
    @test_signal = Array.new(@width) { Array.new(@height) { 0 } }
    (180..320).each do |r|
      (220..330).each do |c|
        @test_signal[r][c] = 255
      end
    end

    (205..295).each do |r|
      (300..330).each do |c|
        @test_signal[r][c] = 0
      end
    end
    render(@test_signal, 'test_signal.jpg')
  end

  def create_test_pulse
    @test_pulse = Array.new(@width) { Array.new(@height) { 0 } }
    (0..120).each do |r|
      (0..30).each do |c|
        @test_pulse[r][c] = 255
      end
    end
    (15..105).each do |r|
      (15..30).each do |c|
        @test_pulse[r][c] = 0
      end
    end
    render(@test_pulse, 'test_pulse.jpg')
  end

  def render(a, fn)
    @image = Vips::Image.new_from_array a
    @image.write_to_file(fn)
  end

  def two_dimensional_correlate(a, b)
    a2 = Marshal.load(Marshal.dump(a))
    b2 = Marshal.load(Marshal.dump(b))
    c2 = Array.new(a.length) { Array.new(a[0].length) }
    a3 = two_d_fft!(a2, 1)
    b3 = two_d_fft!(b2, 1)
    (0...a3.length).each do |r|
      (0...a3[0].length).each do |c|
        c2[r][c] = a3[r][c] * b3[r][c].conjugate
      end
    end
    c3 = two_d_fft!(c2, -1)
    (0...c3.length).each do |r|
      (0...c3[0].length).each do |c|
        c3[r][c] = c3[r][c].real
      end
    end
    c3
  end

  def scale(a)
    max = @neg_inf
    min = @pos_inf
    (0...a.length).each do |r|
      (0...a[0].length).each do |c|
        max = a[r][c] if a[r][c] > max
        min = a[r][c] if a[r][c] < min
      end
    end
    dif = max - min
    (0...a.length).each do |r|
      (0...a[0].length).each do |c|
        a[r][c] = (a[r][c] - min)*(255.0/dif)
      end
    end
    @log_c_data = Marshal.load(Marshal.dump(a))
    (0...@log_c_data.length).each do |r|
      (0...@log_c_data[0].length).each do |c|
        @log_c_data[r][c] = log(@log_c_data[r][c] + 1)
      end
    end
  end

  def dump_2_csv(a, fn)
    CSV.open(fn, 'w') do |csv|
      (0...a.length).each do |i|
        csv << a[i]
      end
    end

  end

end

my_2dFFT = TwoDimensionalFFT.new