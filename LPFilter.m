%
%	Lowpass filter
%
%	y=LPFilter(x,fc,fs,opMode)
%
%	INPUTS:	x	: Input data
%		fc	: Cutoff frequency
%		fs	: Sampling frequency
%               opMode	: option of Mode('normal' or 'show') of characteristics
%	OUTPUT: y	: Output data
%	
%	Author:  Masashi Unoki
%	Created: 30 June 1995
%	Updated:  1 Dec. 2000 
%	Copyright: (c) 2000, CNBH, Univ. of Cambridge / Akagi-Lab. JAIST
%
function [y]=LPFilter(x,fc,fs,opMode)
if nargin<1, help LPFilter, return; end; 
if nargin<2, fc=30; end; 
if nargin<3, fs=20000; end; 
if nargin<4, opMode='normal'; end;

if (fc>100)&(fc<fs/2-100)
   N=9;		% Filter Order
else
   N=3;
end

w_L=2*fc/fs;
[bz,ap]=butter(N,w_L);
y=filtfilt(bz,ap,x);
%y=filter(bz,ap,x);

switch opMode
 case {'show'}
   [h,w]=freqz(bz,ap,128);
   f=w*fs/(2*pi);
   subplot(2,1,1)
   semilogy(f,abs(h));
   subplot(2,1,2)
   plot(f,angle(h)*180/pi);
   return;
 case {'normal'}
   return;
 case {'showamp'}
   FreqzAmp(bz,ap,fs,3);
   return;
 case {'showphs'}
   FreqzPhs(bz,ap,fs);
   return;
 otherwise
   error('opMode should be "normal" or "show".');
end;


