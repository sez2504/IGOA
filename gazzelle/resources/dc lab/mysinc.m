function y = mysinc(x)
    y = sin(pi*x)./(pi*x);
    y(x==0) = 1; % Handle the case where x is zero to avoid division by zero
end
