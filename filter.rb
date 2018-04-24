# Question 4
load('fft.rb')
require 'csv'
require 'complex'
class Filter
  include(Math)
  include(FFT)
  attr_reader :n

end