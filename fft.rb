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


  # a = array, signal to be transfromed
  # b = integer, either 1 or -1, denotes direction of transformation
  # operates on the array
  def fast_fourier_transform!(a, b)
    preprocess!(a)
    # 1.
    direction = b
    j = Complex(0, 1)
    n = a.length
    theta = -2 * PI * direction / n
    r = n / 2.0
    # 2.
    i = 1
    until i > n - 1
      # 2.1
      w = Math.cos(i * theta) + j * Math.sin(i * theta)
      # 2.2
      k = 0
      until k >= n - 1
        # 2.2.1
        u = 1
        # 2.2.2
        m = 0
        until m > r - 1
          t = a[k + m] - a[k + m + r]
          a[k + m] = a[k + m] + a[k + m + r]
          a[k + m + r] = t * u
          u = w * u
          m += 1
          # puts '2. i = ' + i.to_s + ' k = ' + k.to_s + ' m = ' + m.to_s + ' r = ' + r.to_s
        end
        # 2.2.3
        k = k + (2 * r)
      end
      # 2.3
      i = 2 * i
      r = r / 2.0
    end
    # 3.
    i = 0
    until i > n - 1
      # puts '3. i = ' + i.to_s
      r = i
      k = 0
      m = 1
      until m >= n - 1
        k = 2 * k + (r % 2)
        r = r / 2
        m = 2 * m
      end
      if k > i
        t = a[i]
        a[i] = a[k]
        a[k] = t
      end
      i += 1
    end
    # 4.
    if direction < 0
      # (0...n - 1).each do |i|
      (0...n).each do |i|
        a[i] = a[i] / n
      end
    end
  end
end