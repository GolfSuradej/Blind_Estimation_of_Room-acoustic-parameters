% Suradej 
% March 06, 2021
function C80 = RIR_2_C80(h,fs) %,Th,T0)
%if nargin<3, Th=0;T0=0;end;
    num = 0;
    den = 0;
%     A = zeros(round(T0*fs),1);   
%     t = 0:1/fs:T0;
    
        h=h./max(h);
        inx = find(h>0.2,1,'first');
        inx_80ms = (inx+round((0.08*fs)));

        for i=1:inx_80ms 
           num = num + h(i)^2;
        end
       %disp('Early energy of 80ms'); disp(num);
   
        for k=inx_80ms:length(h)
            den  = den + h(k)^2;
        end
        
%     if nargin>2
%         A = exp(6.9.*(t/Th));
%         energyA = sum(A);
%         num = num + (0.5*1.0*T0);
%         
%         disp('compensate Energy of the RIR model');
%     end
%         
%     c80 = (num/den); 
%     disp(c80);
    C80 = 10*log10(num/den);  
end
%     areaAfterT0 = 0;
%     
%     if (inx_80ms>round(T0*fs))
%         for k=inx : inx_80ms  % k = round(T0*fs):inx_80ms % 
%              areaAfterT0  = areaAfterT0  + h(k)^2;
%         end  
%     else
%         areaAfterT0 =0;
%     end
%     disp('areaAfterT0'); disp(areaAfterT0);
   
%     A = zeros(round(T0*fs),1);   
%    for i=1:round(T0*fs)
%        A(i) = exp(6.9*(i/Th));
%        if A(i)>1,A(i)=1;end      
%    end
%    disp(length(A));
%    energyBeforeT0 = sum(A);
 %  disp('energyBeforeT0'); disp(energyBeforeT0);
   
%    compensateEnergy = 0;%T0*
%    for i = 1:round(T0*fs)
%      compensateEnergy =  compensateEnergy + h(i)^2;
%      
%    end%- energyBeforeT0 ;
%    compensateEnergy = compensateEnergy;
%    disp('compensateEnergy'); disp(compensateEnergy);     
%     

    
     
   %num = energyBeforeT0+areaAfterT0+compensateEnergy; %compensate for the extended RIR
  % num = areaAfterT0+compensateEnergy; 
   %num = num;% + 0.0051;
  %         disp('Late energy after 80ms');
%         disp(den)
   
    % disp(C80);
   % 
    
%end