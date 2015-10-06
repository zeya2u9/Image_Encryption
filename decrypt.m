function decryptt

    format long
    clear all
    A=imread('lena.png');  %........load image in A
    [I,map] = imread('lena.png','png');
    imshow(I,map);
    %disp(A);
    max_element=max(max(A));
    disp('MAX_ELEMENT');
    disp(max_element);
    A=double(A);
    C = A;
    tempii=A(1,506);
    
    orig_A=size(A);%................row no
    orig_B=length(A);%..............column no
    a2=orig_A/2;
    b1=orig_B/2;
    b2=orig_B;
    result =cell(1,256);
    count=1;
    gencount=1;
    a1=1;
    max_element=max(max(A));
    disp('MAX_ELEMENT');
    disp(max_element);
    
    i=1;
    k=i;
    result=hybrid(C,i,a1,a2,b1+1,b2,count,gencount,result);
    %disp(a2,b1,b2);
    image(result{1});
    pause(2);
    
    temp=result{1};
    image(temp);
     %fprintf('In hybrid a1=%ld a2=%ld\n',a1,a2);
    %///////.......for decryption
     B=A(k,b2-4:b2);
    B=(dec2bin(B,8));
    B=B-48;
    c=39;
    u=0;

    %%CALCILATING U.k
    for i=1:5   
        for j=1:8
           u=u+B(i,j)*(2^c);
           c=c-1;
        end
    end
    u=u/(2^40);
    fprintf('\nIn decryption u=%ld\n',u);
    
    fprintf('\nWhile decr b1=%ld b2=%ld\n',b1,b2);
    %DECRYPTING EACH PIXEL
    orig=512;
    %b2=b2-4;
    b1=b1+1;
    a1=1;
    a2=256;
    for i=a1:a2
        if i==1
            b2=b2-4;
        end
        for j=b2:-1:b1
            nu=3.999*u*(1-u);
            value=bitxor(round(nu*255),temp(i,j));
            temp(i,j)=value;
            u=nu;
        end
         b2=orig;
    end
    image(temp);
    
    cc=0;
    sarah=0;
    for i=a1:a2
        for j=b2:-1:b1
            if temp(i,j)==A(i,j)
                cc=cc+1;
            else
                disp('paglao area');
                disp(i);
                disp(j);
                disp(A(i,j));
                disp(temp(i,j));
                sarah=1;
                break;
            end
        end
        if sarah==1
            break;
        end
    end
    disp('matching pixels=');
    disp(cc);
end

%FUNCTION FOR FIRST STAGE GENERATIONS
function result=hybrid(A,k,a1,a2,b1,b2,count,gencount,result)

    flag=0;
    %gencount=1;     
    %result =cell(1,256);
    B=A(k,b2-4:b2);
    B=(dec2bin(B,8));
    B=B-48; 
    c=39;
    u=0;

    %%CALCILATING U.k
    for i=1:5   
        for j=1:8
           u=u+B(i,j)*(2^c);
           c=c-1;
        end
    end
    u=u/(2^40);
    disp('u in originalllllllllll===');
    disp(u);

    %ENCRYPTING EACH PIXEL
    orig=b2;
    %b2=b2-4;
    for i=a1:a2
        if i==k
            b2=b2-4;
        end
        for j=b2:-1:b1
            nu=3.999*u*(1-u);
            value=bitxor(round(nu*255),A(i,j));
            A(i,j)=value;
            u=nu;
        end
         b2=orig;
    end
    
    result{1}=A;
    image(A);
    R=result;
end
