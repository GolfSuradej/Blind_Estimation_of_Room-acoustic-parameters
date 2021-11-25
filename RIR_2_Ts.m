function Ts = RIR_2_Ts(h,fs)
    h=h./max(h);

    inx = find(h>0.2,1,'first');
    H = zeros(length(h)-inx,1);
    
    H = h(inx:end);
    
    t = 0:1/fs:(length(H)-1)/fs;
    
    t = t';
    
    num = 0;
    den = 0;
    
    for i=inx:length(H)
        num = num + (H(i)^2)*t(i);
        
    end
    
    den = sum(H.^2);

    Ts = (num/den);

end
