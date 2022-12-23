function [Pc] = Inter_0(S1,S2,R1,R2)

if R1<R2 Rm = R1; RM=R2; Sm=S1; SM=S2; else Rm=R2; RM=R1; Sm=S2; SM=S1; end
d = pdist([S1(1) S1(2) ; S2(1) S2(2)],'euclidean');

if d>RM     %Circunferencias Externas

    a= acos(abs(S2(1)-S1(1))/d);

    if S2(1)>S1(1)      % Circunferencia à direita
        Pa(1) = S1(1)+cos(a)*R1;
        Pb(1) = S2(1)-cos(a)*R2;
    else
        Pa(1) = S1(1)-cos(a)*R1;
        Pb(1) = S2(1)+cos(a)*R2;
    end

    if S2(2)>S1(2)
        Pa(2) = S1(2)+sin(a)*R1;
        Pb(2) = S2(2)-sin(a)*R2;
    else
        Pa(2) = S1(2)-sin(a)*R1;
        Pb(2) = S2(2)+sin(a)*R2;
    end

else    %Circunferencias Internas
    
    a= acos(abs(S2(1)-S1(1))/norm(S1-S2));
    
    if Sm(1)>SM(1)  % Interna a direita do centro (Calcula abscissas)
       Pa(1)= SM(1) + (d+Rm)*cos(a);
       Pb(1)= SM(1) + (RM)*cos(a);
    else
       Pa(1)= SM(1) - (d+Rm)*cos(a);
       Pb(1)= SM(1) - (RM)*cos(a);
    end
    
    if Sm(2)>SM(2)  % Interna acima do centro (Calcula Ordenadas)
       Pa(2)=SM(2) + (d+Rm)*sin(a);
       Pb(2)=SM(2) + (RM)*sin(a);
    else
       Pa(2)=SM(2) - (d+Rm)*sin(a);
       Pb(2)=SM(2) - (RM)*sin(a);
    end
       
end
    
    %Resultado
    Pc = (Pa + Pb)/2;

end