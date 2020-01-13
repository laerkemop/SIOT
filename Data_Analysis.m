%SIOT COURSEWORK 
%initialisation
clc 
close all 
%% BASIC DATA ANALYSIS 
T =readtable('data_analysis.csv');
a = 200;
b = 550;

s_UK = T.SensorUK;
s_FR = T.SensorFR;
Date = T.Time_S;
p_UK = (((s_UK - b)/(a-b)))*100; %mapping of the sensor value to humidity(%)
p_FR = (((s_FR - b)/(a-b)))*100;

FR_Hum = T.FRHumidity;
UK_Hum = T.UKHumidity;

FR_Tem = T.FRTemp;
UK_Tem = T.UKTemp;

figure('Name','Humidity ');          
plot(Date,[p_UK p_FR])
xlabel('Time Elapsed / min')                         
ylabel('Humidity / %') 
ylim([0 100])
title('Soil Humidity against time elapsed')
legend('UK','FR', 'location', 'best')
grid on

figure('Name','Weather')
plot(Date,[UK_Hum FR_Hum])
xlabel('Time Elapsed/min')                         
ylabel('Humidity / %') 
ylim([0 100])
title('Air Humidity against time elapsed')
legend('UK','FR','location', 'best')
grid on

figure('Name','Weather')
plot(Date,[FR_Tem, UK_Tem])
xlabel('Time Elapsed/min')                         
ylabel('Temperature /C') 
ylim([0 25])
title('Temperature against time elapsed')
legend('UK','FR', 'location', 'best')
grid on


%% Filtered Data - Humidity of the plant
period = T.Time_S/(60*24);
fcoeff = ones(1, 24)/24;
avgsensorUK = filter(fcoeff, 1, p_UK);
avgsensorFR = filter(fcoeff, 1, p_FR);
figure('Name','Filtered Soil Humidity')
plot(period,[p_UK avgsensorUK p_FR avgsensorFR])
legend('UK Sensor',' UK 24 Hour Average (delayed)','FR Sensor',' FR 24 Hour Average (delayed)','location','best')
ylabel('Humidity (%)')
xlabel('Time elapsed since start (days)')
title('Filtered Soil Humidity')
grid on 

%% Filtered Data - Air Humidity
period = T.Time_S/(60*24);
fcoeff = ones(1, 24)/24;
avghumUK = filter(fcoeff, 1, UK_Hum);
avghumFR = filter(fcoeff, 1, FR_Hum);
figure('Name','Filtered Air Humidity')
plot(period,[UK_Hum avghumUK FR_Hum avghumFR])
legend('UK Humidity',' UK 24 Hour Average (delayed)','FR Humidity',' FR 24 Hour Average (delayed)','location','best')
ylabel('Humidity (%)')
xlabel('Time elapsed since start (days)')
title('Filtered Air Humidity')
grid on 
%% Filtered Data - Temperature
period = T.Time_S/(60*24);
fcoeff = ones(1, 24)/24;
avgtemUK = filter(fcoeff, 1, UK_Tem);
avgtemFR = filter(fcoeff, 1, FR_Tem);
figure('Name','Filtered Temperature')
plot(period,[UK_Tem avgtemUK FR_Tem avgtemFR])
legend('UK Temperature',' UK 24 Hour Average (delayed)','FR Temperature',' FR 24 Hour Average (delayed)','location','best')
ylabel('Temperature /C')
xlabel('Time elapsed since start (days)')
title('Filtered Air Temperature')
grid on 

%% Data Correlation UK Data

figure('Name','Correlating UK Data')
plot(period,[avgtemUK avgsensorUK avghumUK])
xlabel('Time elapsed since start (days)')
title('Correlation between UK sensor, Humidity & Temperature')
legend('Temperature','Soil Humidity',' Air Humidity','location','best')
grid on 

%% Data Correlation FR Data

figure('Name','Correlating FR Data')
plot(period,[avgtemFR avgsensorFR avghumFR])
xlabel('Time elapsed since start (days)')
title('Correlation between FR sensor, Humidity & Temperature')
legend('Temperature','Soil Humidity',' Air Humidity','location','best')
grid on 



