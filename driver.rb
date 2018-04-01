load('fft.rb')
include(FFT)

data = [26_160.0, 19_011.0, 18_757.0, 18_405.0, 17_888.0, 14_720.0, 14_285.0, \
        17_018.0, 18_014.0, 17_119.0, 16_400.0, 17_497.0, 17_846.0, 15_700.0, \
        17_636.0, 17_181.0]

preprocess!(data)
p data
fast_fourier_transform!(data)
puts ''
p data