# Simulate a 2 Hz tone for 5 seconds
sampling_rate <- 100  # Set a sampling rate of 1000 Hz
duration <- 5  # Set the duration to 5 seconds
frequency <- 2  # Set the frequency to 2 Hz

# Create time vector
time <- seq(0, duration, 1/sampling_rate)

# Generate 2 Hz sine wave
tone <- sin(2 * pi * frequency * time)

# Do an FFT of the time series
fft_result <- fft(tone)

# Plot a periodogram of the time series
par(mfrow = c(2, 1))  # Set up a 2x1 grid for plotting
periodogram_result <- spec.pgram(tone, NFFT = 1024, Fs = sampling_rate, plot = TRUE, main = "Periodogram")

# Plot the power spectrum of the FFT
power_spectrum <- abs(fft_result)^2
frequencies <- seq(0, sampling_rate/2, length.out = length(power_spectrum))
plot(frequencies, power_spectrum[1:length(frequencies)], type = "l", xlab = "Frequency (Hz)", ylab = "Power", main = "Power Spectrum")

# Reset plotting layout
par(mfrow = c(1, 1))
