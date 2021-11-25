%Project:   Estimating Room Acoustic Parameters in noisy reverb environments
%Scientist: Suradej @Unoki-lab
%Created:   Dec 1, 2020
%Updated: Nov 24, 2021
        % Mix with precise SNR
        % Noisy speecch dataset
    
clc;
[SPfilenames, SPpathname, filterindex] = uigetfile('*.wav', 'WAV-files (*.wav)', 'Select Speech files', 'MultiSelect', 'on');
%[hfilenames, hpathname, ~] = uigetfile('*.wav', 'WAV-files (*.wav)', 'Select reverb files', 'MultiSelect', 'on');

desiredSNR = [-10,-5,0,5,10,15,20];
n = 0;

[noise,fn] = audioread('pink.wav');
noise = resample(noise,441000,fn);
noisePower = sum(noise.^2,1)/size(noise,1);
%noisePowerdB = 10*log10(noisePower);
PEs = zeros(7,300);
SNRs = zeros(7,1);

centerFreq = [125 250 500 1000 2000 4000 8000];
bw = '1 octave';

T = 5;
for s = 1:7
    disp('SNR');
    disp(desiredSNR(s));
    
for i = 1:length(SPfilenames)  
    fileSP = fullfile(SPpathname,SPfilenames{i});
    
    [audioIn , fs] = audioread(fileSP); 
   % [audioIn , fs] = audioread('f2_script1_clean.wav');
    N = floor(length(audioIn)/(fs*T));

    stop = 1;
   % filename = strcat('J_FYNSA433','_',num2str(desiredSNR),'dbPink');
    filename = strcat(SPfilenames{i}(1:end-4),'_Pink_',num2str(desiredSNR(s)),'_dB');
    for j=1:N
        n = n+1;
        disp(j)
       SCOPEdata(n).filename = strcat(filename,'_',num2str(j));
       start = stop;
       stop = start+(fs*T)-1;
       x = audioIn(start:stop);
    
       for k=1:7
        octFilt = octaveFilter(centerFreq(k),bw,'SampleRate',fs);
        audioIn_k = octFilt(x);
     
        signalPower = sum(audioIn_k.^2,1)/size(audioIn_k,1);
        signalPowerdB = 10*log10(signalPower);

        scaleFactor = sqrt(signalPower./(noisePower*(10^(desiredSNR(s)/10))));

        noise = noise.*scaleFactor;

        noisePower = sum(noise.^2,1)/size(noise,1);
        noise_c = noise(1:length(audioIn_k));
        %----------------------------
        noisySpeech = noise_c + audioIn_k;
        PEs(k,:) = getPowEnv(noisySpeech,fs); 
        %----------------------------
      %  SNRs(k) = 10*log10(signalPower./noisePower);  
       end
       
       SCOPEdata(n).PEs = PEs;
      % SCOPEdata(n).SNRs = SNRs;
        
   % disp(floor(snr))
   % out = resample(noisySpeech,441000,fs);

    %filename = strcat('NoisyDAPs/pink/Pink_5dB_',SPfilenames{i});
   % audiowrite(filename,noisySpeech,44100);
  %  disp(i);
    end
end
end
%  for i = 1:length(SPfilenames)  
%       disp(i);
%       
%       fileSP = fullfile(SPpathname,SPfilenames{i});
%       [revSP , fs] = audioread(fileSP);   
%       
%        n = noise(1:length(revSP));
%        n20 = n/(sqrt(sqrt(150000)));
%        n15 = n/(sqrt(sqrt(15000)));%checked!
%        n10 = n/(sqrt(sqrt(1500)));%checked!
%        n5 = n/(sqrt(sqrt(150))); %checked!
%        
%        %**************************** 5 dB ********************************   
%         filename = strcat(SPfilenames{i}(1:end-4),'_Pink5dB.wav');
%         aacusDataset(j).filename = filename;
%         disp(filename);
%         
%          n_revSP = revSP+n5;
%          aacusDataset(j).TAEs = getTAEs(n_revSP,fs);
%          for k = 1:2900%length(hfilenames)%2900
%             if strcmp(SPfilenames{i}(1:15),hfilenames{k}(1:15)) == 1
%                 disp(hfilenames{k});
%                 fileh = fullfile(hpathname,hfilenames{k}); 
%                 [h, fs] = audioread(fileh); 
%                  T = RIR_2_T60s(h,fs);
%                 aacusDataset(j).T60s = T;
%                T60 = RIR_2_T60(h,fs);
%                 aacusDataset(j).T60 = T60;
%  
%                 e = RIR_2_EDT(h,fs);
%                 
%                 aacusDataset(j).EDTs = e;
%                 aacusDataset(j).EDT = mean(e);
%                 
%                 Ts = RIR_2_Ts(h,fs);
%                 aacusDataset(j).Tss = Ts;
%                 aacusDataset(j).Ts = mean(Ts);                                
%                 inx = find(h>0.5,1,'first');
%                 inx = inx+10;
%                 inx_80ms = inx+(0.08*fs);
%                 inx_50ms = inx+(0.05*fs);
% 
%                 num = 0;
%                 for jj=1:inx_50ms
%                   num = num+abs(h(jj))^2;
%                 end
%                   den = sum(abs(h).^2);
%                 
%                  aacusDataset(i).D50 = (num/den)*100;
%                 
%                 
%                 num = 0;
%                 den = 0;
%                 for jj=1:inx_80ms
%                     num = num + abs(h(jj))^2;
%                 end
%                 for jj= inx_80ms+1:length(h)
%                     den  = den + abs(h(jj))^2;
%                 end                
%                 
%                 aacusDataset(j).C80 = 10*log10(num/den);                  
%                 break;
%             end
%          end
%       
%          for k = 1:7
%              octFilter = octaveFilter(centerFreq(k),bw,'SampleRate',fs);
%              revSP_sub = octFilter(revSP);           
%              n_revSP_sub = octFilter(n_revSP);
%              
%              Msignal = mean(revSP_sub.^2);
%              Mnoise = mean((n_revSP_sub-revSP_sub).^2);
%              
%              SNRs(k) = 10*log10(Msignal/Mnoise);
%          end
%        %  disp(SNRs);
%          aacusDataset(j).SNRs = SNRs; 
%          SNR = mean(SNRs);
% %          disp("T60 :");
% %          disp(T60);
% %          disp("SNR :");
% %          disp(SNR);
%          aacusDataset(j).SNR = SNR;
%          
% %          [m,s] = getMTF_STI_GroundTruth(h,fs,SNR);
% %                 
% %          aacusDataset(j).MTF = m;
% %          aacusDataset(j).STI = s;            
%          
%         filename = strcat('/media/suradej/HDD/revPink_5dB/',filename);
%     %    audiowrite(filename,n_revSP,fs,'BitsPerSample',32);
%         
%  %**************************** 10 dB ********************************   
%          j = j+1;     
%          n_revSP = revSP+n10;
%          filename = strcat(SPfilenames{i}(1:end-4),'_Pink10dB.wav');  
%          aacusDataset(j).filename = filename;
%          aacusDataset(j).TAEs = getTAEs(n_revSP,fs);
%          aacusDataset(j).T60s = T;%aacusDataset(j-1).T60s;
% %                 aacusDataset(j).T60 = aacusDataset(j-1).T60;
% %                 aacusDataset(j).EDTs = aacusDataset(j-1).EDTs; 
% %                 aacusDataset(j).EDT = aacusDataset(j-1).EDT; 
% %                 aacusDataset(j).Tss =  aacusDataset(j-1).Tss;
% %                 aacusDataset(j).Ts =  aacusDataset(j-1).Ts;                                            
% %                 aacusDataset(j).D50 =  aacusDataset(j-1).D50;
% %                 aacusDataset(j).C80 = aacusDataset(j-1).C80;                
% 
% 
%          %********** Sub-band SNR Analysis *********
%          for k = 1:7
%              octFilter = octaveFilter(centerFreq(k),bw,'SampleRate',fs);
%              revSP_sub = octFilter(revSP);           
%              n_revSP_sub = octFilter(n_revSP);
%              
%              Msignal = mean(revSP_sub.^2);
%              Mnoise = mean((n_revSP_sub-revSP_sub).^2);
%              SNRs(k) = 10*log10(Msignal/Mnoise);
%          end
%         % disp(SNRs);
%          aacusDataset(j).SNRs = SNRs; 
%          SNR = mean(SNRs);
%         % disp(SNR);
%          aacusDataset(j).SNR = SNR;
%          
% %          [m,s] = getMTF_STI_GroundTruth(h,fs,SNR);
% %                 
% %          aacusDataset(j).MTF = m;
% %          aacusDataset(j).STI = s;
%                 
%          filename = strcat('/media/suradej/HDD/revPink_10dB/',filename);
%    %      audiowrite(filename,n_revSP,fs,'BitsPerSample',32);      
%          
%    %**************************** 15 dB ********************************          
%          j = j+1;
%          n_revSP = revSP+n15;
%          aacusDataset(j).TAEs = getTAEs(n_revSP,fs);
%          filename = strcat(SPfilenames{i}(1:end-4),'_Pink15dB.wav');
%          aacusDataset(j).filename = filename;
%                   aacusDataset(j).T60s = T;%aacusDataset(j-1).T60s;
% %                 aacusDataset(j).T60 = aacusDataset(j-1).T60;
% %                 aacusDataset(j).EDTs = aacusDataset(j-1).EDTs; 
% %                 aacusDataset(j).EDT = aacusDataset(j-1).EDT; 
% %                 aacusDataset(j).Tss =  aacusDataset(j-1).Tss;
% %                 aacusDataset(j).Ts =  aacusDataset(j-1).Ts;                                            
% %                 aacusDataset(j).D50 =  aacusDataset(j-1).D50;
% %                 aacusDataset(j).C80 = aacusDataset(j-1).C80;      
% 
%          for k = 1:7
%              octFilter = octaveFilter(centerFreq(k),bw,'SampleRate',fs);
%              revSP_sub = octFilter(revSP);           
%              n_revSP_sub = octFilter(n_revSP);
%              
%              Msignal = mean(revSP_sub.^2);
%              Mnoise = mean((n_revSP_sub-revSP_sub).^2);
%              SNRs(k) = 10*log10(Msignal/Mnoise);
%          end
%       %   disp(SNRs);
%          aacusDataset(j).SNRs = SNRs; 
%          SNR = mean(SNRs);
%       %   disp(SNR);
%          aacusDataset(j).SNR = SNR;
%          
%    %      [m,s] = getMTF_STI_GroundTruth(h,fs,SNR);
%                 
%       %   aacusDataset(j).MTF = m;
%        %  aacusDataset(j).STI = s;
%          filename = strcat('/media/suradej/HDD/revPink_15dB/',filename);
%   %       audiowrite(filename,n_revSP,fs,'BitsPerSample',32);
%          
%   %**************************** 20 dB ********************************           
%          j = j+1;
%          filename = strcat(SPfilenames{i}(1:end-4),'_Pink20dB.wav');
%          
%          n_revSP = revSP+n20;
%          
%          aacusDataset(j).filename = filename;
%          aacusDataset(j).TAEs = getTAEs(n_revSP,fs);        
%          aacusDataset(j).T60s = T;% aacusDataset(j-1).T60s;
% %                 aacusDataset(j).T60 = aacusDataset(j-1).T60;
% %                 aacusDataset(j).EDTs = aacusDataset(j-1).EDTs; 
% %                 aacusDataset(j).EDT = aacusDataset(j-1).EDT; 
% %                 aacusDataset(j).Tss =  aacusDataset(j-1).Tss;
% %                 aacusDataset(j).Ts =  aacusDataset(j-1).Ts;                                            
% %                 aacusDataset(j).D50 =  aacusDataset(j-1).D50;
% %                 aacusDataset(j).C80 = aacusDataset(j-1).C80; 
%                   
%          for k = 1:7
%              octFilter = octaveFilter(centerFreq(k),bw,'SampleRate',fs);
%              revSP_sub = octFilter(revSP);           
%              n_revSP_sub = octFilter(n_revSP);           
%              Msignal = mean(revSP_sub.^2);
%              Mnoise = mean((n_revSP_sub-revSP_sub).^2);
%              SNRs(k) = 10*log10(Msignal/Mnoise);
%          end
%          %disp(SNRs);
%          aacusDataset(j).SNRs = SNRs; 
%          SNR = mean(SNRs);
%          disp(T);
%          aacusDataset(j).SNR = SNR;
%          
%        %  [m,s] = getMTF_STI_GroundTruth(h,fs,SNR);
%                 
%         % aacusDataset(j).MTF = m;
%         % aacusDataset(j).STI = s;
%          filename = strcat('/media/suradej/HDD/revPink_20dB/',filename);
%       %   audiowrite(filename,n_revSP,fs,'BitsPerSample',32);                
%          j = j+1;                     
%  end
%******************** EOF *********************        

