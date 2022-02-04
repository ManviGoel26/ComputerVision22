function[] = m_2019472_1a(name)
rng('default');
close all;

I = imread(name);
I=double(I);
k = 85;

% Code taken from Classroom
[M,N,ch]=size(I);
Id=reshape(I,M*N,ch,1);
kd=Id(ceil(rand(k,1)*M*N),:);
kdo=kd;
itr=0;
while(1)
    itr=itr+1;
dist=pdist2(Id,kdo);
[~,label]=min(dist,[],2);
for i=1:k
kd(i,:)=mean(Id(label==i,:));
end
err=sum(sum(abs(kd-kdo)));
if err<k||itr>max(5,sqrt(k))
    break;
end
kdo=kd;
end
kd = round(kd);
kr = kd(label,:);
newIm = double(uint8(reshape(kr,M,N,ch)));
krl = reshape(label,M,N,1);

% Code for 1a
imshow(newIm)

hist = zeros(85, 5);
totalPixels = M*N;

for i = 1:M
    for j = 1:N
        for k = 1:85
            if (hist(k, 1) == newIm(i, j, 1) && hist(k, 2) == newIm(i, j, 2) && hist(k, 3) == newIm(i, j, 3))
                hist(k, 4) = hist(k, 4) + 1;
                break;
            
            elseif (hist(k, :) == [0 0 0 0 0])
                hist(k, :) = [newIm(i, j, 1) newIm(i, j, 2) newIm(i, j, 3) 1 0];
                break;
            end
        end
    end
end

% saliency map
for i = 1:85
    sal_c = 0;
    for j = i:85
        cd = ((hist(i, 1) - hist(j, 1))^2 + (hist(i, 2) - hist(j, 2))^2 + (hist(i, 3) - hist(j, 3))^2)^0.5;
        sal_c = sal_c + (hist(j, 4)/totalPixels)*cd;
    end
    hist(i, 5) = sal_c;
end

salIm = [];

for i= 1:M
    for j = 1:N
        for k = 1:85
            if ((hist(k, 1) == newIm(i, j, 1) && hist(k, 2) == newIm(i, j, 2) && hist(k, 3) == newIm(i, j, 3)))
                salIm(i, j, :) = hist(k, 5);
            end
        end
    end
end

norIm = (salIm-min(salIm(:)))/(max(salIm(:) - min(salIm(:))));
imshow(double(norIm))


% 1b


% imshow(salIm)
end