function D=ReOpt( D, An, an, an_, h_l)
%% ������� ������ ��������� �����������
%% �� �����
% D - ��� �������
% D(i,:)=[n n1 i1 n0 i0 a0 a1 a2 a3 f0_N]
% n - ����� �����
% n1, n0 - ������ ������ �������� � ������� ������ (������� ���������� �1, �2, �4, ... ���������� ��� -1 -2 -4...)
% i1, i0 - ����������� ������. 1 - ��������. 0 - ������
% ��� ���� nk ik - ��������� ��� ���������: 0 1 - '0' � 0 0 - '1'
% a0 a1 a2 a3 - ���������� ���������� ������� ������������� �����
% f0_N - �������� �����������������
% An - ��������������� ����(������ �� D)
% an - ������������������ ������ � ������� ������
% an_ - ����� ������������������ ������
% h_l - ������� �������� (1 - �������, 0 - �������)
%% �� ������
% D �� ����������� (��������� = '-1')
%%
h=size(D,2); % ������ �������

%% ��� ��� ������� ����� "an_(an==An(1))>0"
 if an_(an==An(1))>0 % ����� �� �������� ���� ����� �� 1 ������

    if h_l==1  % ������� ���� ����������
        Fi=D(D(:,1)==An(2),:);  %Fi - ������� ����
        if An(3)==0
            Fi=Inve(Fi); % ��� ��������,���� i1 = 0
        end
        NFi=D(D(:,1)==An(4),:);  %NFi - ������� ����
        if An(5)==0
            NFi=Inve(NFi); % ��� ��������,���� i0 = 0
        end
        
        %g=find(An(10:length(An))<0); 
        %if g
        %    NFi(g+9)=-1; % * = '-1'
        %end
        for i=10:length(An)% ������ �� * NFi ���, ��� An ��� * 
            if An(i)==-1
                NFi(i)=-1;
            end
        end
       
        
        for d=10:h % ������ �� * ��� NFi, ��� ������ Fi ������ �� �����
            if (Fi(d)==0) && An(6)==An(7) && NFi(d)~=-1 % ���� a0=a1 ��� Fi=0
                NFi(d)=-1;
            elseif (Fi(d)==1) && An(8)==An(9) && NFi(d)~=-1 % ���� a2=a3 ��� Fi=1
                NFi(d)=-1;  
            end
        end
        
    else  % ������ ���� ����������
        Fi=D(D(:,1)==An(4),:); %Fi - ������� ���� 
        if An(5)==0
            Fi=Inve(Fi); % ��� ��������,���� i0 = 0
        end
        NFi=D(D(:,1)==An(2),:);  %NFi - ������� ����
        if An(3)==0
            NFi=Inve(NFi); % ��� ��������,���� i1 = 0
        end
        %g=find(An(10:h)<0); % ������ �� * NFi ���, ��� An ��� * 
        %if g
        %    NFi(g)=-1; % * = '-1'
        %end
        for i=10:h% ������ �� * NFi ���, ��� An ��� * 
            if An(i)==-1
                NFi(i)=-1;
            end
        end
    
        for d=10:h % ������ �� * ��� NFi, ��� ������ Fi ������ �� �����
            if (Fi(d)==0) && An(6)==An(8) && NFi(d)~=-1 % ���� a0=a2 ��� Fi=0
                NFi(d)=-1;
            elseif (Fi(d)==1) && An(7)==An(9) && NFi(d)~=-1 % ���� a1=a3 ��� Fi=1
                NFi(d)=-1;  
            end
        end
    end
%% ����� ����������� NFi ��������� �� �� ���� ����� � DAn 
    i=find(D(:,1)==NFi(1));
    DAn=D;
    if(NFi(1,1)>=0)
        DAn(i,:)=NFi;
    end;
    

%% 
    j=find(DAn(i,10:h)~=-1); % ����� ��� �� * � NFi
    j=j+9;  

    if h_l==1 % hl - ��������� ������ ��������������� ����� � ������������������ �������� �����
    	hl=4;
    else
    	hl=2;
    end
    %% ����� �������, � ���� ������ ������ ���� �� ����
    if sum(NFi(j))==length(j) % ���� ��� ��������� 1
        g= DAn(:,hl)==DAn(i,1); % ����������� ������ � �������, ��� ����� ��� ��������������� ����
        DAn(g,hl)=0;
        DAn(g,hl+1)=0;
    elseif sum(NFi(j))==0 % ���� ��� ��������� 0
        g= DAn(:,hl)==DAn(i,1); % ����������� ������ � �������, ��� ����� ��� ��������������� ����
        DAn(g,hl)=0;
        DAn(g,hl+1)=0;
    else
        %% ��� ��� ����� ������ ����
        
    for m=1:length(an) % ����� � ����� ���������� ������������������ ��� ������
        if(D(m,j)==DAn(i,j))  % ��������� ������ ��������� �������� ������������������� (�� *)
            if m~=i
                k=m; % ����������� ����������
                if an_(an==DAn(k,1))<=an_(an==DAn(i,1)) % �������� ���������
                    g= DAn(:,hl)==DAn(i,1); % ����������� ������ � �������, ��� ����� ��� ��������������� ����
                    DAn(g,hl)=DAn(k,1); % ������ � ������� � ���������������� ����� ����� �� ����������
                    An(hl)=DAn(k,1);
                    break % �������������� ����� �����, �� ����� ������ ������ ������
                end
            end
        else
        % ���������� ��������� ��� ��������������� ������������������
        A=D(m,:);
        A=Inve(A);
        D(m,:)=A;
        if(D(m,j)==DAn(i,j)) 
            if m~=i
                k=m;
                if an_(an==DAn(k,1))<=an_(an==DAn(i,1))
                    g=find(DAn(:,hl)==DAn(i,1));
                    DAn(g,hl)=DAn(k,1);
                    An(hl)=DAn(k,1);
                    DAn(g,hl+1)=0;
                    An(hl+1)=0;                    
                    break
                end
            end
        end
        % ���������� �������
        A= D(m,:);
        A=Inve(A);
        D(m,:)=A;
        end
    end
        %% ���������� ������ ����
    
    end; 
    %% ����� ������ �������
%% ����� ��������:
    i= D(:,1)==An(hl);
    An=DAn(i,:); %An �������� � ���� ���������
    D=DAn; % D ����
    D=ReOpt(D, An, an, an_, 1); %����������� ������� ����
    D=ReOpt(D, An, an, an_, 0); %����������� ������� ����
    
end

end

