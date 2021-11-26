clear all;

[SPfilenames, SPpathname, filterindex] = uigetfile('*.wav', 'WAV-files (*.wav)', 'Select speech', 'MultiSelect', 'on');

[hfilenames, hpathname, ~] = uigetfile('*.wav', 'WAV-files (*.wav)', 'Select RIRs', 'MultiSelect', 'on');


count = 0;
path = '/media/suradej/HDD/SCOPE_dataset/revSpeeches/'; 

for i = 1:1%length(SPfilenames)
    fileSP = fullfile(SPpathname,SPfilenames{i});
    [SP,fs] = audioread(fileSP);  
     ind = find(SP>0.2,1,'first');
     sp = SP(ind:end);
          
    for k =1:length(hfilenames)
        fileh = fullfile(hpathname,hfilenames{k}); 
        [h, fs] = audioread(fileh); 

        revSP = conv(sp,h);
        
        out = revSP./max(revSP);

        filename = strcat(hfilenames{k}(1:end-4),'_',SPfilenames{i}(1:end-10),'.wav');
        here = strcat(path,filename);       
        audiowrite(here,out,fs,'BitsPerSample',32);
        count = count +1;
        disp(count);
    end
end  
