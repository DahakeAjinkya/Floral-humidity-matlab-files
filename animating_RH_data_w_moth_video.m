clear all;
clc;
close all;
foldername = 'E:\Ajinkya RH_data';
filename = 'sensor_in_out_2_flower_2_4Nov_2021';

saveVarsMatfilename = strcat(foldername,'\', filename, '.mat');
saveVarsMat = load(saveVarsMatfilename);
absStimTime = saveVarsMat.abstime;  
absEndTime = saveVarsMat.endtime;    

i = saveVarsMat.i;      % Extracting time that was set for saving, typically 2 minutes, in this case 5 mins 

StimStartTime = absStimTime(4).*3600+ absStimTime(5).*60 + absStimTime(6);
if isempty(absEndTime)
    StimEndTime = StimStartTime + 186.893;
else
StimEndTime = absEndTime(4).*3600+ absEndTime(5).*60 + absEndTime(6);
end
%absSensTime = hygrosensor.abstime;
%SensStartTime = absSensTime(4).*3600+ absSensTime(5).*60 + absSensTime(6);

if isempty(i)
    i =1200;
end

numdata = saveVarsMat.numdata; % <1x1199 cell> too many elements

for j = 1:length(numdata)
    rh_array(j) = numdata{j}(2);
    temp_array(j) = numdata{j}(1);
    
end
StimTimeArray = (StimEndTime-StimStartTime)/i:...
    (StimEndTime-StimStartTime)/i:...
    (StimEndTime-StimStartTime-(StimEndTime-StimStartTime)/i);

%% Setup the subplots
ax1 = subplot(2,1,1); % For video
ax2 = subplot(2,1,2); % For pressure plot
%% Setup VideoReader object
cd 'E:\Moth video on flowers\Nov 4 2021'
videoname = 'Sensor_In_Out_2_Flower_1_4Nov_2021.mp4';
v = VideoReader(videoname);
nFrames = v.Duration*v.FrameRate; % Number of frames
% Display the first frame in the top subplot
vidFrame = readFrame(v);
image(vidFrame, 'Parent', ax1);
ax1.Visible = 'off';
%% Load the RH and temp data and open a video file to generate a new combined video
w=VideoWriter('Animatedvideo_3.avi')
w.FrameRate=60
open(w)
%Fs=(StimEndTime-StimStartTime)/i
y = rh_array(1:length(rh_array));
t = (StimTimeArray);
y=y-26.2;% Subtracting background RH. Change this number for a new dataset
nDataPoints = length(t); % Number of data points
step = ((nDataPoints/nFrames));
index = 1:step:nDataPoints;
k = 2;
% Diplay the plot corresponds to the first frame in the bottom subplot
h = plot(ax2,t(1:index(k)),y(1:index(k)),'-k');
% Fix the axes
ax2.XLim = [0 max(t)];
ax2.YLim = [min(y) max(y)];
ylabel('% RH above ambient')
xlabel('% Time (sec)')

%% Animate
while hasFrame(v)
    %pause(1/v.FrameRate);
    
    vidFrame = readFrame(v);
    image(vidFrame, 'Parent', ax1);
    ax1.Visible = 'off';
    k = k + 1;
    set(h,'YData',y(1:index(k)), 'XData', t(1:index(k)))
    frame=getframe(gcf)
    writeVideo(w,frame)
end

close(w)