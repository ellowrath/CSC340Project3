load('fft.rb')
require 'csv'
require 'complex'
class DTMF
  include(Math)
  include(FFT)
  attr_reader :n, :tone_a, :tone_b, :freq, :tone_a_s, :tone_b_s, :a_hi_f, :a_lo_f, :b_hi_f, :b_lo_f

  def initialize
    @tone_a = pull_data('tonedataA1.txt')
    @tone_b = pull_data('tonedataB1.txt')
    @tone_a_s = { hi: -1, lo: -1 }
    @tone_b_s = { hi: -1, lo: -1 }
    @freq = 44_100
    @n = 4_096.0
    decode
  end

  def pull_data(fn)
    file = File.open(fn).readlines
    arr = []
    file.each_index do |ln|
      file[ln] = file[ln].delete("\n")
      arr[ln] = file[ln].to_i
    end
    arr
  end

  def fft
    fast_fourier_transform!(@tone_a, 1)
    fast_fourier_transform!(@tone_b, 1)
  end

  def highs(a, h)
    hi1_v = 0
    hi2_v = 0
    (0...a.length / 2).each do |i|
      if a[i].magnitude > hi1_v
        hi2_v = hi1_v
        h[:lo] = h[:hi]
        hi1_v = a[i].magnitude
        h[:hi] = i
      elsif a[i].magnitude >= hi2_v
        hi2_v = a[i].magnitude
        h[:lo] = i
      end
    end
  end

  def decode
    fft
    highs(@tone_a, @tone_a_s)
    highs(@tone_b, @tone_b_s)
    @a_hi_f = @freq * @tone_a_s[:hi] / @n
    @a_lo_f = @freq * @tone_a_s[:lo] / @n
    @b_hi_f = @freq * @tone_b_s[:hi] / @n
    @b_lo_f = @freq * @tone_b_s[:lo] / @n
  end
end

my_dtmf = DTMF.new
puts 'Tone A:'
puts my_dtmf.a_hi_f
puts my_dtmf.a_lo_f
puts my_dtmf.tone_a_s
puts 'Tone B:'
puts my_dtmf.b_hi_f
puts my_dtmf.b_lo_f
puts my_dtmf.tone_b_s
