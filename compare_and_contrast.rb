# Question 2
load('fft.rb')
require 'csv'
require 'complex'
class CompareAndContrast
  include(Math)
  include(FFT)
  attr_reader :n, :two_pi, :v1, :v2, :xt, :yt, :x_psd, :y_psd

  def initialize
    @n = 512.0
    @two_pi = 2 * PI
    @v1 = Array.new(@n) { 0 }
    @v2 = Array.new(@n) { 0 }
    @xt = Array.new(@n) { 0 }
    @yt = Array.new(@n) { 0 }
    @x_psd = []
    @y_psd = []
    v_1_func
    v_2_func
    create_xt
    create_yt
    create_psd
  end

  def v_1_func
    a = 1
    c = 0
    f = 13
    (0...@n).each do |i|
      t = i / @n
      @v1[i] = a * sin(@two_pi * f * (t - c))
    end
  end

  def v_2_func
    a = 1
    c = 0
    f = 31
    (0...@n).each do |i|
      t = i/@n
      @v2[i] = a * sin(@two_pi * f * (t - c))
    end
  end

  def create_xt
    (0...@n).each { |i| @xt[i] = @v1[i] + @v2[i] }
  end

  def create_yt
    (0...@n).each { |i| @yt[i] = @v1[i] * @v2[i] }
  end

  def create_psd
    @x_psd = Marshal.load(Marshal.dump(@xt))
    @y_psd = Marshal.load(Marshal.dump(@yt))
    fast_fourier_transform!(@x_psd, 1)
    fast_fourier_transform!(@y_psd, 1)
    (0...@x_psd.length).each do |i|
      @x_psd[i] *= @x_psd[i].conjugate
      @y_psd[i] *= @y_psd[i].conjugate
      @x_psd[i] = @x_psd[i].real
      @y_psd[i] = @y_psd[i].real
    end
  end
end

c2 = CompareAndContrast.new
CSV.open('c2_psd.csv', 'w') do |csv|
  csv << c2.x_psd
  csv << c2.y_psd
end
