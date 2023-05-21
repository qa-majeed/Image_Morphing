

T = imread('cat_face.jpg');         %Reading Target image.
S = imread('Me_face.jpg');          %Reading Source Image.

%T = rgb2gray(T);
%S = rgb2gray(S);
figure
imshow(T);                          %Showing Target image to get correspondence points.
[x, y] = getpts;
%%sleep(10);
imshow(S);                          %Showing Source image to get correspondence points.
[xr, yr] = getpts;
tform = fitgeotrans([xr yr],[x y],'affine');    %Getting affine Transform.
St = imwarp(S,tform,'OutputView',imref2d(size(T)));     %Warp Source to Target Image.

fft_S = fft2(St);                    %Getting FFt of Source after alligned.
fft_T = fft2(T);                     %Getting FFt of Target.

[xt, yt, cht] = size(T);             %Gettinging Dimension of target image.
[xS, yS, chS] = size(S);             %Gettinging Dimension of target image.


ffs_S = fftshift(fft_S);             %Getting FFt_Shift of Source after alligned.
ffs_T = fftshift(fft_T);             %Getting FFt_Shift of Target.
%Now defining Lowpass filter...
x=-xt/2:1:xt/2-1;
y=-yt/2:1:yt/2-1;
%y=y';
[X,Y]=meshgrid(x,y);

N = 150;                 %Total intermediate frames.
Do = (sqrt((xt/2)^2 + (yt/2)^2))/N;
video = VideoWriter('vedio');
open(video);
%scaling = 1000000000;

%gauss = 1:0.1:2;
%gauss = gaussmf(x,[2 0]);

for i = 1: N

Do = 3.1 * Do/N + Do;    
%z = (1000000/sqrt(2*pi)*exp(-(X.^2+Y.^2)/(2*(Do)^2)));    % Here is I am defining filter for frequency domain.
z =  exp(-(X.^2+Y.^2)/(2*(Do)^2));    % Here is I am defining filter for frequency domain.
%z = z/sum(z(:));
z = z';
%syntax(x,y, z);
Output = (ffs_S - ffs_T).*z + ffs_T;
out = ifftshift(Output);
out = ifft2(out);
%out = 255 * (out)./max(out);
out = (out)./max(out);              %Normalization....
out = real(out);
save = strcat('img', int2str(i), '.jpg');
imwrite(out, save);
%out = out ./255;
res = imread(save);
%res = (res - min(res(:))) / (max(res(:)) - min(res(:)));
writeVideo(video, res);
%writeVideo(video, out);
end

close(video);

