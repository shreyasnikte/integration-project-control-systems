function sys = makeSystem(y,u,h,n)

data = iddata(y,u(1:length(y)),h);
sys = n4sid(data,n);

end
