% TD Reconnaissance de Formes - Exercice 1
close all
clear all
%% Question préliminaire :
% La variance est égale à 1.
% Compléter les informations manquantes (notées ...)
Max_x = 4;
Min_x = -4;
Pas = 0.01;
x= [Min_x:Pas:Max_x];
L = length(x);

% Considèrons que 2 classes sont modélisées par les densités de
% probabilité gaussiennes suivantes :
pxw1 = exp(-(x.*x))./sqrt(pi);
mu2 = 1;
sigma2 = sqrt(0.5); % ecart-type
pxw2 = exp(-(x-mu2).*(x-mu2)/(2*sigma2^2))./sqrt(2*pi*sigma2^2);

%% 1. 1er cas:  Pw1=Pw2=0,5
Pw1 = 0.5;
Pw2 = 1 - Pw1;

% 1.a. Tracés des densités de probabilités des 2 classes
figure(1)
hold on
plot(x,pxw1,'color','red')
plot(x,pxw2,'color','blue')
title('Densités de probabilités des classes (1:rouge, 2:bleue) et les fonction discriminante (1:noire, 2:vert)')

% 1.b. Ajouter sur le même graphique les probabilités a posteriori
px = pxw1*Pw1 + pxw2*Pw2;
g1 = pxw1*Pw1./px;
g2 = pxw2*Pw2./px;
plot(x,g1,'color','black')
plot(x,g2,'color','green')
plot(x,px,'color','magenta')
% 1.c. En déduire le seuil de classification optimale.
% Seuil sera tel que g1(seuil) = ln(fxw1(seuil|w1)P(w1))=g2(seuil)
% Graphiquement on voit donc :
% Seuil1 = 0.5
% Seuil0.5 = 0.25
% Seuil2 = 1
% SeuilSig0.25 = 
% 1.d. Calculer la probabilité d'erreur de classification obtenue (diapo 43):
xb = 0.5;
indices = find (x<=xb);
M = length(indices);
Perreur = Pas * sum(pxw2(indices)*Pw2);
Perreur = Perreur + Pas*sum(pxw1(indices(M)+1:L)*Pw1)
%Pe1 = 0.2398
%Pe0.5 = 0.3702
%Pe2 = 0.1274
%PeSig0.25 = 0.1307
%% 2. Modification des valeurs de probabilité à priori
Pw1 = 9/10;
Pw2 = 1/10;

%  Tracés des densités de probabilités des 2 classes
figure(2) 
hold on
plot(x,pxw1,'color','red')
plot(x,pxw2,'color','blue')
title('Densités de probabilités des classes (1:rouge, 2:jaune)')

%  Ajouter sur le même graphique les probabilités à posteriori
px = pxw1*Pw1 + pxw2*Pw2;
g1 = pxw1*Pw1./px;
g2 = pxw2*Pw2./px;
plot(x,g1,'color','black')
plot(x,g2,'color','green')
    
% Que devient le seuil optimal ? Pourquoi ?
xb = 1.6;
indices = find (x<=xb);
M = length(indices);
Perreur = Pas * sum(pxw2(indices)*Pw2);
Perreur = Perreur + Pas*sum(pxw1(indices(M)+1:L)*Pw1)
    
% Prise en compte du numérateur uniquement
...

% Observations / commentaires : 
...

