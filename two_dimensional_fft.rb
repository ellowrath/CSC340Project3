load('fft.rb')
require 'csv'
require 'complex'
require 'RMagick'
class TwoDimensionalFFT
  include(Math)
  include(FFT)
  include(Magick)
  attr_reader :width, :height, :test_signal

  def initialize
    @width = 512
    @height = 512
    create_test_signal

  end

  def create_test_signal
    a = Array.new(@width) { Array.new(@height) { 0 } }
    (180..320).each do |r|
      (220..330).each do |c|
        a[r][c] = 255
      end
    end

    (0...@width).each do |r|
      p a[r]
    end
    # @test_signal = Vips::Image.new_from_array
  end
end

my_2dFFT = TwoDimensionalFFT.new