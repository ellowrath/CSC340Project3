# Question 4
load('fft.rb')
require 'csv'
require 'complex'
class Filter
  include(Math)
  include(FFT)
  attr_reader :n, :two_pi, :signal

  def initialize
    @n = 512.0
    @two_pi = 2 * PI
    @signal = sum_odd_func(50)


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
end

my_filter = Filter.new
p my_filter.signal