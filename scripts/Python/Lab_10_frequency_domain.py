import numpy as np
import matplotlib.pyplot as plt

# Simulate a 2 Hz tone for 5 seconds
sampling_rate = 100  # Set a sampling rate of 100 Hz
duration = 5  # Set the duration to 5 seconds
frequency = 2  # Set the frequency to 2 Hz

# Create time vector
time = np.arange(0, duration, 1/sampling_rate)

# Generate 2 Hz sine wave
tone = np.sin(2 * np.pi * frequency * time)

# Do an FFT of the time series
fft_result = np.fft.fft(tone)

# Plot a periodogram of the time series
plt.figure(figsize=(8, 6))
plt.subplot(2, 1, 1)
periodogram_result, frequencies, _ = plt.specgram(tone, NFFT=1024, Fs=sampling_rate)
plt.title("Periodogram")
plt.colorbar()

# Plot the power spectrum of the FFT
plt.subplot(2, 1, 2)
power_spectrum = np.abs(fft_result)**2
frequencies = np.linspace(0, sampling_rate/2, len(power_spectrum)//2)
plt.plot(frequencies, power_spectrum[:len(frequencies)], linestyle='-', marker='', color='b')
plt.xlabel("Frequency (Hz)")
plt.ylabel("Power")
plt.title("Power Spectrum")

# Adjust layout
plt.tight_layout()
plt.show()
