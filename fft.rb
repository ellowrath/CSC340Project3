# A set of functions to assist in doing the
# Fast Fourier Transform
# Boom
include(Math)
require 'complex'
module FFT
  # checks if the values in an array are real or complex
  # if they are real, converts them to complex
  # operates on the array
  def preprocess!(a)
    (0...a.length).each do |i|
      a[i] = a[i].to_c if a[i].real?
    end
  end

  def fast_fourier_transform(a)
    # 1.
    d = 1
    j = Complex(0, 1)
    n = a.length
    theta = -2 * PI * d / n
    r = n / 2
    # 2.
    (1...n - 1).each do |i|
      # 2.1
      w = Math.cos(i * theta) + j * Math.sin(i * theta)
      # 2.2
      (0...n - 1).each do |k|
        # 2.2.1
        u = 1
        # 2.2.2
        (0...r - 1).each do |m|
          t = a[k + m] - a[k + m + r]
          a[k + m] = a[k + m] + a[k + m + r]
          a[k + m + r] = t * u
          u = w * u
        end
        # 2.2.3
        k = k + 2 * r
      end
      # 2.3
      i = 2 * i
      r = r / 2
    end
    # 3.
    (0...n - 1).each do |i|
      r = i
      k = 0
      (1...n - 1).each do |m|
        k = 2 * k + (r % 2)
        r = r / 2
        m = 2 * m
      end
      if k > i
        t = a[i]
        a[i] = a[k]
        a[k] = t
      end
    end
    # 4.
    if d < 0
      (0...n - 1).each do |i|
        a[i] = a[i]/n
      end
    end
  end
end