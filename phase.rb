# Question 3
load('fft.rb')
require 'csv'
require 'complex'
class Phase
  include(Math)
  include(FFT)
  attr_reader :n, :twenty_pi, :pulses, :pulse_conj, :bi_tones, :bii_tones, :phases, :bi_dft, :bii_psds

  def initialize
    @n = 256.0
    @twenty_pi = 20 * PI
    @pulses = Array.new(256)
    @pulse_conj = Array.new(256)
    @bi_tones = Array.new(3)
    @bi_dft = Array.new(3)
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
      @pulses[i] = Array.new(@n) { 0 }
      @pulses[i][i] = 1
    end
  end

  def make_psds
    (0...@pulses.length).each do |i|
      @pulse_conj[i] = Marshal.load(Marshal.dump(@pulses[i]))
      fast_fourier_transform!(@pulse_conj[i], 1)
      (0...@pulse_conj[i].length).each do |j|
        @pulse_conj[i][j] = @pulse_conj[i][j].conjugate
        @pulse_conj[i][j] = @pulse_conj[i][j].real
      end
    end
  end

  def make_bi_tones
    (0...@bi_tones.length).each do |i|
      c = 0.0
      @bi_tones[i] = Array.new(@n) { 0.0 }
      (0...@n).each do |j|
        t = j / @n
        @bi_tones[i][j] = sin(@twenty_pi * (t - c))
      end
      c += 0.5
    end
    (0...@bi_dft.length).each do |i|
      @bi_dft[i] = Marshal.load(Marshal.dump(@bi_tones[i]))
      fast_fourier_transform!(@bi_dft[i], 1)
    end
  end

  def make_bii_tones
    (0...@bii_tones.length).each do |i|
      srand
      c = rand(100)
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
      fast_fourier_transform!(@bii_psds[i], 1)
      (0...@bii_psds[i].length).each do |j|
        @bii_psds[i][j] *= @bii_psds[i][j].conjugate
        @bii_psds[i][j] = @bii_psds[i][j].real
      end
    end
  end
end

p = Phase.new

CSV.open('pulses.csv', 'w') do |csv|
  (0...p.pulses.length).each do |i|
    csv << p.pulses[i]
  end
end
CSV.open('pulse_conj.csv', 'w') do |csv|
  (0...p.pulse_conj.length).each do |i|
    csv << p.pulse_conj[i]
  end
end
CSV.open('bi_tones.csv', 'w') do |csv|
  (0...p.bi_tones.length).each do |i|
    csv << p.bi_tones[i]
  end
end
CSV.open('bi_dft.csv', 'w') do |csv|
  (0...p.bi_dft.length).each do |i|
    csv << p.bi_dft[i]
  end
end
CSV.open('bii_tones.csv', 'w') do |csv|
  (0...p.bii_tones.length).each do |i|
    csv << p.bii_tones[i]
  end
end
CSV.open('bii_psds.csv', 'w') do |csv|
  (0...p.bii_psds.length).each do |i|
    csv << p.bii_psds[i]
  end
end
