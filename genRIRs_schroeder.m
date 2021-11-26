%Function generate RIRs using Schroeder's RIR model
%
% Author: Mr.Suradej D.
% PhD student in Unoki-lab
% 2021
%

RT = 0.2:0.05:3.5;
fs = 44100;

for j=1:length(RT) 
        T = RT(j)+RT(j)*0.2;
        t = 0:1/fs:T-(1/fs);
        %***********************************
        eh = exp(-6.9.*t/RT(j));

   % for i=1:100
      %  rng(i)
        n = randn(1,length(eh));
        
        h = eh.*n;
        
        h = h./max(h);
        
        filename = strcat('/media/suradej/HDD/SCOPE_dataset/RIRs/ScheRIR_',num2str(RT(j),2),'.wav');
        audiowrite(filename,h,fs,'BitsPerSample',32);
    %end
 end
