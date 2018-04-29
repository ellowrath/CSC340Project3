load('fft.rb')
require 'csv'
require 'complex'
class CorrelationAndConvolution
  include(Math)
  include(FFT)
  attr_reader :freq, :velocity, :delay, :pulse, :signal, :c_data, :distance, :p,\
              :smooth_data

  def initialize
    @freq = 50_000.0
    @velocity = 1500.0
    @delay = 0.002
    @p = 6.0
    @pulse = pull_data('pulse.txt')
    @signal = pull_data('signal.txt')
    append_zeros!(@pulse, @signal)
    @c_data = correlate(@signal, @pulse)
    @distance = @velocity * (@delay + @c_data.index(@c_data.max) / @freq) / 2.0
    @smooth_data = smooth(@signal)
    export(@signal, 'noisy_signal.csv')
    export(@smooth_data, 'smooth_signal.csv')
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
    a2 = Marshal.load(Marshal.dump(a))
    b2 = Marshal.load(Marshal.dump(b))
    fast_fourier_transform!(a2, 1)
    fast_fourier_transform!(b2, 1)
    c = []
    (0...a.length).each do |i|
      c[i] = a2[i] * b2[i].conjugate
    end
    fast_fourier_transform!(c, -1)
    (0...c.length).each do |i|
      c[i] = c[i].real
    end
    c
  end

  def convolute(a, b)
    a2 = Marshal.load(Marshal.dump(a))
    b2 = Marshal.load(Marshal.dump(b))
    fast_fourier_transform!(a2, 1)
    fast_fourier_transform!(b2, 1)
    c = []
    (0...a.length).each do |i|
      c[i] = a2[i] * b2[i]
    end
    fast_fourier_transform!(c, -1)
    (0...c.length).each do |i|
      c[i] = c[i].real
    end
    c
  end

  def smooth(a)
    b = []
    (0...a.length).each do |i|
      i < @p ? b[i] = 1 / @p : b[i] = 0.0
    end
    c = convolute(a, b)
  end

  def export(a, fn)
    a.slice!(256, a.length)
    CSV.open(fn, 'w') do |csv|
      csv << a
    end
  end
end

my_c2 = CorrelationAndConvolution.new
puts my_c2.distance