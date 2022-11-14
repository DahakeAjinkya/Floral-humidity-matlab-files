clear all;
clc;
close all;
cd 'D:\Cornell Graduate Work\Humidity  ephys data\Analysed Ephys data'
a=readtable('NaN_removed_Ephys_corr.xlsx');

figure(1);hold on; grid on;
plot3(a.rh_array_moist,a.rateofchange_moist,a.moist_freq,'o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF');
view([-40 33]);
xlabel('Relative Humidity');
ylabel('Slope in RH');
zlabel('Impulse/s');

figure(2);hold on; grid on;
plot3(a.rh_array_dry,a.rateofchange_dry,a.dry_freq,'o','Color','r','MarkerSize',10,...
    'MarkerFaceColor','#ffb6c1');
view([-40 33]);
xlabel('Relative Humidity');
ylabel('Slope in RH');
zlabel('Impulse/s');

figure(3); hold on;
moist = fit([a.rh_array_moist,a.rateofchange_moist],a.moist_freq,'poly11', 'Exclude', a.moist_freq == 0);
stem3(a.rh_array_moist,a.rateofchange_moist,a.moist_freq,'o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF');
view([-40 33]);
h1=plot( moist, [a.rh_array_moist,a.rateofchange_moist], a.moist_freq);
colormap([0 0.4470 0.7410]);
h1(1).LineStyle = 'none';
h1(1).FaceAlpha = 0.5;
xlabel('Relative Humidity');
ylabel('Slope in RH');
zlabel('Impulse/s');

figure(4); hold on;
dry = fit([a.rh_array_dry,a.rateofchange_dry],a.dry_freq,'poly11','Exclude',  a.dry_freq == 0);
plot3(a.rh_array_dry,a.rateofchange_dry,a.dry_freq,'o','Color','r','MarkerSize',10,...
    'MarkerFaceColor','#ffb6c1');
view([-40 33]);
h2=plot( dry, [a.rh_array_dry,a.rateofchange_dry],a.dry_freq);
colormap([0.8500 0.3250 0.0980]);
h2(1).LineStyle = 'none';
h2(1).FaceAlpha = 0.5;
xlabel('Relative Humidity');
ylabel('Slope in RH');
zlabel('Impulse/s');

%plot3(cluster1_freq,rh_array_points3_3d,rateofchange_points3_3d,'o','Color','b','MarkerSize',10,...
%    'MarkerFaceColor','#D9FFFF')