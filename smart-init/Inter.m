function [Pb] = Inter(S1,S2,R1,R2,S3,R3)

%Ponto do eixo radial
d = pdist([S1(1) S1(2) ; S2(1) S2(2)],'euclidean');
a = ((R1^2-R2^2+d^2)/(2*d));
Px = S1 + (S2-S1)*a/d;
%plot(Px(1),Px(2),'g*')
%Ponto do Segmento de Reta
h = sqrt((R1^2-a^2));
Xb1 = Px(1)-h*(S2(2)-S1(2))/d;
Yb1 = Px(2)+h*(S2(1)-S1(1))/d;
%plot(Xb1,Yb1,'yo')


Xb2 = Px(1)+h*(S2(2)-S1(2))/d;
Yb2 = Px(2)-h*(S2(1)-S1(1))/d;
%plot(Xb2,Yb2,'bo') 

%Pmin = min(norm(S3-[Xb2 Yb2]),norm(S3-[Xb1 Yb1]));

%if (Pmin>R3)%||((norm(S3-[Xb1 Yb1])>R3))
%    Pb = [Xb1 Yb1];
%else
%    Pb = [Xb2 Yb2];
%end



if norm(S3-[Xb1 Yb1]) > norm(S3-[Xb2 Yb2])
    P_Maior = [Xb1 Yb1];
    P_Pequeno = [Xb2 Yb2];
else
    P_Maior = [Xb2 Yb2];
    P_Pequeno = [Xb1 Yb1];
end
Pb = P_Pequeno;

%Verifica Ponto
%if (R3<norm(S3-[Px(1) Px(2)]))
%    Pb = P_Pequeno;
%else
%    Pb = P_Maior;
%end

%Resultado

end