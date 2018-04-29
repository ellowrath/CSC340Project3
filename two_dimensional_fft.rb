load('fft.rb')
require 'csv'
require 'complex'
class TwoDimensionalFFT
  include(Math)
  include(FFT)
  attr_reader :freq
end