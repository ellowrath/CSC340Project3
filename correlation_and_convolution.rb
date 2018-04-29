load('fft.rb')
require 'csv'
require 'complex'
class CorrelationAndConvolution
  include(Math)
  include(FFT)
  attr_reader :freq, :velocity, :delay, :pulse, :signal, :c_data, :distance

  def initialize
    @freq = 50_000.0
    @velocity = 1500.0
    @delay = 0.002
    @pulse = pull_data('pulse.txt')
    @signal = pull_data('signal.txt')
    append_zeros!(@pulse, @signal)
    fast_fourier_transform!(@pulse, 1)
    fast_fourier_transform!(@signal, 1)
    @c_data = correlate(@signal, @pulse)
    @distance = @velocity * (@delay + @c_data.index(@c_data.max) / @freq) / 2.0
  end

  def pull_data(fn)
    file = File.open(fn).readlines
    arr = []
    file.each_index do |ln|
      file[ln] = file[ln].delete("\n")
      arr[ln] = file[ln].to_f
    end
    arr
  end

  # a = array you want a bunch of zeros
  # b = array you need array a to be a long as
  def append_zeros!(a, b)
    (0...b.length).each do |i|
      a[i] = 0.0 if a[i] == nil
    end
  end

  # a = return signal
  # b = pulse
  def correlate(a, b)
    c = []
    (0...a.length).each do |i|
      c[i] = a[i] * b[i].conjugate
    end
    fast_fourier_transform!(c, -1)
    (0...c.length).each do |i|
      c[i] = c[i].real
    end
    c
  end

end

my_c2 = CorrelationAndConvolution.new
puts my_c2.distance
