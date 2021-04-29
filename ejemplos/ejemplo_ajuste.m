close all;
clear all;

pkg load image
#pkg load optics
#pkg load optim # tiene la funcion fmins

img01 = im2double(rgb2gray(imread("Picture 1.jpg")));

figure(1);
imshow(img01);
axis("tic", "label");

#busco por filas las que estan por arriba de un umbral y les calculo el ancho, luego busco la mas ancha
%parece una circunferencia entonces buscas la parte mas ancha (pasa por el centro)
for i = 1:rows(img01)
    x_umbrales01 = find(img01(i,:) > 0.7);
    if (length(x_umbrales01) >= 2)
        ancho01(i,1) = x_umbrales01(end) - x_umbrales01(1);
    else
        ancho01(i,1) = 0;
    endif
endfor
[~, y_max_ancho01] = max(ancho01);

figure(2);
hold on;
imshow(gray2ind(img01), jet());
plot(1:(columns(img01)), y_max_ancho01*ones(1,columns(img01)), "-k", "linewidth", 2);
axis("tic", "label");
xlabel("x / px");
ylabel("y / px");

med_max_x01 = img01(y_max_ancho01, :);
x01 = 0:(columns(img01)-1);

#busco el valor central de la medicion y corro el eje x
x_umbr01 = find(med_max_x01 > 0.3);
x_cent01 = floor((x_umbr01(1) + x_umbr01(end))/2);
x01 = x01 - x_cent01;%segundo paramentro de ajuste

%podes normalizar el valor de la altura que te simplifica todo (valor inicial 1)

%calcula el err cuad mmedio entre una gausseana y 'x'
%gausseana es la definida como el haz gausseano cuando varia x y =0 y viceversa
parametros01 = fminsearch(@(param) err_cuad_gauss(param, [x01; med_max_x01]), [1, 1]);
%cuidado puedo converger a minimo local o algo asi

figure(3);
hold on;
plot(x01, med_max_x01, "linewidth", 2);
plot(x01, arrayfun(@(x) gaussiana(x, 0, parametros01(1), parametros01(2)), x01), "linewidth", 2);
grid on;
xlabel("x / px");
ylabel("I");
label_ajustes = sprintf("Ajustes w = %.2f px I_0 = %.3f", parametros01(1), parametros01(2));
legend("Medición", label_ajustes, "location", "northwest");
legend("boxoff");
