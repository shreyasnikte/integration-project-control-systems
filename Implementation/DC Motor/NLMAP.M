function y=nlmap(in)


temp=atan(in)*8;

if temp>10  y=10;

elseif temp<-10 y=-10;
     
else y=temp;

end


