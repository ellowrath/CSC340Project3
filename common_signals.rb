load('fft.rb')
class CommonSignals
  include(FFT)
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
        exp2 = @two_pi * exp * t
        sum[i] += sin(exp2) / exp
      end
    end
    sum
  end
end

cs = CommonSignals.new

s_three = []
s_three = cs.sum_odd_func(3)
p s_three