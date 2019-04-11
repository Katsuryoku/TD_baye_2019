% TD Reconnaissance de Formes - Exercice 1
close all
clear all
%% Question pr�liminaire :
% La variance est �gale � 1.
% Compl�ter les informations manquantes (not�es ...)
Max_x = 4;
Min_x = -4;
Pas = 0.01;
x= [Min_x:Pas:Max_x];
L = length(x);

% Consid�rons que 2 classes sont mod�lis�es par les densit�s de
% probabilit� gaussiennes suivantes :
pxw1 = exp(-(x.*x))./sqrt(pi);
mu2 = 1;
sigma2 = sqrt(0.5); % ecart-type
pxw2 = exp(-(x-mu2).*(x-mu2)/(2*sigma2^2))./sqrt(2*pi*sigma2^2);

%% 1. 1er cas:  Pw1=Pw2=0,5
Pw1 = 0.5;
Pw2 = 1 - Pw1;

% 1.a. Trac�s des densit�s de probabilit�s des 2 classes
figure(1)
hold on
plot(x,pxw1,'color','red','DisplayName', 'classe 1')
plot(x,pxw2,'color','blue','DisplayName', 'classe 2')
title('Densit�s de probabilit�s des classes')
legend('show')
hold off
%%
% 1.b. Ajouter sur le m�me graphique les probabilit�s a posteriori
px = pxw1*Pw1 + pxw2*Pw2;
Pw1x = pxw1*Pw1./px;
Pw2x = pxw2*Pw2./px;
plot(x,Pw1x,'color','black')
plot(x,Pw2x,'color','green')
plot(x,px,'color','magenta')
% 1.c. En d�duire le seuil de classification optimale.
% Seuil sera tel que g1(seuil) = ln(fxw1(seuil|w1)P(w1))=g2(seuil) diapo : 85/86
% g1(seuil) = ln(p(seuil|w1))+ ln(P(w1)) = -1/2 * (x-u1)^t * SUM (-1,1) (x
% - u1) - 1/2 * ln(SUM
% Graphiquement on voit donc :
% Seuil1 = 0.5
% Seuil0.5 = 0.25
% Seuil2 = 1
% SeuilSig0.25 = 
% 1.d. Calculer la probabilit� d'erreur de classification obtenue (diapo 43):
xb = 0.5;
indices = find (x<=xb);
M = length(indices);
Perreur = Pas * sum(pxw2(indices)*Pw2);
Perreur = Perreur + Pas*sum(pxw1(indices(M)+1:L)*Pw1)
%Pe1 = 0.2398
%Pe0.5 = 0.3702
%Pe2 = 0.1274
%PeSig0.25 = 0.1307
%% 2. Modification des valeurs de probabilit� � priori
Pw1 = 9/10;
Pw2 = 1/10;

%  Trac�s des densit�s de probabilit�s des 2 classes
figure(2) 
hold on
plot(x,pxw1,'color','red')
plot(x,pxw2,'color','blue')
title('Densit�s de probabilit�s des classes (1:rouge, 2:jaune)')

%  Ajouter sur le m�me graphique les probabilit�s � posteriori
px = pxw1*Pw1 + pxw2*Pw2;
Pw1x = pxw1*Pw1./px;
Pw2x = pxw2*Pw2./px;
plot(x,Pw1x,'color','black')
plot(x,Pw2x,'color','green')
    
% Que devient le seuil optimal ? Pourquoi ?
xb = 1.6;
indices = find (x<=xb);
M = length(indices);
Perreur = Pas * sum(pxw2(indices)*Pw2);
Perreur = Perreur + Pas*sum(pxw1(indices(M)+1:L)*Pw1)
    
% Prise en compte du num�rateur uniquement
...

% Observations / commentaires : 
...

