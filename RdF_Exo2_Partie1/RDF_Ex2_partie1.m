%% Partie 1 
clear all;
close all;
%% 1.1 Approches : 
% Segmentation par couleur, On extrait des échantillons avec
% de la peau et on fait apprendre la couleur à notre algo.
%% Apprentissage d'un modèle de peau
database_dir='George_W_Bush';

fnames = dir(fullfile(database_dir, '*.jpg'));
num_files = size(fnames,1);
p=0.2 ; 

% Image de test
%inputfile='George_W_Bush/George_W_Bush_0024.jpg';
inputfile='George_W_Bush/George_W_Bush_0031.jpg';
I_test=imread(inputfile);

figure;imshow(I_test);
imycbcr = rgb2ycbcr(I_test);

all_data=[];
for f = 1:20  %num_files to learn from all images
   im=strcat(database_dir,'/',fnames(f).name) ;  
   % extraction d'une zone centrale de l'image 
   cim=SelectPixelsCentre(im, p);
   % sortie : cim : composé de 3 matrices correspondant aux 3 plans couleurs 
   % r=cim(:,:,1), g=cim(:,:,2), b=cim(:,:,3)
   subplot(4,5,f)
   imagesc(cim)
   
   % extraction des composantes chromatiques cb, cr de la zone précédemment extraite
   [cb, cr] = get_cbcr(cim);
   cb_data=reshape(cb,[size(cb,1)*size(cb,2),1]);
   cr_data=reshape(cr,[size(cr,1)*size(cr,2),1]);
   crcb_data=[cr_data cb_data];
   clear cb; clear cr; clear cb_data; clear cr_data;
   % on obtient un vecteur de taille size(cim,1)*size(cim,2) lignes * 2
   % colonnes (col1 = cr; col2 = cb) 
   % chaque ligne de la matrice correspond à un pixel (un échantillon/individu de type
   % peau) caractérisé par 2 valeurs cr, cb filtrées.   
   all_data=[all_data;crcb_data];    
  % figure;imshow(cim);
end 

%% 1.2. Avantage & Inconvenients :
% Les avantages sont : l'algorithme est rapide et permet de facilement
% trouver les zones sur une image centrée.
% Les Inconvenients : Cela peut être problèmatique selon la couleur de
% peau à détecter, l'isolation de l'objet à detecter, l'emplacement de
% l'objet.
%% 2.1 Avantage
% Contrairement à la couleur, ce domaine est moins sensible aux ombres et
% aux luminences.
%% 2.3 Représentation des échantillons dans l'espace des paramètres
figure;
plot_hist2d(all_data(:,1), all_data(:,2));
% interprétation de l'histogramme
% Il y a deux sommets différents, l'un est notre peau et l'autre est les
% ombres comprises dans l'imagette. Mais nous ne devons pas supprimé le
% plus petit par segmentation car cela pourrait faussé le dévellopement à
% cause de peau de couleur plus sombre.
%% Modélisation des données par une gaussienne
%estimation des paramètres statistiques du modèle à partir des échantillons
mu1 = mean(all_data)';
C1 = cov(all_data);
C1_inv = C1^(-1);
dC1 = det(C1);
%calcul du modèle dans un plan 2D
modelegaussien = zeros(256);
for r = 0:255
   for b = 0:255
       x = [r; b];
       % calcul de la vraisemblance de chaque pixel
       modelegaussien(r+1,b+1) = GaussLikelihood(x, mu1, C1_inv, dC1);%likelihood=vraisemblance
   end
end
%représentation de l'histogramme 2D 
subplot(1,2,1);
plot_hist2d(all_data(:,1), all_data(:,2))
title('Histogramme 2D des échantillons')
%représentation du modèle obtenu à partir de l'histogramme 2D
subplot(1,2,2);
surf(modelegaussien);
title('Modèle de la densité de probabilité jointe gaussienne de la classe peau')

%Interprétation des résultats
% On peut voir un log gaussien qui prend en compte toute l'information des
% moyennes, etc comprises dans les échantillons

%% Application du modèle à des images test

[m,n,l] = size(I_test);
%initialisation d'une matrice 2D de la taille de l'image à traiter
pxskin = zeros(m,n);
for i = 1:m
   for j = 1:n
      %extraction des caractéristiques d'un échantillon (=pixel)
       cr = double(imycbcr(i,j,3));
       cb = double(imycbcr(i,j,2));
       x=[cr; cb];
       % calcul de la vraisemblance de chaque pixel
       pxskin(i,j)=GaussLikelihood(x, mu1, C1_inv, dC1);
   end
end

%filtrage moyen pour lisser les valeurs 
lpf= 1/9*ones(3);
pxskin = filter2(lpf,pxskin);
%normalisation des valeurs de vraisemblance par la valeur max
pxskin = pxskin./max(max(pxskin));

%affichage de l'image résultat
figure;
subplot(1,2,1);
imshow(I_test, [0 1]);
title('Image RGB initiale')
subplot(1,2,2);
imshow(pxskin, [0 1]);
title('Image p(x/skin)')

% Le modèle semble assez pertinent sur les tests fait.
% Cela ne permet pas forcément de segmenter le visage car certains morceaux
% des cheveux à la même intensité que des parties du visage. Mais ce masque
% est un premier pas vers la segmentation. Il faut définir une autre
% classe.
%% Partie 2 :
figure();
p2 = 0.4;
dodo = SelectPixelsBack('George_W_Bush/George_W_Bush_0027.jpg',p2);
% imshow(dodo);
% figure;imshow(I_test);
imycbcr = rgb2ycbcr(I_test);

all_data=[];
for f = 1:20  %num_files to learn from all images
   im=strcat(database_dir,'/',fnames(f).name) ;  
   % extraction d'une zone centrale de l'image   
   [cim cim2]=SelectPixelsBack(im, p);
   % sortie : cim : composé de 3 matrices correspondant aux 3 plans couleurs 
   % r=cim(:,:,1), g=cim(:,:,2), b=cim(:,:,3)
   
   subplot(4,5,f)
   imagesc(cim)
   
   % extraction des composantes chromatiques cb, cr de la zone précédemment extraite
   [cb, cr] = get_cbcr(cim);
   cb_data=reshape(cb,[size(cb,1)*size(cb,2),1]);
   cr_data=reshape(cr,[size(cr,1)*size(cr,2),1]);
   crcb_data=[cr_data cb_data];
   clear cb; clear cr; clear cb_data; clear cr_data;
   % on obtient un vecteur de taille size(cim,1)*size(cim,2) lignes * 2
   % colonnes (col1 = cr; col2 = cb) 
   % chaque ligne de la matrice correspond à un pixel (un échantillon/individu de type
   % peau) caractérisé par 2 valeurs cr, cb filtrées.   
   all_data=[all_data;crcb_data];    
  % figure;imshow(cim);
end
%% Modélisation des données par une gaussienne
%estimation des paramètres statistiques du modèle à partir des échantillons
mu2 = mean(all_data)';
C2 = cov(all_data);
C2_inv = C2^(-1);
dC2 = det(C2);
%calcul du modèle dans un plan 2D
modelegaussien = zeros(256);
for r = 0:255
   for b = 0:255
       x = [r; b];
       % calcul de la vraisemblance de chaque pixel
       modelegaussien(r+1,b+1) = GaussLikelihood(x, mu2, C2_inv, dC2);%likelihood=vraisemblance
   end
end
%représentation de l'histogramme 2D 
subplot(1,2,1);
plot_hist2d(all_data(:,1), all_data(:,2))
title('Histogramme 2D des échantillons')
%représentation du modèle obtenu à partir de l'histogramme 2D
subplot(1,2,2);
surf(modelegaussien);
title('Modèle de la densité de probabilité jointe gaussienne de la classe peau')



%% Application du modèle à des images test

figure();

[m,n,l] = size(I_test);
%initialisation d'une matrice 2D de la taille de l'image à traiter
pxnonskin = zeros(m,n);
for i = 1:m
   for j = 1:n
      %extraction des caractéristiques d'un échantillon (=pixel)
       cr = double(imycbcr(i,j,3));
       cb = double(imycbcr(i,j,2));
       x=[cr; cb];
       % calcul de la vraisemblance de chaque pixel
       pxnonskin(i,j)=GaussLikelihood(x, mu2, C2_inv, dC2);
   end
end

%filtrage moyen pour lisser les valeurs 
lpf= 1/9*ones(3);
pxnonskin = filter2(lpf,pxnonskin);
%normalisation des valeurs de vraisemblance par la valeur max
pxnonskin = pxnonskin./max(max(pxnonskin));


%affichage de l'image résultat
figure;
subplot(1,2,1);
imshow(I_test, [0 1]);
title('Image RGB initiale')
subplot(1,2,2);
imshow(pxnonskin, [0 1]);
title('Image p(x/skin)')


%% variation des p a priori
figure();
v = 20/19;
index = 0;
for iii = 0:v:20
    index = index + 1;
    
pskin = iii / 20;
pnonskin = 1 - pskin;

segmentation = pxskin*pskin > pxnonskin*pnonskin;


subplot(4,5,index);
imshow(segmentation,[]);
title(['pskin = ', num2str(pskin)]);

end

%%
pskin = 0.5;
pnonskin = 0.5;
g1 = log(pxskin) + log(pskin);
g2 = log(pxnonskin) + log(pnonskin);
g = g1 - g2;
frontiere_verticale = diff(sign(g)) ~= 0;
frontiere_hor = diff(sign(g'))' ~= 0;
frontiere = frontiere_verticale(:,1:end-1) | frontiere_hor(1:end-1,:);

figure;
subplot(1,3,1);
imshow(frontiere_verticale,[]);
subplot(1,3,2);
imshow(frontiere_hor,[]);
subplot(1,3,3);
imshow(frontiere,[]);
%%
clc;
Ifront = false(250);
Ifront(1:end-1,1:end-1) = frontiere;
ItestFront = I_test;
ItestFrontR = ItestFront(:,:,1);
ItestFrontG = ItestFront(:,:,2);
ItestFrontB = ItestFront(:,:,3);
ItestFrontR(Ifront) = 255;
ItestFrontG(Ifront) = 255;
ItestFrontB(Ifront) = 255;
ItestFront(:,:,1) = ItestFrontR;
ItestFront(:,:,2) = ItestFrontG;
ItestFront(:,:,3) = ItestFrontB;

figure;
subplot(1,2,1);
imshow(I_test,[]);
subplot(1,2,2);
imshow(ItestFront,[]);