function[] = backSubWithCircle(name, path)

close all;

mkdir(strcat(path, 'bs/'))

vidObj = VideoReader(name);
vidFrames = read(vidObj, [1 Inf]);

totalFrames = size(vidFrames);
totalFrames = totalFrames(4);

% Finding The Median Frame
medBack = median(vidFrames, 4);
imshow(medBack)

vid = VideoWriter('video.avi');
open(vid);

% Applying background subtraction
for frame = 1:totalFrames
      newFrame = rgb2gray(uint8(abs(double(vidFrames(:, :, :, frame))-double(medBack))));
      binaryMask = double(newFrame>graythresh(newFrame)*255);
      bb = regionprops(binaryMask, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'BoundingBox'});
      c = bb.Centroid;
      r = bb.MajorAxisLength/2;

      Im(:,:, 1) = vidFrames(:, :, 1, frame);        
      Im(:, :, 2) = vidFrames(:, :, 2, frame);
      Im(:, :, 3) = vidFrames(:, :, 3, frame);
       
      theta = 0:1:360;
      ro = round(c(1) + r*sin(theta));
      co = round(c(2) + r*cos(theta));
      sizes = size(Im);
      
%       Making a circle
      for j = 1:length(ro)
          if (ro(j) > 0 && co(j) > 0 && co(j) < sizes(1) && ro(j) < sizes(2))
              Im(co(j), ro(j),:) = [255 0 0];
          end
      end
       
%       Adding to the video
      imwrite(Im, strcat(path, 'bs/', num2str(frame), '.jpg'))
      writeVideo(vid, Im);
end

close(vid);
end


