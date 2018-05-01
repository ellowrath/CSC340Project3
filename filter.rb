# Question 4
load('fft.rb')
require 'csv'
require 'complex'
class Filter
  include(Math)
  include(FFT)
  attr_reader :n, :two_pi, :signal, :lp_f_signal, :hp_f_signal, :bp_f_signal,\
  :ntch_f_signal

  def initialize
    @n = 512.0
    @two_pi = 2 * PI
    @signal = sum_odd_func(50)
    @lp_f_signal = low_pass(@signal)
    @hp_f_signal = high_pass(@signal)
    @bp_f_signal = band_pass(@signal)
    @ntch_f_signal = notch(@signal)
    fixit
  end

  def sum_odd_func(s)
    sum = Array.new(@n) { 0 }
    (1..s).each do |k|
      exp = 2 * k - 1
      (0...@n).each do |i|
        t = i / @n
        sum[i] += sin(@two_pi * exp * t) / exp
      end
    end
    sum
  end

  # a = array, transformed signal
  # b = integer, starting cell of the filter
  # c = integer, end of the filter
  # b -> c is the range filtered out
  # returns an array with the filtered signal
  def create_filtered_signal(a, b, c)
    s = Marshal.load(Marshal.dump(a))
    filter = Array.new(s.length) { 1 }
    (b...c).each do |i|
      filter[i] = 0
    end
    (0...s.length).each do |i|
      s[i] *= filter[i]
    end
    s
  end

  def low_pass(a)
    b = Marshal.load(Marshal.dump(a))
    fast_fourier_transform!(b, 1)
    c = create_filtered_signal(b, 7, b.length)
    fast_fourier_transform!(c, -1)
    (0...c.length).each do |i|
      c[i] = c[i].real
    end
    c.pop
    c
  end

  def high_pass(a)
    b = Marshal.load(Marshal.dump(a))
    fast_fourier_transform!(b, 1)
    c = create_filtered_signal(b, 0, 7)
    fast_fourier_transform!(c, -1)
    (0...c.length).each do |i|
      c[i] = c[i].real
    end
    c.pop
    c
  end

  # this one is a smidge more complicated than the others
  def band_pass(a)
    b = Marshal.load(Marshal.dump(a))
    fast_fourier_transform!(b, 1)
    c = Array.new(b.length) { 0 }
    (4...8).each do |i|
      c[i] = 1
    end
    (0...b.length).each do |i|
      b[i] *= c[i]
    end
    fast_fourier_transform!(b, -1)
    (0...b.length).each do |i|
      b[i] = b[i].real
    end
    b.pop
    b
  end

  def notch(a)
    b = Marshal.load(Marshal.dump(a))
    fast_fourier_transform!(b, 1)
    c = create_filtered_signal(b, 4, 8)
    fast_fourier_transform!(c, -1)
    (0...c.length).each do |i|
      c[i] = c[i].real
    end
    c.pop
    c
  end

  def fixit
    a = Marshal.load(Marshal.dump(@lp_f_signal))
    b = Marshal.load(Marshal.dump(@hp_f_signal))
    c = Marshal.load(Marshal.dump(@bp_f_signal))
    d = Marshal.load(Marshal.dump(@ntch_f_signal))
    e= []
    (0...a.length).each do |i|
      e[i] = a[i] + b[i]
    end
    CSV.open('lpPLUShp.csv', 'w') do |csv|
      csv << e
    end
    f= []
    (0...c.length).each do |i|
      f[i] = c[i] + d[i]
    end
    CSV.open('bpPLUSnt.csv', 'w') do |csv|
      csv << f
    end
  end
end
my_filter = Filter.new
CSV.open('signals.csv', 'w') do |csv|
  csv << my_filter.signal
  csv << my_filter.lp_f_signal
  csv << my_filter.hp_f_signal
  csv << my_filter.bp_f_signal
  csv << my_filter.ntch_f_signal
end
