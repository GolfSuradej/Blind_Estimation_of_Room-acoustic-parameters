function D50 = RIR_2_D50(h,fs)
  num = 0;
  
  for j=1:round(0.05*fs)
     num = num+h(j)^2;
  end
  
  den = sum(h.^2);
      
  D50 = (num/den)*100;       
end
