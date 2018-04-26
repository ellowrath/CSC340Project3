# Question 1
load('fft.rb')
require 'csv'
require 'complex'
include(FFT)
class CommonSignals
  include(Math)
  attr_reader :n, :two_pi

  def initialize
    @n = 512.0
    @two_pi = 2 * PI
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

  def sum_even_func(s)
    sum = Array.new(@n) { 0 }
    (1..s).each do |k|
      exp = 2 * k
      (0...@n).each do |i|
        t = i / @n
        sum[i] += sin(@two_pi * exp * t) / exp
      end
    end
    sum
  end
end

cs = CommonSignals.new

CSV.open('odd.csv', 'w') do |csv|
  csv << cs.sum_odd_func(3)
  csv << cs.sum_odd_func(10)
  csv << cs.sum_odd_func(50)
end
CSV.open('even.csv', 'w') do |csv|
  csv << cs.sum_even_func(3)
  csv << cs.sum_even_func(10)
  csv << cs.sum_even_func(50)
end
f50 = cs.sum_odd_func(50)
g50 = cs.sum_even_func(50)
fast_fourier_transform!(f50, 1)
fast_fourier_transform!(g50, 1)
(0...f50.length).each do |i|
  f50[i] *= f50[i].conjugate
  f50[i] = f50[i].real
end
(0...g50.length).each do |i|
  g50[i] *= g50[i].conjugate
  g50[i] = g50[i].real
end
CSV.open('odd_psd.csv', 'w') do |csv|
  csv << f50
end
CSV.open('even_psd.csv', 'w') do |csv|
  csv << g50
end
CSV.open('odd_limit.csv', 'w') do |csv|
  csv << cs.sum_odd_func(512)
end
CSV.open('even_limit.csv', 'w') do |csv|
  csv << cs.sum_even_func(512)
end