function original_correlation_plot
    A=imread('lena.png');  %........load image in A
    [I,map]=imread('lena.png','png');
    imshow(I,map);
    image(A);
    A=double(A);
    X=A(1:512,1:511);
    Y=A(1:512,2:512);
    r=corr2(X,Y);
    disp(r);
    figure;
    plot(X,Y,'.r');  
end 
