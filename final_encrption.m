function final_encryption

    format long
    clear all
    A=imread('lena.png');  %........load image in A
    [I,map]=imread('lena.png','png');
    imshow(I,map);
    image(A);
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
    %disp(a2,b1,b2);
    a1=1;
    cort=1;
    
    %\\\\\\\\\\\\\PRODUCING ALL GENERATIONS\\\\\\\\\\\\\\\\
    for i=a1:a2
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
    CR =cell(1,128*255);
    %a=b-4;
    %B=A(1,a:b); %take 5 pixels from matrix A
    %disp(count);==1024

    %\\\\\\\\|||||||||||||||CROSSOVER||||||||||||||||||\\\\\\
    i=1;
    j=0;
    a1=1;
    new_count=1;
    for i=a1:2:a2
         j=i+1;
            CR=crossover(i,j,orig_A,orig_B,new_count,result,CR);
            disp('new_count=');
            disp(new_count);
            new_count=new_count+2;
            disp('I,J');
            disp(i);
            disp(j);    
    end

    disp('Now selecting first 2500 pairs ');
    disp('First horizontally for all productions');
    %//correlation=ones(10000000,2);%...............................added line
    for i=1:gencount-1
        test_1=result{i};
        test_2=test_1(1:5,1:orig_B-1);
        test_1=test_1(1:5,2:orig_B);
        c=corr2(test_2,test_1);
        correlation(cort,1)=c;
        correlation(cort,2)=i;
        cort=cort+1;
    end
    for i=1:new_count-1
        test_1=CR{i};
        test_2=test_1(1:5,1:orig_B-1);
        test_1=test_1(1:5,2:orig_B);
        %disp('test_1');
       % disp(test_1);
        %disp('Correlation');
        disp(i);
        c=corr2(test_2,test_1);
        correlation(cort,1)=c;
        correlation(cort,2)=i+256;%..........................coz pehle wali gen k baad ye ayi 
        cort=cort+1;
        disp(c);
    end
    correlation=sortrows(correlation,1);%..................After every loop cort=cort/2;
    %//////////SELECTING MORE 10%
    cort=cort/2;
    cort=round(cort);
    num=round(0.1*cort);
    %disp(num);
    ten=correlation(cort+1:cort+1+num,1:2);
    disp('TESSSSSSSSSSSSSSSSSting');
    for i=1:10
        disp(ten(i,2));
    end
    %disp(ten);
    

    %.....................ITERATING 10 TIMES FOR BETTER RESULTS.......................
    for k=1:10
        a1=1;
        a2=cort+num;
        cort=1;
        new_count=1;
        for i=a1:2:a2
            CR=crossover(i,j,orig_A,orig_B,new_count,CR,CR);
            disp('new_count=');
            disp(new_count);
    
            new_count=new_count+2;
        end
        %CALCULATE CC
        ................................................
        ................................................
        ................................................
        for i=1:new_count-1
            test_1=CR{i};
            if i==new_count-1
                cipher=test_1;
                image(cipher);
                pause(2);
            end
            test_2=test_1(1:5,1:orig_B-1);
            test_1=test_1(1:5,2:orig_B);
            %disp('test_1');
            %disp(test_1);
            %disp('Correlation');
            disp(i);
            c=corr2(test_2,test_1);
            correlation(cort,1)=c;
            correlation(cort,2)=i+256;%..........................coz pehle wali gen k baad ye ayi 
            cort=cort+1;
        end
        correlation=sortrows(correlation,1);%..................After every loop cort=cort/2;
        %..........SELECTING MORE 10%
        cort=cort/2;
        cort=round(cort);
        num=round(0.1*cort);
        %displaying min cc in every iteration
        disp('Sarah');
        disp(correlation(1,2));
        image(cipher);
         pause(2);
        final=correlation(1,2);
    end
    r=correlation(1,1);
    X=cipher(1:512,1:511);
    Y=cipher(1:512,2:512);
    figure;
    plot(X,Y,'+r');
%A=final;
%image(A);
%imwrite(A,'lena.png');
% [I,map]=imread('lena.png','png');
%    imshow(I,map);

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
%disp(A);
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
    image(result{gencount});
    %pause(2);
    %disp(size(result{gencount}));
    %disp(result{gencount});
    gencount=gencount+1;
end


R=result;
end

%CROSSOVER FUNCTION
function CR=crossover(i,j,row,col,new_count,result,CR)
   
    matrix_1=result{i};
    matrix_2=result{j};
    %from matrix 2
    temp_1=matrix_2(1:row/2,1:col/2);
    temp_2=matrix_2(row/2+1:row,col/2+1:col);    
    %swapping b/w mat1 and mat2 \
    matrix_1(1:row/2,1:col/2)=temp_1;
    matrix_1(row/2+1:row,col/2+1:col)=temp_2;    
    %ADDING INTO CR
    CR{new_count}=matrix_1;
    new_count=new_count+1;
    
    matrix_1=result{i};
    matrix_2=result{j};
    
      %swapping b/w mat1 and mat2 /
    temp_1=matrix_2(1:row/2,col/2+1:col);
    matrix_1(1:row/2,col/2+1:col)=temp_1;
    temp_2=matrix_2(1:row/2,col/2+1:col);
    matrix_1(row/2+1:row,1:col/2)=temp_2;
    
    %ADDING INTO CR
    CR{new_count}=matrix_1;
    new_count=new_count+1;
    %disp('new_count=');
    %disp(new_count);
end
