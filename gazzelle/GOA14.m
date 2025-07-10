
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

function [Top_gazelle_fit,Top_gazelle_pos,Convergence_curve]=GOA14(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

Top_gazelle_pos=zeros(1,dim);
%1 row , dim columns
% 0 0 0 
Top_gazelle_fit=inf;
%int_max
T=0;
Convergence_curve=zeros(1,Max_iter);
stepsize=zeros(SearchAgents_no,dim);
fitness=inf(SearchAgents_no,1 );
%search agents jitti rows , 1 column 
%initially int_max

predator=initialization(50-SearchAgents_no,dim,ub,lb);
gazelle=initialization(SearchAgents_no,dim,ub,lb);
%predator=rand(lb,ub);
%gazzelle initialised
  
Xmin=repmat(ones(1,dim).*lb,SearchAgents_no,1);
% search agent X dim
Xmax=repmat(ones(1,dim).*ub,SearchAgents_no,1);
%sabka upper bound
         

Iter=0;
PSRs=0.34;
S=0.88;
Spredator=1.15;
s=rand();
if ismatrix(ub)

else
    ub=ones(1,dim)*ub;
    lb=ones(1,dim)*lb;
end

while Iter<Max_iter    
     %------------------- Evaluating top gazelle -----------------    
 for i=1:size(gazelle,1)  
        
    Flag4ub=gazelle(i,:)>ub;
    Flag4lb=gazelle(i,:)<lb;    
    gazelle(i,:)=(gazelle(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;                    
        
    fitness(i,1)=fobj(gazelle(i,:));
    %har gazzelle ke liye fitness
     %compare with top gazzelle
     if fitness(i,1)<Top_gazelle_fit 
       Top_gazelle_fit=fitness(i,1); 
       Top_gazelle_pos=gazelle(i,:);
     end          
 end
     
     %------------------- Keeping tract of fitness values------------------- 
    
 if Iter==0
   fit_old=fitness;    Prey_old=gazelle;
 end
     
  Inx=(fit_old<fitness);
  Indx=repmat(Inx,1,dim);
  gazelle=Indx.*Prey_old+~Indx.*gazelle;
  fitness=Inx.*fit_old+~Inx.*fitness;
        
  fit_old=fitness;    Prey_old=gazelle;

     %------------------------------------------------------------   
     
 Elite=repmat(Top_gazelle_pos,SearchAgents_no,1);  %(Eq. 3) 
 CF=(1-Iter/Max_iter)^(2*Iter/Max_iter);
                             
 RL=0.05*levy(SearchAgents_no,dim,1.5);   %Levy random number vector
 RB=randn(SearchAgents_no,dim);          %Brownian random number vector
 mupredator=1;
 mu=1;


 ubsize=size(ub);
 %r=(ub-lb)/2*rand(); 
 %disp(r);
 count=0;

 if (mod(Iter, Max_iter/10) == 0)  % Reset T every 10% of iterations
    t = 0;
 end
 T = T + 1;

 gazelle_done=zeros(SearchAgents_no);
 predator_done=zeros(50-SearchAgents_no);
  distance_reqd=0;
 for i=1:size(gazelle,1)
     for j=1:size(predator,1)
         temp=norm(predator(j,:) - gazelle(i, :));
         distance_reqd=distance_reqd+norm(predator(j,:) - gazelle(i, :));
     end
 end
 distance_reqd=distance_reqd/(SearchAgents_no*(50-SearchAgents_no));
 for i=1:size(gazelle,1)
     if gazelle_done(1,i)==1
         continue;
     end
     for k=1:size(predator,1)
         if predator_done(1,k)==1
             continue;
         end
        %  if mu==mupredator
        %     mu=-mupredator;
        % end
        if mod(Iter,2)==0
               mu=1;
        else
              mu=-1;
        end 
        if mod(Iter,3)==0
            mupredator=mu;
        end
        temp=norm(predator(k,:) - gazelle(i, :));
        R=rand();
        if temp<distance_reqd*0.9
            for j=1:size(gazelle,2)
                stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*gazelle(i,j));
                %stepPredator=25+(35-25).*rand();
                stepPredator=RL(i,j)*(gazelle(i,j)-RL(i,j)*predator(k,j));
                predator(k,j)=predator(k,j)+mupredator*Spredator*R*RL(k,j)*stepPredator;
                gazelle(i,j)=gazelle(i,j)+S*mu*R*stepsize(i,j); 
           %str=func2str(fobj);
                if ubsize(1,2)>1
                    if predator(k,j)>ub(1,j)
                        predator(k,j)=ub(1,j);
                    end
                    if predator(k,j)<lb(1,j)
                        predator(k,j)=lb(1,j);
                    end
                else
                    if predator(k,j)>ub
                        predator(k,j)=ub;
                    end
                    if predator(k,j)<lb
                        predator(k,j)=lb;
                    end
                end
            end
            gazelle_done(1,i)=1;
            predator_done(1,k)=1;
            break;
        end
     end
 end
 

for i=1:size(gazelle,1)
    R=rand();
    if gazelle_done(1,i)==1
        continue
    else
        for j=1:size(gazelle,2)
            stepsize(i,j)=(Elite(i,j)-RB(i,j)*gazelle(i,j));                    
            gazelle(i,j)=gazelle(i,j)+s*R*RB(i,j)*stepsize(i,j);
           % mupredator=rand()>0.5;
           % stepPredator=25+(35-25).*rand();                 
           % predator(1,j)=predator(1,j)+(mupredator*Spredator*R*RB(i,j)*stepPredator);
        end
    end
end

for i=1:size(predator,1)
    R=rand();
    if predator_done(1,i)==1
        continue
    else
        for j=1:size(predator,2)
            % Select strategy based on hunting time and random values (r2, r3)
            R2 = rand();  % Random value between 0 and 1
            R3 = 0.25 + rand();  % Random value between 0.25 and 1.25

            if R2 <= R3
                % Search strategy (Equation (1) of COA)
                if rand() > 0.5 
                    stepPredator = RL(i,j)*(Elite(i,j)-RL(i,j)*predator(k,j)); % Search with Levy random number
                else
                    stepPredator = 0.0001*t/T*(ub-lb); % Search with base step length
                end
            else
                % Sit-and-Wait strategy (no update)
                stepPredator = 0;
            end
            predator(i,j)=predator(i,j)+stepPredator;
        end
    end
end




 
 %disp(count);
        
     %------------------ Updating top gazelle ------------------        
  for i=1:size(gazelle,1)  
        
    Flag4ub=gazelle(i,:)>ub;  
    Flag4lb=gazelle(i,:)<lb;  
    gazelle(i,:)=(gazelle(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
  
    fitness(i,1)=fobj(gazelle(i,:));
        
      if fitness(i,1)<Top_gazelle_fit 
         Top_gazelle_fit=fitness(i,1);
         Top_gazelle_pos=gazelle(i,:);
      end     
  end
        
     %---------------------- Updating history of fitness values ----------------
    
 if Iter==0
    fit_old=fitness;    Prey_old=gazelle;
 end
     
    Inx=(fit_old<fitness);
    Indx=repmat(Inx,1,dim);
    gazelle=Indx.*Prey_old+~Indx.*gazelle;
    fitness=Inx.*fit_old+~Inx.*fitness;
        
    fit_old=fitness;    Prey_old=gazelle;

     %---------- Applying PSRs ----------- 
                             
  if rand()<PSRs
     U=rand(SearchAgents_no,dim)<PSRs;                                                                                              
     gazelle=gazelle+CF*((Xmin+rand(SearchAgents_no,dim).*(Xmax-Xmin)).*U);

  else
     r=rand();  Rs=size(gazelle,1);
     stepsize=(PSRs*(1-r)+r)*(gazelle(randperm(Rs),:)-gazelle(randperm(Rs),:));
     gazelle=gazelle+stepsize;
  end
                                                        
  Iter=Iter+1;  
  Convergence_curve(Iter)=Top_gazelle_fit; 
       
end

