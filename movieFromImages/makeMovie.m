%% Script to make movie from set of images
% Input - Image files (.jpg format)
% Output - movie.avi
% Author- Piyush Khopkar
%%

outputVideo = VideoWriter(fullfile('Simulation.avi'));                      % Make a VideoWriter object to write video data on Simulation.avi
outputVideo.FrameRate = 2;                                                  % Specify frame rate
open(outputVideo);

for i = 1:92
    saveImage = ['Iteration_' num2str(i) '.jpg'];
    img = imread(saveImage);
    writeVideo(outputVideo,img);                                            % Write the frames to the object of VideoWriter
end
close(outputVideo);
%% end of script