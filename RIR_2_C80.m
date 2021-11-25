% Suradej 
% March 06, 2021

function C80 = RIR_2_C80(h,fs) 
    num = 0;
    den = 0;
    
    h=h./max(h);
    inx = find(h>0.2,1,'first');
    inx_80ms = (inx+round((0.08*fs)));

    for i=1:inx_80ms 
        num = num + h(i)^2;
    end
   
    for k=inx_80ms:length(h)
        den  = den + h(k)^2;
    end
        
    C80 = 10*log10(num/den);  
end
