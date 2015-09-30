function decrypt

    format long
    clear all
    A=imread('lena.png');  %........load image in A
    [I,map] = imread('lena.png','png');
    imshow(I,map);
    A=double(A);
    C = A;
    orig_A=size(A);%................row no
    orig_B=length(A);%..............column no
    a2=orig_A/2;
    b1=orig_B/2;
    b2=orig_B;
    result =cell(1,256);
    count=1;
    gencount=1;
    a1=1;
    
    for i=a1:a1
        %i=1;
        result=hybrid(C,i,a1,a2,b1+1,b2,count,gencount,result);
        %disp(a2,b1,b2);
        count=count+1;
        result=hybrid(C,i,a1,a2,1,b1,count,gencount,result);
        %disp(a2,b1,b2);
        count=count+1;
        result=hybrid(C,i,(a2+1),orig_A,1,b1,count,gencount,result);
        %disp(a2,b1,b2);
        count=count+1;
        result=hybrid(C,i,(a2+1),orig_A,b1+1,b2,count,gencount,result);
        count=count+1;
        gencount=gencount+1;
        disp('Gencount=');
        disp(gencount);
        temp=result{gencount-1};
        disp(size(temp));
    end
    disp('hello Gencount=');
    disp(gencount);
    imwrite(temp,'lena1.png');
    [I,map]=imread('lena1.png','png');
    imshow(I,map);
    %////.........DECRYPTION_PART...........//////////
    B_r=temp(1:a2,1:b1);
    %disp(B_r);
    B=(dec2bin(B_r,8));
    B_r=B_r-48;
    c=39;
    u=0;

    %%CALCILATING U.k
    for i=1:5   
        for j=1:8
           u=u+B_r(i,j)*(2^c);
           c=c-1;
        end
    end
    u=u/(2^40);
    %disp(u);
    k=1;
    %//////Now_Decrypting _Each _Pixel........//////
    
    orig=b2;
   
    %b2=b2-4;
    for i=a1:a2
        if i==k
            b2=b2-4;
        end
        for j=b2:-1:b1
            nu=abs(3.999*u*(1-u));
            disp(nu);
            disp(temp(i,j));
            %disp(value);
            valuee=bitxor(round(nu/255),temp(i,j));
            temp(i,j)=valuee;
            disp('valuee=: ');
            disp(valuee);
            u=nu;
        end
         b2=orig;
    end
    imwrite(temp,'lena.png');
    [I,map]=imread('lena1.png','png');
    imshow(I,map);
    
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
    %disp(u);

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
   
    second =A(a1:a2,b1:orig); %JUST  INITIALISATION 

third =A(a1:a2,b1:orig);%JUST  INITIALISATION 

first =A(a1:a2,b1:orig);%JUST  INITIALISATION 

if mod(count,4)==1
    first =A(a1:a2,b1:orig);
elseif mod(count,4)==2
    second =A(a1:a2,b1:orig);
elseif mod(count,4)==3
    third =A(a1:a2,b1:orig);
elseif mod(count,4)==0
    fourth=A(a1:a2,b1:orig);
    first=cat(2,second,first);
    second=cat(2,third,fourth);
    fourth=cat(1,first,second);
    %disp('Hi');
    %disp(size(fourth));
    result{gencount}=fourth;
    
    %disp(size(result{gencount}));
    %disp(result{gencount});
    gencount=gencount+1;
end

R=result;
end
