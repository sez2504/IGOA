clc;
clear all;
%% weight calculation
w = zeros(57,1);
D = [9	11	7	6	9	38	48	2	3	3	7	7	5	10	7	14	3	4	4	2	5	9	5	7	4	22	10	10	4	3	4	5	...
     30	118	153	158	126	126	126	76	74	86	86	30	25	25	25	30	30	30	59	59	59	59	64	64	64];
for i = 1:57
    if D(i) <= 10
        w(i) = 1;
    elseif D(i) > 10 && D(i) <= 30
        w(i) = 2;
    elseif D(i) > 30 && D(i) <= 50
        w(i) = 3;
    elseif D(i) > 50 && D(i) <= 150
        w(i) = 4;
    else
        w(i) = 5;
    end
end
w = w./sum(w);
%% load data
A1 = xlsread('VMCH.xlsx',1);
A2 = xlsread('VMCH.xlsx',2);
B1 = xlsread('sCMAgES.xlsx',1);
B2 = xlsread('sCMAgES.xlsx',2);
C1 = xlsread('SASS.xlsx',1);
C2 = xlsread('SASS.xlsx',2);
D1 = xlsread('EnMODE.xlsx',1);
D2 = xlsread('EnMODE.xlsx',2);
E1 = xlsread('COLSHADE.xlsx',1);
E2 = xlsread('COLSHADE.xlsx',2);
F1 = xlsread('BiPop.xlsx',1);
F2 = xlsread('BiPop.xlsx',2);
G1 = xlsread('FCHA.xlsx',1);
G2 = xlsread('FCHA.xlsx',2);
H1 = xlsread('DEQL.xlsx',1);
H2 = xlsread('DEQL.xlsx',2);
%% best solution
bestA1 = A1(1,:);
bestA2 = A2(1,:);
bestB1 = B1(1,:);
bestB2 = B2(1,:);
bestC1 = C1(1,:);
bestC2 = C2(1,:);
bestD1 = D1(1,:);
bestD2 = D2(1,:);
bestE1 = E1(1,:);
bestE2 = E2(1,:);
bestF1 = F1(1,:);
bestF2 = F2(1,:);
bestG1 = G1(1,:);
bestG2 = G2(1,:);
bestH1 = H1(1,:);
bestH2 = H2(1,:);
best1 = [bestA1;bestB1;bestC1;bestD1;bestE1;bestF1;bestG1;bestH1];
best2 = [bestA2;bestB2;bestC2;bestD2;bestE2;bestF2;bestG2;bestH2];
i = best2 == 0;
j = ~i;
bestA = zeros(size(bestA1));
bestB = zeros(size(bestB1));
bestC = zeros(size(bestC1));
bestD = zeros(size(bestD1));
bestE = zeros(size(bestE1));
bestF = zeros(size(bestF1));
bestG = zeros(size(bestG1));
bestH = zeros(size(bestH1));
for kk = 1:57
    
    if sum(i(:,kk))==0
        bestA(:,kk) = bestA2(:,kk);
        bestB(:,kk) = bestB2(:,kk);
        bestC(:,kk) = bestC2(:,kk);
        bestD(:,kk) = bestD2(:,kk);
        bestE(:,kk) = bestE2(:,kk);
        bestF(:,kk) = bestF2(:,kk);
        bestG(:,kk) = bestG2(:,kk);
        bestH(:,kk) = bestH2(:,kk) ;
    else 
        M = max(best1(i(:,kk),kk));
        bestA(i(1,kk),kk) = bestA1(i(1,kk),kk);
        bestB(i(2,kk),kk) = bestB1(i(2,kk),kk);
        bestC(i(3,kk),kk) = bestC1(i(3,kk),kk);
        bestD(i(4,kk),kk) = bestD1(i(4,kk),kk);
        bestE(i(5,kk),kk) = bestE1(i(5,kk),kk);
        bestF(i(6,kk),kk) = bestF1(i(6,kk),kk);
        bestG(i(7,kk),kk) = bestG1(i(7,kk),kk);
        bestH(i(8,kk),kk) = bestH1(i(8,kk),kk) ;
        %%
        bestA(j(1,kk),kk) = M + bestA2(j(1,kk),kk);
        bestB(j(2,kk),kk) = M + bestB2(j(2,kk),kk);
        bestC(j(3,kk),kk) = M + bestC2(j(3,kk),kk);
        bestD(j(4,kk),kk) = M + bestD2(j(4,kk),kk);
        bestE(j(5,kk),kk) = M + bestE2(j(5,kk),kk);
        bestF(j(6,kk),kk) = M + bestF2(j(6,kk),kk);
        bestG(j(7,kk),kk) = M + bestG2(j(7,kk),kk);
        bestH(j(8,kk),kk) = M + bestH2(j(8,kk),kk) ;
    end
end
best = [bestA;bestB;bestC;bestD;bestE;bestF;bestG;bestH];
min_best = min(best);
max_best = max(best);
mx_mn_best = max_best-min_best;
mx_mn_best(mx_mn_best == 0) = 1e-8;
bestA   = (bestA-min_best)./(mx_mn_best);
bestB   = (bestB-min_best)./(mx_mn_best);
bestC   = (bestC-min_best)./(mx_mn_best);
bestD   = (bestD-min_best)./(mx_mn_best);
bestE   = (bestE-min_best)./(mx_mn_best);
bestF   = (bestF-min_best)./(mx_mn_best);
bestG   = (bestG-min_best)./(mx_mn_best);
bestH   = (bestH-min_best)./(mx_mn_best);bestH(isnan(bestH)) = 1;
best = [bestA;bestB;bestC;bestD;bestE;bestF;bestG;bestH];
Score_best = best*w;
%% mean Solution
meanA1 = mean(A1);
meanA2 = mean(A2);
meanB1 = mean(B1);
meanB2 = mean(B2);
meanC1 = mean(C1);
meanC2 = mean(C2);
meanD1 = mean(D1);
meanD2 = mean(D2);
meanE1 = mean(E1);
meanE2 = mean(E2);
meanF1 = mean(F1);
meanF2 = mean(F2);
meanG1 = mean(G1);
meanG2 = mean(G2);
meanH1 = mean(H1);
meanH2 = mean(H2);
mean1 = [meanA1;meanB1;meanC1;meanD1;meanE1;meanF1;meanG1;meanH1];
mean2 = [meanA2;meanB2;meanC2;meanD2;meanE2;meanF2;meanG2;meanH2];
i = mean2 == 0;
j = ~i;
meanA = zeros(size(meanA1));
meanB = zeros(size(meanB1));
meanC = zeros(size(meanC1));
meanD = zeros(size(meanD1));
meanE = zeros(size(meanE1));
meanF = zeros(size(meanF1));
meanG = zeros(size(meanG1));
meanH = zeros(size(meanH1));
for kk = 1:57
    
    if sum(i(:,kk))==0
        meanA(:,kk) = meanA2(:,kk);
        meanB(:,kk) = meanB2(:,kk);
        meanC(:,kk) = meanC2(:,kk);
        meanD(:,kk) = meanD2(:,kk);
        meanE(:,kk) = meanE2(:,kk);
        meanF(:,kk) = meanF2(:,kk);
        meanG(:,kk) = meanG2(:,kk);
        meanH(:,kk) = meanH2(:,kk) ;
    else 
        M = max(mean1(i(:,kk),kk));
        meanA(i(1,kk),kk) = meanA1(i(1,kk),kk);
        meanB(i(2,kk),kk) = meanB1(i(2,kk),kk);
        meanC(i(3,kk),kk) = meanC1(i(3,kk),kk);
        meanD(i(4,kk),kk) = meanD1(i(4,kk),kk);
        meanE(i(5,kk),kk) = meanE1(i(5,kk),kk);
        meanF(i(6,kk),kk) = meanF1(i(6,kk),kk);
        meanG(i(7,kk),kk) = meanG1(i(7,kk),kk);
        meanH(i(8,kk),kk) = meanH1(i(8,kk),kk) ;
        %%
        meanA(j(1,kk),kk) = M + meanA2(j(1,kk),kk);
        meanB(j(2,kk),kk) = M + meanB2(j(2,kk),kk);
        meanC(j(3,kk),kk) = M + meanC2(j(3,kk),kk);
        meanD(j(4,kk),kk) = M + meanD2(j(4,kk),kk);
        meanE(j(5,kk),kk) = M + meanE2(j(5,kk),kk);
        meanF(j(6,kk),kk) = M + meanF2(j(6,kk),kk);
        meanG(j(7,kk),kk) = M + meanG2(j(7,kk),kk);
        meanH(j(8,kk),kk) = M + meanH2(j(8,kk),kk) ;
    end
end
men = [meanA;meanB;meanC;meanD;meanE;meanF;meanG;meanH];
min_mean = min(men);
max_mean = max(men);
mx_mn_mean = max_mean-min_mean;
mx_mn_mean(mx_mn_mean == 0) = 1e-8;
meanA   = (meanA-min_mean)./(mx_mn_mean);
meanB   = (meanB-min_mean)./(mx_mn_mean);
meanC   = (meanC-min_mean)./(mx_mn_mean);
meanD   = (meanD-min_mean)./(mx_mn_mean);
meanE   = (meanE-min_mean)./(mx_mn_mean);
meanF   = (meanF-min_mean)./(mx_mn_mean);
meanG   = (meanG-min_mean)./(mx_mn_mean);
meanH   = (meanH-min_mean)./(mx_mn_mean);meanH(isnan(meanH)) = 1;
men = [meanA;meanB;meanC;meanD;meanE;meanF;meanG;meanH];
Score_mean = men*w;
%% median Solution
medA1 = A1(13,:);
medA2 = A2(13,:);
medB1 = B1(13,:);
medB2 = B2(13,:);
medC1 = C1(13,:);
medC2 = C2(13,:);
medD1 = D1(13,:);
medD2 = D2(13,:);
medE1 = E1(13,:);
medE2 = E2(13,:);
medF1 = F1(13,:);
medF2 = F2(13,:);
medG1 = G1(13,:);
medG2 = G2(13,:);
medH1 = H1(13,:);
medH2 = H2(13,:);
med1 = [medA1;medB1;medC1;medD1;medE1;medF1;medG1;medH1];
med2 = [medA2;medB2;medC2;medD2;medE2;medF2;medG2;medH2];
i = med2 == 0;
j = ~i;
medA = zeros(size(medA1));
medB = zeros(size(medB1));
medC = zeros(size(medC1));
medD = zeros(size(medD1));
medE = zeros(size(medE1));
medF = zeros(size(medF1));
medG = zeros(size(medG1));
medH = zeros(size(medH1));
for kk = 1:57
    
    if sum(i(:,kk))==0
        medA(:,kk) = medA2(:,kk);
        medB(:,kk) = medB2(:,kk);
        medC(:,kk) = medC2(:,kk);
        medD(:,kk) = medD2(:,kk);
        medE(:,kk) = medE2(:,kk);
        medF(:,kk) = medF2(:,kk);
        medG(:,kk) = medG2(:,kk);
        medH(:,kk) = medH2(:,kk) ;
    else 
        M = max(med1(i(:,kk),kk));
        medA(i(1,kk),kk) = medA1(i(1,kk),kk);
        medB(i(2,kk),kk) = medB1(i(2,kk),kk);
        medC(i(3,kk),kk) = medC1(i(3,kk),kk);
        medD(i(4,kk),kk) = medD1(i(4,kk),kk);
        medE(i(5,kk),kk) = medE1(i(5,kk),kk);
        medF(i(6,kk),kk) = medF1(i(6,kk),kk);
        medG(i(7,kk),kk) = medG1(i(7,kk),kk);
        medH(i(8,kk),kk) = medH1(i(8,kk),kk) ;
        %%
        medA(j(1,kk),kk) = M + medA2(j(1,kk),kk);
        medB(j(2,kk),kk) = M + medB2(j(2,kk),kk);
        medC(j(3,kk),kk) = M + medC2(j(3,kk),kk);
        medD(j(4,kk),kk) = M + medD2(j(4,kk),kk);
        medE(j(5,kk),kk) = M + medE2(j(5,kk),kk);
        medF(j(6,kk),kk) = M + medF2(j(6,kk),kk);
        medG(j(7,kk),kk) = M + medG2(j(7,kk),kk);
        medH(j(8,kk),kk) = M + medH2(j(8,kk),kk) ;
    end
end
med = [medA;medB;medC;medD;medE;medF;medG;medH];
min_med = min(med);
max_med = max(med);
mx_mn_med = max_med-min_med;
mx_mn_med(mx_mn_med == 0) = 1e-8;
medA   = (medA-min_med)./(mx_mn_med);
medB   = (medB-min_med)./(mx_mn_med);
medC   = (medC-min_med)./(mx_mn_med);
medD   = (medD-min_med)./(mx_mn_med);
medE   = (medE-min_med)./(mx_mn_med);
medF   = (medF-min_med)./(mx_mn_med);
medG   = (medG-min_med)./(mx_mn_med);
medH   = (medH-min_med)./(mx_mn_med);medH(isnan(medH)) = 1;
med = [medA;medB;medC;medD;medE;medF;medG;medH];
Score_med = med*w;
%% final score
Algorithm = ['E24594';'COM108';'COM109';'E24363';'E24586';'E24443';'E24191';'E24537'];
Total_Score = 0.5*Score_best+0.3*Score_mean+0.2*Score_med;
[~,ii] = sort(Total_Score); Rank(ii) = 1:8;
% Final_score = [Score_best,Score_mean,Score_med, 0.5*Score_best+0.3*Score_mean+0.2*Score_med]
disp('========================================================================');
disp('=====================Ranking of Algorithm on RWCOP======================');
disp('========================================================================');
fprintf('  Algorithm     Score1     Score2      Score3    Total Score    Rank\n');
for i = 1:8
    fprintf('%s %s %s %8.4f   %8.4f    %8.4f    %8.4f %s   %d\n',['   '], Algorithm(i,:), ['  '],  Score_best(i), Score_mean(i), Score_med(i), Total_Score(i), ['    '], Rank(i));
end
disp('========================================================================');
disp('========================================================================');
%% printing on text file
fileID = fopen('Scoring.txt','w');
fprintf(fileID,'========================================================================\n');
fprintf(fileID,'=====================Ranking of Algorithm on RWCOP======================\n');
fprintf(fileID,'========================================================================\n');
fprintf(fileID,'  Algorithm     Score1     Score2      Score3    Total Score    Rank\n');
for i = 1:8
    fprintf(fileID,'%s %s %s %8.4f   %8.4f    %8.4f    %8.4f %s   %d\n',['   '], Algorithm(i,:), ['  '],  Score_best(i), Score_mean(i), Score_med(i), Total_Score(i), ['    '], Rank(i));
end
fprintf(fileID,'========================================================================\n');
fprintf(fileID,'========================================================================\n');