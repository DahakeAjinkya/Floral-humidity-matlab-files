% -------------------------------------------------------------------
%  Generated by MATLAB on 26-Oct-2013 16:12:40
%  MATLAB version: 8.6.0.267246 (R2015b)
% -------------------------------------------------------------------
clear all;
clc;
close all;
foldername = 'Enter the folder name';
filename = 'Enterfilename'; % Stimulus File -  Don't put any .m or .mat here. It should contain the RH array and Temp array
hygrosensorfilename = 'Enterfilename'; % EPhys File - Don't put any .m or .mat here (Remember to convert .daq to .mat)
edited_ephys_filename = 'Enterfilename'; % Output file after spike sorting in wave-clus 

saveVarsMatfilename = strcat(foldername,'\', filename, '.mat');
saveVarsMat = load(saveVarsMatfilename);

%absStimTimeChar = StimCodeData.Female_RH_fast_sine_wave_moist_neuron_stim_1{7}; % Change filename;
absStimTime = saveVarsMat.abstime;                             % Extracting Start Time
%absEndTimeChar = StimCodeData.Female_RH_fast_sine_wave_moist_neuron_stim_1{11};
absEndTime=absStimTime+[0 0 0 0 4 42.330];                            % Extracting End Time
%iChar = StimCodeData.Female_RH_fast_sine_wave_moist_neuron_stim_1{13};
i = 1800;                                                  % Extracting time that was set for saving, typically 2 minutes.

hygrosensorloadfilename = strcat(foldername,'\',hygrosensorfilename,'.mat');    % Extracting Ephys Data
hygrosensor = load(hygrosensorloadfilename);

edited_ephys_load_filename = strcat(foldername,'\', edited_ephys_filename,'.mat');
edited_ephys = load(edited_ephys_load_filename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
StimStartTime = absStimTime(4).*3600+ absStimTime(5).*60 + absStimTime(6);
if isempty(absEndTime)
    StimEndTime = StimStartTime + 186.893;
else
StimEndTime = absEndTime(4).*3600+ absEndTime(5).*60 + absEndTime(6);
end
absSensTime = hygrosensor.abstime;
SensStartTime = absSensTime(4).*3600+ absSensTime(5).*60 + absSensTime(6);

if isempty(i)
    i =1200;
end

ephystime =  hygrosensor.time;  % In seconds
ephysdata =  hygrosensor.data;

numdata = saveVarsMat.numdata; % <1x1199 cell> too many elements

for j = 1:length(numdata)
    rh_array(j) = numdata{j}(2);
    temp_array(j) = numdata{j}(1);
    
end
StimTimeArray = (StimEndTime-StimStartTime)/i:...
    (StimEndTime-StimStartTime)/i:...
    (StimEndTime-StimStartTime-(StimEndTime-StimStartTime)/i);

rateofchange=diff(rh_array)./diff(StimTimeArray);
rateofchange(end+1)=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig = figure(1);
subplot(5,1,1);
plot((SensStartTime+ephystime - min(SensStartTime,StimStartTime)), ephysdata,'-b');
xlim([0,StimEndTime-min(SensStartTime,StimStartTime)]);
subplot(5,1,2);
plot(StimStartTime+StimTimeArray-min(SensStartTime,StimStartTime), rh_array, '*r');
xlim([0,StimEndTime-min(SensStartTime,StimStartTime)]);
subplot(5,1,3);
plot(StimStartTime+StimTimeArray-min(SensStartTime,StimStartTime), rateofchange, '*r');
xlim([0,StimEndTime-min(SensStartTime,StimStartTime)]);
subplot(5,1,4);
plot(StimStartTime+StimTimeArray-min(SensStartTime,StimStartTime), temp_array, '*r');
xlim([0,StimEndTime-min(SensStartTime,StimStartTime)]);

%savefilename = strcat(foldername,'/',filename);
%saveas(fig,savefilename,'fig');
pause(2);
%%%%%%%%%%%%%%%%%%%%%%%%%% added this code 26 Sep 2021 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EphysTimeArray = (SensStartTime+ephystime - min(SensStartTime,StimStartTime));
StimTimeArray = StimStartTime+StimTimeArray-min(SensStartTime,StimStartTime);

edited_EphysTimeArray = SensStartTime + (edited_ephys.cluster_class(:,2)./10^3)...
                        - min(SensStartTime,StimStartTime);

[sharedvals,idx] = intersect(EphysTimeArray,edited_EphysTimeArray,'stable');

edited_ephys_data  = ephysdata(idx); 

cluster1_time = edited_EphysTimeArray(edited_ephys.cluster_class(:,1)== 1);
figure(1); hold on;
subplot(5,1,5);
plot([cluster1_time,cluster1_time], [-3, 3], '-b');hold on;

cluster3_time = edited_EphysTimeArray(edited_ephys.cluster_class(:,1) ~= 1);
plot([cluster3_time,cluster3_time], [-1, 1], '-r');

%                     
% for i = 1: length(edited_EphysTimeArray)-1
%    figure(1); hold on;
%    subplot(5,1,5);
%    hold on;
%    if edited_ephys.cluster_class(i,1)== 1
%        plot(edited_EphysTimeArray(i,1)*ones(2,1),  [-4,4], '-b');
%    else
%        plot(edited_EphysTimeArray(i,1)*ones(2,1),  [-2,2], '-r');
%    end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
fig2 = figure(2);


Sel_start = 110;
Sel_end = 210;

num_subplots = 6;

subplot(num_subplots,1,1);
plot(EphysTimeArray(EphysTimeArray>Sel_start & EphysTimeArray<Sel_end),...
    ephysdata(EphysTimeArray>Sel_start & EphysTimeArray<Sel_end),'-b');set(gcf,'renderer','painters');set(gca,'TickDir','out');
xlim([Sel_start,Sel_end]);ylim([-1.3,1]);
subplot(num_subplots,1,4);
plot(StimTimeArray(StimTimeArray>Sel_start & StimTimeArray<Sel_end),...
     rh_array(StimTimeArray>Sel_start & StimTimeArray<Sel_end), '*r');set(gcf,'renderer','painters');set(gca,'TickDir','out');
xlim([Sel_start,Sel_end]);
subplot(num_subplots,1,5);
plot(StimTimeArray(StimTimeArray>Sel_start & StimTimeArray<Sel_end),...
     rateofchange(StimTimeArray>Sel_start & StimTimeArray<Sel_end), '*b');set(gcf,'renderer','painters');set(gca,'TickDir','out');
xlim([Sel_start,Sel_end]);ylim([-4,4]);
subplot(num_subplots,1,6);
plot(StimTimeArray(StimTimeArray>Sel_start & StimTimeArray<Sel_end),...
    temp_array(StimTimeArray>Sel_start & StimTimeArray<Sel_end), '*r');set(gcf,'renderer','painters');set(gca,'TickDir','out');
xlim([Sel_start,Sel_end]);ylim([29,30]);

%%%%%%%%%%%%%%%%%%% added this code 26 Sep 2021 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
edited_EphysTimeArray_sel = edited_EphysTimeArray(edited_EphysTimeArray>Sel_start & edited_EphysTimeArray<Sel_end);
sel_cluster_class = edited_ephys.cluster_class(edited_EphysTimeArray>Sel_start & edited_EphysTimeArray<Sel_end,1);

set(gcf,'renderer','painters') % important to get the figures exported in the right format
%set(gca,'Fontsize',15)
%set(gca,'FontName','Times New Roman')
set(gca,'TickDir','out'); % The only other option is 'in'
x0=10;
y0=10;
width=600;
height=500;
set(gcf,'position',[x0,y0,width,height]);
set(gcf,'units','points','position',[x0,y0,width,height]);

cluster1_time = edited_EphysTimeArray_sel(sel_cluster_class == 1);
figure(2); hold on;
subplot(num_subplots,1,2); ylim([-5 5]);xlim([Sel_start,Sel_end]);
plot([cluster1_time,cluster1_time], [-3, 3], '-b');hold on;set(gcf,'renderer','painters');set(gca,'TickDir','out');

cluster3_time = edited_EphysTimeArray_sel(sel_cluster_class == 2);ylim([-5,5]);xlim([Sel_start,Sel_end]);
plot([cluster3_time,cluster3_time], [-1, 1], '-r');set(gcf,'renderer','painters');set(gca,'TickDir','out');

cluster1_floor = floor(cluster1_time);
cluster3_floor = floor(cluster3_time);

cluster1_val = unique(cluster1_floor);
cluster3_val = unique(cluster3_floor);


[cluster1_freq,edges1] = histcounts(cluster1_time,(Sel_end-Sel_start));
[cluster3_freq,edges3] = histcounts(cluster3_time,(Sel_end-Sel_start));

points1 = movmean(edges1,3); points1 = points1(2:end);
points3 = movmean(edges3,3); points3 = points3(2:end);

figure(2); hold on;
subplot(num_subplots,1,3);xlim([Sel_start,Sel_end]);hold on;
plot(points1, cluster1_freq, 'b');set(gcf,'renderer','painters');set(gca,'TickDir','out');hold on;
plot(points3, cluster3_freq, 'r');set(gcf,'renderer','painters');set(gca,'TickDir','out');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Added this on 13th Jan 2022 to generate 3D scatterplots and evaluate correlations
    
for i = 1:length(edges1)-1
    
    [val,corrInd1] = min(abs(StimTimeArray - edges1(i)));
    [val,corrInd2] = min(abs(StimTimeArray - edges1(i+1)));
    
    rh_array_points1_3d(i) = mean(rh_array(corrInd1:corrInd2));
    rateofchange_points1_3d(i) = mean(rateofchange(corrInd1:corrInd2));
end

for i = 1:length(edges3)-1    
    [val,corrInd1] = min(abs(StimTimeArray - edges3(i)));
    [val,corrInd2] = min(abs(StimTimeArray - edges3(i+1)));
    
    rh_array_points3_3d(i) = mean(rh_array(corrInd1:corrInd2));
    rateofchange_points3_3d(i) = mean(rateofchange(corrInd1:corrInd2));
end


% for i = 1:length(edges3)-1
%     
%     [val,corrInd1] = min(abs(StimTimeArray - points3(i)));
%     rh_array_points3_3d(i) = rh_array(corrInd);
%     rateofchange_points3_3d(i) = rateofchange(corrInd);
% end
%%
figure(3);hold on; grid on;
plot3(rh_array_points1_3d,rateofchange_points1_3d,cluster1_freq,'o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF');
view([-40 33]);
xlabel('Relative Humidity');
ylabel('Slope in RH');
zlabel('Impulse/s');

figure(4);hold on; grid on;
plot3(rh_array_points3_3d,rateofchange_points3_3d,cluster3_freq,'o','Color','r','MarkerSize',10,...
    'MarkerFaceColor','#ffb6c1');
view([-40 33]);
xlabel('Relative Humidity');
ylabel('Slope in RH');
zlabel('Impulse/s');

figure(5); hold on;
moist = fit([rateofchange_points1_3d',rh_array_points1_3d'],cluster1_freq','poly11', 'Exclude', cluster1_freq == 0);
stem3(rateofchange_points1_3d,rh_array_points1_3d,cluster1_freq,'o','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF');
view([-40.3690 36.0265]);
h2=plot( moist, [rateofchange_points1_3d',rh_array_points1_3d'],cluster1_freq');
colormap([0 0.4470 0.7410]);
h2(1).LineStyle = 'none';
h2(1).FaceAlpha = 0.3;
xlabel('rate of change (%RH/sec)');
ylabel('Relative Humidity');
zlabel('Impulses/sec');%zlim([0,60]);
x0=10;
y0=10;
width=300;
height=300;
set(gcf,'position',[x0,y0,width,height]);
set(gcf,'units','points','position',[x0,y0,width,height]);
set(gcf,'renderer','painters');set(gca,'TickDir','out')

figure(6); hold on;
dry = fit([rateofchange_points3_3d',rh_array_points3_3d'],cluster3_freq','poly11','Exclude',  cluster3_freq == 0);
stem3(rateofchange_points3_3d,rh_array_points3_3d,cluster3_freq,'o','Color','r','MarkerSize',10,'MarkerFaceColor','#ffb6c1');
view([-40.3690 36.0265]);
h2=plot( dry, [rateofchange_points3_3d',rh_array_points3_3d'],cluster3_freq');
colormap([0.8500 0.3250 0.0980]);
h2(1).LineStyle = 'none';
h2(1).FaceAlpha = 0.3;
xlabel('rate of change (%RH/sec)');
ylabel('Relative Humidity');
zlabel('Impulses/sec');zlim([0,60]);
x0=10;
y0=10;
width=300;
height=300;
set(gcf,'position',[x0,y0,width,height]);
set(gcf,'units','points','position',[x0,y0,width,height]);
set(gcf,'renderer','painters');set(gca,'TickDir','out')

%plot3(cluster1_freq,rh_array_points3_3d,rateofchange_points3_3d,'o','Color','b','MarkerSize',10,...
%    'MarkerFaceColor','#D9FFFF')
%view(2) % Use this if you have a third spike class 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%savefilename = strcat(foldername,'/',filename,'Selected');
%saveas(fig,savefilename,'png');


SelEphysTimeArray = EphysTimeArray(EphysTimeArray>Sel_start & EphysTimeArray<Sel_end);
SelEphysAmpArray =  ephysdata(EphysTimeArray>Sel_start & EphysTimeArray<Sel_end);
SelStimTimeArray = StimTimeArray(StimTimeArray>Sel_start & StimTimeArray<Sel_end);
SelRHArray = rh_array(StimTimeArray>Sel_start & StimTimeArray<Sel_end);
SelTempArray = temp_array(StimTimeArray>Sel_start & StimTimeArray<Sel_end);
SelRHArray = rh_array(StimTimeArray>Sel_start & StimTimeArray<Sel_end);
SelTempArray = temp_array(StimTimeArray>Sel_start & StimTimeArray<Sel_end);
Selcluster1_freq=cluster1_freq.';
Selrh_array_points1_3d=rh_array_points1_3d.';
Selrateofchange_points1_3d=rateofchange_points1_3d.';
Selcluster3_freq=cluster3_freq.';
Selrh_array_points3_3d=rh_array_points3_3d.';
Selrateofchange_points3_3d=rateofchange_points3_3d.';


