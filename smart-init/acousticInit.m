function [Population] = acousticInit(params)

%global MinParValue MaxParValue 

PLOT = 0;

LW_X = params.bounds(1,1);          % bounds
LW_Y = params.bounds(2,1);
HI_X = params.bounds(1,2);
HI_Y = params.bounds(2,2);

% Int = buildInt(OPTIONS.numVar, LW_X, LW_Y, HI_X, HI_Y); % bounds
% 
% MinParValue = Int(:,1)';
% MaxParValue = Int(:,2)';

S = params.sensors';           % sensors
  
if PLOT == 1
figure
hold on
rectangle('Position',[LW_X,LW_Y,(HI_X-LW_X),(HI_Y-LW_Y)]);   
plot(S(:,1),S(:,2),'rs','MarkerFaceColor','r');
plot(Param.Layout.X(1),Param.Layout.X(2),'r+','MarkerSize',15);
end


L = length(S);              % sensors
for i=1:L
    % TODO ---------------------------------------------->
    D(i) = sqrt(params.g*params.P/params.energies(i));           %g, P, energies. energies têm de ser alteradas para virem só a do teste
end

w=1;
c=1;

nr = (L/3);
q=0:L/3:L-L/3;
        
for k=1:nr
      
    p = pdist([S(k+q(1),1) S(k+q(1),2) ; S(k+q(2),1) S(k+q(2),2)],'euclidean');
    if D(k)<D(k+q(2)) Rm=D(k+q(1));RM=D(k+q(2)); else Rm=D(k+q(2));RM=D(k+q(1)); end
    if (D(k)+D(k+q(2))>p)&&(p+Rm>RM)
      Px=Inter(S(k+q(1),:),S(k+q(2),:),D(k+q(1)),D(k+q(2)),S(k+q(3),:),D(k+q(3))); 
      P(w,:) = Px;
      w=w+1;
    else
      Px=Inter_0(S(k+q(1),:),S(k+q(2),:),D(k+q(1)),D(k+q(2)));
      P(w,:) = Px;
      w=w+1;
    end

    if imag(Px)~=0
       disp('ERRO');
    end


    p = pdist([S(k+q(1),1) S(k+q(1),2) ; S(k+q(3),1) S(k+q(3),2)],'euclidean');
    if D(k+q(1))<D(k+q(3)) Rm=D(k+q(1));RM=D(k+q(3)); else Rm=D(k+q(3));RM=D(k+q(1)); end
    if (D(k+q(1))+D(k+q(3))>p)&&(p+Rm>RM)
      Px=Inter(S(k+q(1),:),S(k+q(3),:),D(k+q(1)),D(k+q(3)),S(k+q(2),:),D(k+q(2))); 
      P(w,:) = Px;
      w=w+1;
    else
      Px=Inter_0(S(k+q(1),:),S(k+q(3),:),D(k+q(1)),D(k+q(3)));
      P(w,:) = Px;
      w=w+1;
    end

    if imag(Px)~=0
        disp('ERRO');
    end

    p=pdist([S(k+q(2),1) S(k+q(2),2) ; S(k+q(3),1) S(k+q(3),2)],'euclidean');
    if D(k+q(2))<D(k+q(3)) Rm=D(k+q(2));RM=D(k+q(3)); else Rm=D(k+q(3));RM=D(k+q(2)); end
    if (D(k+q(2))+D(k+q(3))>p)&&(p+Rm>RM)
        Px=Inter(S(k+q(2),:),S(k+q(3),:),D(k+q(2)),D(k+q(3)),S(k+q(1),:),D(k+q(1))); 
        P(w,:) = Px;
        w=w+1;
    else
        Px=Inter_0(S(k+q(2),:),S(k+q(3),:),D(k+q(2)),D(k+q(3)));
        P(w,:) = Px;
        w=w+1;
    end

    if imag(Px)~=0
        disp('ERRO');
    end
    if PLOT ==1       
        Circle(S(k+q(1),1),S(k+q(1),2),D(k+q(1)))
        Circle(S(k+q(2),1),S(k+q(2),2),D(k+q(2)))
        Circle(S(k+q(3),1),S(k+q(3),2),D(k+q(3)))
        plot(P(:,1),P(:,2),'go');
    end
    w=1;       
    ClanCenter(c,:) = (P(w,:) + P(w+1,:) + P(w+2,:))/3;
    if ClanCenter(c,1)>HI_X; ClanCenter(c,1)=HI_X; end
    if ClanCenter(c,1)<LW_X; ClanCenter(c,1)=LW_X; end
    if ClanCenter(c,2)>HI_Y; ClanCenter(c,2)=HI_Y; end
    if ClanCenter(c,2)<LW_Y; ClanCenter(c,2)=LW_Y; end
    if PLOT ==1
    plot(ClanCenter(c,1),ClanCenter(c,2),'r*');  %***ERRO***%
    end
    c=c+1;
end
Cx = sum(ClanCenter(:,1))/(c-1);
Cy = sum(ClanCenter(:,2))/(c-1);
ClanCenter(c,1) = Cx;
ClanCenter(c,2) = Cy;
if PLOT ==1
    plot(Cx,Cy,'ro');
    xlim([0 100])
    ylim([0 100])
    grid
end
if L > 3
    for i =1:c-1
        RClan(i) = norm(ClanCenter(i,:)-ClanCenter(c,:));
    end
else
    for i = 1:3
        RClan(i) = norm(P(i,:)-ClanCenter(c,:)) * 2;
    end
end
if PLOT ==1
    CircleC(Cx,Cy,max(RClan),'r');                                  %***ERRO***%
end
popindex = 1;
Population = nan(params.nPopulation, 2);
for i=1:length(ClanCenter)-1
    if PLOT==1
        CircleC(ClanCenter(i,1),ClanCenter(i,2),RClan(i),'g');       %***ERRO***%
    end
    for j=1:params.nPopulation/params.nClans
        Clan(j,:)=RandCircle(ClanCenter(i,1),ClanCenter(i,2),RClan(i));
    end    
    Clan = CleanClan(Clan,LW_X, LW_Y, HI_X, HI_Y);
    if PLOT ==1
        plot(Clan(:,1),Clan(:,2),'g.');     %***ERRO***%
    end
    
    numElephantInEachClan = params.nPopulation/params.nClans;
    
    for h=1:numElephantInEachClan
        chrom = Clan(h,:);  %Preenche o vetor de populacao
        Population(popindex,:) = chrom;
        popindex = popindex+1;
    end    
end

% Cria um clan no centro dos restantes e raio maximo
%CircleC(ClanCenter(i+1,1),ClanCenter(i+1,2),max(RClan),'g');    %***ERRO***%
for j=1:params.nPopulation/params.nClans
    Clan(j,:)=RandCircle(ClanCenter(i+1,1),ClanCenter(i+1,2),max(RClan));
end
Clan = CleanClan(Clan,LW_X, LW_Y, HI_X, HI_Y);
if PLOT==1
    plot(Clan(:,1),Clan(:,2),'g.');      %***ERRO***%
end
for h=1:numElephantInEachClan
    chrom = Clan(h,:);  %Preenche o vetor de populacao
    Population(popindex,:) = chrom;
    popindex = popindex+1;
end    

% Initialize population
% for popindex = 1 : OPTIONS.popsize
%     chrom = Int(:,1)' + (Int(:,2)' - Int(:,1)' + 1) .* rand(1,OPTIONS.numVar);
%     Population(popindex).chrom = chrom;
% end
end
