%   Author:  Suradej Duangpummet
%   Created: 20 Nov. 2020
%   Updated: 15 Dec. 2020
%   Copyright (c) Unoki-Lab. JAIST
%
%   Function: calculate reverberation time using energy decay curve
%             and curve fitting (polyfit)

function RT = RIR_2_T60(h,fs)

        x = cumtrapz(h(end:-1:1).^2);% integral energy of the RIR
 
        %if row vector
        if(isrow(x))
            x = x;
        %otherwise, collume vector
        else
            x= x';
        end

        x = fliplr(x);  % backward integral
%         figure(2)
%         plot(x)
        EDC = 10*log10(x);
        %offset to zero decible
        EDC = EDC-max(EDC);

        t = 0:1/fs:(length(EDC)-1)/fs;
        t = t';
%         figure(2)
%         plot(t,EDC)
        xlim([0,2]);
        ylim([-75,-10]);
        %find the x-axis 30 (or 60) dB decay
        %plot(t,EDC)
        xT1 = find(EDC<= 0,1,'first');
        if isempty(xT1)
            xT1 = max(EDC);
          %  disp('cannot find 0 db point');
            xT1 = 1;
        end
        

        xT2 = find(EDC<= -20,1,'first');        %find -20 dB intersection point
        if isempty(xT2)                         % Since at the low T60(0.2 s), the energy is too low.
            xT2 = min(EDC);
         %   disp('cannot find 30 db point!');
        end
        

        IX = xT1:xT2;

        x = reshape(IX,1,length(IX));
        y = reshape(EDC(IX),1,length(IX));
        p = polyfit(x,y,1);
        fittingLine = polyval(p,1:length(x));
        fittingLine = fittingLine-max(fittingLine);
%          figure(3)
%          plot(t(1:length(fittingLine)),fittingLine)
       RT =  3.3*(find(fittingLine <=-18,1,'first'))/fs;
       if(isempty(RT))
      %  disp('cannot find 30 db point!');
        RT = 0;
       end
% --------- debug ---------
%         figure(2)
%         plot(t,EDC)
%         disp(xT1);
%         disp(xT2);
%         figure(3)
%         plot(fittingLine)
    %-----------------------
end