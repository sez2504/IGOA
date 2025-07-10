% clear all
% mex cec14_func.cpp -DWINDOWS
% func_num=1;
% D=10;
% Xmin=-100;
% Xmax=100;
% pop_size=100;
% iter_max=5000;
% runs=1;
% fhd=str2func('cec14_func');
% for i=24:24
%     func_num=i;
%     for j=1:runs
%         i,j,
%         [gbest,gbestval,FES]= GOA3(fhd,D,pop_size,iter_max,Xmin,Xmax,func_num);
%         xbest(j,:)=gbest;
%         fbest(i,j)=gbestval;
%         fbest(i,j)
%     end
%     f_mean(i)=mean(fbest(i,:));
% end



% for i=1:30
% eval(['load input_data/shift_data_' num2str(i) '.txt']);
% eval(['O=shift_data_' num2str(i) '(1:10);']);
% f(i)=cec14_func(O',i);i,f(i)
% end



%_________________________________________________________________________
% Gazelle Optimization Algorithm source code 
%
%  
% paper:
% Jeffrey O. Agushaka, Absalom E. Ezugwu and Laith Abualigah
% Gazelle Optimization Algorithm: A Nature-inspired Metaheuristic
%  
%  
% E-mails: 218088307@stu.ukzn.ac.za            Jeffrey O. Agushaka 
%           ezugwuA@ukzn.ac.za                 Absalom E. Ezugwu
%           aligah@ammanu.edu.jo               Laith Abualigah
%_________________________________________________________________________

clear all
clc
format long
SearchAgents_no=50; % Number of search agents

Function_name='F2';
func_num=2;
runs=1;
Max_iteration=1000; % Maximum number of iterations
fhd=str2func('cec14_func');
%[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
lb=-100;
ub=100;
dim=50;

  % for i=24:24
  %     %func_num=i;
  %       for j=1:runs
  %       j,
  %       [gbest,gbestval,FES]= GOA3(fhd,dim,SearchAgents_no,Max_iteration,lb,ub,func_num);
  %       xbest(j,:)=gbest;
  %           %fbest(i,j)=gbestval;
  %           %fbest(i,j)
  %       end
  %     %f_mean(i)=mean(fbest(i,:));
  % end

%[Best_score,Best_pos,Convergence_curve]=GOA3(fhd,dim,SearchAgents_no,Max_iteration,lb,ub,func_num);

 for i=1:30
 eval(['load input_data/shift_data_' num2str(i) '.txt']);
 eval(['O=shift_data_' num2str(i) '(1:10);']);
 f(i)=cec14_func(O',i);i,f(i)
 end

[Best_score,Best_pos,Convergence_curve]=GOA3(fhd,dim,SearchAgents_no,Max_iteration,lb,ub,func_num);

% function topology
figure('Position',[500 400 700 290])
subplot(1,2,1);
func_plot(Function_name);
title('Function Topology')
xlabel('x_1');
ylabel('x_2');
zlabel([Function_name,'( x_1 , x_2 )'])

% Convergence curve
subplot(1,2,2);
semilogy(Convergence_curve,'Color','r')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');


display(['The best solution obtained by GOA is : ', num2str(Best_pos,10)]);
display(['The best optimal value of the objective function found by GOA is : ', num2str(Best_score,10)]);

disp(sprintf('--------------------------------------'));
