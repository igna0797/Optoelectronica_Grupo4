clc
close all
clear all

img01 = im2double(rgb2gray(imread("mediciones_tp1/haz_305mm.jpg")));

figure();
imshow(img01);
axis("tic", "label");

for i = 1:rows(img01)
    x_umbrales01 = find(img01(i,:) > 0.6);
    if (length(x_umbrales01) >= 2)
        ancho01(i,1) = x_umbrales01(end) - x_umbrales01(1);
    else
        ancho01(i,1) = 0;
    endif
endfor
[~, y_max_ancho01] = max(ancho01);

for i = 1:columns(img01)
    y_umbrales01 = find(img01(:,i) > 0.7);
    if (length(y_umbrales01) >= 2)
        alto01(1,i) = y_umbrales01(end) - y_umbrales01(1);
    else
        alto01(1,i) = 0;
    endif
endfor
[~, x_max_ancho01] = max(alto01);

% se puede hacer mejor la deteccion del centro


figure(2);
hold on;
imshow(gray2ind(img01), jet());
plot(1:(columns(img01)), y_max_ancho01*ones(1,columns(img01)), "-k", "linewidth", 2);
plot( x_max_ancho01*ones(rows(img01),1),1:(rows(img01)), "-k", "linewidth", 2);

axis("tic", "label");
xlabel("x / px");
ylabel("y / px");
