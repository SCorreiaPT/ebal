function [Population] = acousticInitRefactored(params)

LW_X = params.bounds(1,1);          % bounds
LW_Y = params.bounds(2,1);
HI_X = params.bounds(1,2);
HI_Y = params.bounds(2,2);

S = params.sensors';                % sensors

N = length(S);
D = nan(N, 1);
for i=1:N
    D(i) = sqrt(params.g*params.P/params.energies(i)); % estimated distances
end

w=1;
c=1;

nr = (N/3);
q=0:N/3:N-N/3;
        
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
    
    w=1;       
    ClanCenter(c,:) = (P(w,:) + P(w+1,:) + P(w+2,:))/3;
    if ClanCenter(c,1)>HI_X; ClanCenter(c,1)=HI_X; end
    if ClanCenter(c,1)<LW_X; ClanCenter(c,1)=LW_X; end
    if ClanCenter(c,2)>HI_Y; ClanCenter(c,2)=HI_Y; end
    if ClanCenter(c,2)<LW_Y; ClanCenter(c,2)=LW_Y; end
    
    c=c+1;
end
Cx = sum(ClanCenter(:,1))/(c-1);
Cy = sum(ClanCenter(:,2))/(c-1);
ClanCenter(c,1) = Cx;
ClanCenter(c,2) = Cy;

RClan = nan(c, 1);
if N > 3
    for i =1:c-1
        RClan(i) = norm(ClanCenter(i,:)-ClanCenter(c,:));
    end
else
    for i = 1:3
        RClan(i) = norm(P(i,:)-ClanCenter(c,:)) * 2;
    end
end
RClan(c,:) = max(RClan);

popindex = 1;
Population = nan(params.nPopulation, 2);
nElephantInEachClan = params.nPopulation/params.nClans;
for i=1:c
    
    for j=1:nElephantInEachClan
        ClanAgents(j,:) = RandCircle(ClanCenter(i,1),ClanCenter(i,2),RClan(i));
    end    
    ClanAgents = CleanClan(ClanAgents,LW_X, LW_Y, HI_X, HI_Y);
    
    for h=1:nElephantInEachClan
        Population(popindex,:) = ClanAgents(h,:);
        popindex = popindex+1;
    end    
end

end
