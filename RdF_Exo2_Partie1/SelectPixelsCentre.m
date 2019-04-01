function cim=SelectPixelsCentre(image, p)
% image = chemin de l'image
% p = la distance (en %) par rapport au centre de l'image
% cim = imagette
I=imread(image);
[M N O]=size(I);
% M = Largeur
% N = Longueur
% O = nb de plan
minx = floor((M-p*M)/2);
miny = floor((N-p*N)/2);
maxx= minx+ floor(p*M);
maxy= miny+ floor(p*N);

cim = I(minx:maxx,miny:maxy,:);
