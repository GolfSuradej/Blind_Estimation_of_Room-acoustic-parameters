function D50 = RIR_2_D50(h,fs)%,T0)
%   if nargin<3, T0=0;end
%  h=h./max(h);
%      inx = find(h>0.2,1,'first');
%                 inx =   inx+10;
               % inx_80ms = inx+(0.08*fs);

                num = 0;
                for j=1:round(0.05*fs)
                  %num = num+abs(h(j))^2;
                     num = num+h(j)^2;
                end
                  den = sum(h.^2);
                  %den = sum(abs(h).^2);
   % compensateEnergy = T0*fs;
 %   num = num+compensateEnergy; %compensate for the extended RIR             
                 D50 = (num/den)*100;       
end