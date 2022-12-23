function [Population] = acousticInitAnyN(params)

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

w = 0;
        
for i = 1:N
    for j = i+1:N
        
        w = w + 1;
      
        p = pdist([S(i,:); S(j,:)], 'euclidean');
        if D(i) < D(j) 
            Rm = D(i);
            RM = D(j);
        else
            Rm = D(j);
            RM = D(i); 
        end
        if D(i)+D(j) > p && p+Rm > RM
          P(w,:) = InterAvgPoint(S(i,:), S(j,:), D(i), D(j));
        else
          P(w,:) = Inter_0(S(i,:), S(j,:), D(i), D(j));
        end

        if imag(P(w,:)) ~= 0
           disp('ERRO');
        end
    end
end
ClanCenter = mean(P);
if ClanCenter(1) > HI_X; ClanCenter(1) = HI_X; end
if ClanCenter(1) < LW_X; ClanCenter(1) = LW_X; end
if ClanCenter(2) > HI_Y; ClanCenter(2) = HI_Y; end
if ClanCenter(2) < LW_Y; ClanCenter(2) = LW_Y; end

RClan = 0;
for i = 1:w
    RClan = max(RClan, norm(P(i,:) - ClanCenter));
end

for i = 1:params.nPopulation
    Population(i,:) = RandCircle(ClanCenter(1), ClanCenter(2), RClan);
end
Population = CleanClan(Population, LW_X, LW_Y, HI_X, HI_Y);

end