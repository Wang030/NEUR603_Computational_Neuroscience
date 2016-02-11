function [coeffs] = morlet_wavelet(thedat,sr,freqs)

% Continuous wavelet tranform using the morlet wavelet
%
% Syntax:
% coeffs = morlet_wavelet(thedat,sr,freqs);
%
% thedat: the signal
% sr    : sampling rate of the signal
% freqs : vector containing the frequency values for which the coefficients
%         will be calculated
%
% Example-1:
% coeffs = morlet_wavelet(x,1000,(100:2:200))
% will return the CWT coefficients of signal x, sampled at 1000Hz spanned 
% over 100-200 Hz with a step of 2 Hz
%
%
% Written by Theo Zanos, 2006

    z0 = 5;
    
    isodd = mod(length(thedat),2)==1;
    if isodd
        thedat = thedat(1:end-1);
    end
    if size(thedat,1)==1
        thedat = thedat';
    end
    fftd = fft(thedat);
    coeffs = zeros(length(thedat),length(freqs));
    
    
    
    for ii = 1:length(freqs)
        x = [0:length(thedat)/2,-length(thedat)/2+1:-1]';
        x = x*freqs(ii)/sr;
        morletwavelet = (cos(2*pi*x) + 1i*sin(2*pi*x)).* ...
            exp(-2*x.^2*pi^2/z0^2) - exp(-z0^2/2-2*x.^2*pi^2/z0^2);
        coeffs(:,ii) = ifft(fftd.*fft(morletwavelet));
        display(['frequency: ' num2str(ii)]);
    end
    coeffs = coeffs';
    if isodd
        coeffs = [coeffs,coeffs(:,end)];
    end
end