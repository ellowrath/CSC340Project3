# Question 3
load('fft.rb')
require 'csv'
require 'complex'
class Phase
  include(Math)
  include(FFT)
  attr_reader :n, :twenty_pi, :pulses, :pulse_psds, :bi_tones, :bii_tones, :phases, :bi_dft, :bii_psds

  def initialize
    @n = 256.0
    @twenty_pi = 20 * PI
    @pulses = Array.new(16)
    @psds = Array.new(16)
    @bi_tones = Array.new(2)
    @bi_dft = Array.new(2)
    @bii_tones = Array.new(20)
    @phases = Array.new(20)
    @bii_psds = Array.new(20)
    create_pulses
    make_psds
    make_bi_tones
    make_bii_tones
    make_bii_psds
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

  def make_bi_tones
    (0...@bi_tones.length).each do |i|
      c = 0.5
      @bi_tones[i] = Array.new(@n) { 0.0 }
      (0...@n).each do |j|
        t = j / @n
        @bi_tones[i][j] = sin(@twenty_pi * (t - c))
      end
    end
    (0...@bi_dft.length).each do |i|
      @bi_dft[i] = Marshal.load(Marshal.dump(@bi_tones[i]))
      fast_fourier_transform!(@bi_dft[i])
    end
  end

  def make_bii_tones
    (0...@bii_tones.length).each do |i|
      srand
      c = rand
      @phases[i] = c
      @bii_tones[i] = Array.new(@n) { 0.0 }
      (0..@n).each do |j|
        t = j / @n
        @bii_tones[i][j] = sin(@twenty_pi * (t - c))
      end
    end
  end

  def make_bii_psds
    (0...@bii_psds.length).each do |i|
      @bii_psds[i] = Marshal.load(Marshal.dump(@bii_tones[i]))
      fast_fourier_transform!(@bii_psds[i])
      (0...@bii_psds[i].length).each do |j|
        @bii_psds[i][j] *= @bii_psds[i][j].conjugate
        @bii_psds[i][j] = @bii_psds[i][j].real
      end
    end
  end
end

p = Phase.new
=begin
CSV.open('psds.csv', 'w') do |csv|
  (0...p.psds.length).each do |i|
    csv << p.psds[i]
  end
end
=end
(0...p.bii_psds.length).each do |i|
  puts i.to_s
  puts p.phases[i]
  p p.bii_psds[i]
  puts ''
end
