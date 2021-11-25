%	Function [PE] = getPowEnv(y,fs)
%	INPUTS 	: signal data                (vector)
%		    : sampling frequency in Hz   (scala)
%	OUTPUT	: Power Envelope of the signal, y.
%
%	Author : Suradej Duangpummet
%	Copyright(c), AIS-Lab. JAIST

%	Created: June 30, 2020
%	Updated: Feb 20, 2021   % change lowpass filter
%	Updated: Feb 20, 2021   % change cut-off frequency from 20 to 30 Hz
%--------------------------------------------------------
function [PE] = getPowEnv(y,fs) 
    fc = 30;    % new cut-off frequency
    fd = 60;    % downsample (Nyquist frequency)
    PE = LPFilter(abs(hilbert(y.^2)),fc,fs);    
    PE = resample(PE,fd,fs);
end
% EOF
