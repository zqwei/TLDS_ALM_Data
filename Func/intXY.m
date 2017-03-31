function areaInt       = intXY(vec_x, vec_y)    
    areaInt            = sum((vec_y(1:end-1)+vec_y(2:end)).*(vec_x(2:end)-vec_x(1:end-1))/2);    
end