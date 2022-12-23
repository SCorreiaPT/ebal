function [Pb] = InterAvgPoint(S1,S2,R1,R2)

%Ponto do eixo radial
d = pdist([S1(1) S1(2) ; S2(1) S2(2)],'euclidean');
a = ((R1^2-R2^2+d^2)/(2*d));
Px = S1 + (S2-S1)*a/d;

%Ponto do Segmento de Reta
h = sqrt((R1^2-a^2));
Xb1 = Px(1)-h*(S2(2)-S1(2))/d;
Yb1 = Px(2)+h*(S2(1)-S1(1))/d;


Xb2 = Px(1)+h*(S2(2)-S1(2))/d;
Yb2 = Px(2)-h*(S2(1)-S1(1))/d;

P1 = [Xb1 Yb1];
P2 = [Xb2 Yb2];
Pb = mean([P1; P2]);

end