# Question 3
load('fft.rb')
require 'csv'
require 'complex'
class Phase
  include(Math)
  include(FFT)
  attr_reader :n, :twenty_pi, :pulses, :pulse_psds, :tone

  def initialize
    @n = 256.0
    @twenty_pi = 20 * PI
    @pulses = Array.new(16)
    @psds = Array.new(16)
    @tone = Array.new(@n) { 0 }
    create_pulses
    make_psds
  end

  def create_pulses
    (0...@pulses.length).each do |i|
      j = i * 16
      @pulses[i] = Array.new(@n) { 0 }
      @pulses[i][j] = 1
    end
  end

  def make_psds
    (0...@psds.length).each do |i|
      @psds[i] = Marshal.load(Marshal.dump(@pulses[i]))
      fast_fourier_transform!(@psds[i])
      (0...@psds[i].length).each do |j|
        @psds[i][j] *= @psds[i][j].conjugate
        @psds[i][j] = @psds[i][j].real
      end
    end
  end

  def make_tone
    (0...@tone.length).each do |i|
      t = i/@n
      c = 0 #needs to vary
      @tone[i] = sin(@twenty_pi * (t - c))
    end
  end
end

p = Phase.new
CSV.open('psds.csv', 'w') do |csv|
  (0...p.psds.length).each do |i|
    csv << p.psds[i]
  end
end
