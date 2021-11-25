%Project:   Estimating Room Acoustic Parameters in noisy reverb environments
%Scientist: Suradej @Unoki-lab
%Created:   Dec 1, 2020
%Updated: Nov 24, 2021
        % Mix with precise SNR
        % Noisy speecch dataset
    
clc;
[SPfilenames, SPpathname, filterindex] = uigetfile('*.wav', 'WAV-files (*.wav)', 'Select Speech files', 'MultiSelect', 'on');

desiredSNR = [-10,-5,0,5,10,15,20];
n = 0;

[noise,fn] = audioread('pink.wav');
noise = resample(noise,441000,fn);
noisePower = sum(noise.^2,1)/size(noise,1);
noisePowerdB = 10*log10(noisePower);

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

   % out = resample(noisySpeech,441000,fs);

    %filename = strcat('NoisyDAPs/pink/Pink_5dB_',SPfilenames{i});
   % audiowrite(filename,noisySpeech,44100);
  %  disp(i);
    end
end
end

%******************** EOF *********************        

