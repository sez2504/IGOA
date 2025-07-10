
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

function [Top_gazelle_fit,Top_gazelle_pos,Convergence_curve]=GOA6(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

SearchAgents_no=SearchAgents_no-1;

Top_gazelle_pos=zeros(1,dim);
%1 row , dim columns
% 0 0 0 
Top_gazelle_fit=inf;
%int_max

Convergence_curve=zeros(1,Max_iter);
stepsize=zeros(SearchAgents_no,dim);
fitness=inf(SearchAgents_no,1 );
%search agents jitti rows , 1 column 
%initially int_max


gazelle=initialization(SearchAgents_no,dim,ub,lb);
%predator=rand(1,dim).*(ub-lb)+lb;
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
 predator=lb+(ub-lb).*rand(1,dim);
  for i=1:size(gazelle,1) %har row
      R=rand();
      if mu==mupredator
          mu=-mupredator;
      end
      % if mod(Iter,2)==0
      %       mu=1;
      %  else
      %      mu=-1;
      % end 
      if mod(Iter,3)==0
          mupredator=mu;
      end
      %predator=predator+mupredator*Spredator*R*10;
     for j=1:size(gazelle,2)   %har col      
       R=rand();
       r=rand();   
       %if direction>0.5 %direction
       % if mod(i,2)==0
       %       mu=-1;
       % else
       %       mu=1;
       % end
          %------------------ Exploitation ------------------- 
       if abs(predator(1,j)-gazelle(i,j))>20 
          stepsize(i,j)=(Elite(i,j)-RB(i,j)*gazelle(i,j));                    
          gazelle(i,j)=gazelle(i,j)+s*R*RB(i,j)*stepsize(i,j);
          stepPredator=25+(35-25).*rand();
          %disp(s*R*RB(i,j)*stepsize(i,j));
          if gazelle(i,j)>predator(1,j)
               predator(1,j)=predator(1,j)+abs(mupredator*Spredator*R*RB(i,j)*stepPredator);
          else
              predator(1,j)=predator(1,j)-abs(mupredator*Spredator*R*RB(i,j)*stepPredator);
          end
          if predator(1,j)>ub 
              predator(1,j)=ub;
          end
          if predator(1,j)<lb
              predator(1,j)=lb;
          end
          
          %--------------- Exploration----------------
       else
           stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*gazelle(i,j));
           stepPredator=25+(35-25).*rand();
           predator(1,j)=predator(1,j)+mupredator*Spredator*R*RL(i,j)*stepPredator;
           gazelle(i,j)=gazelle(i,j)+S*mu*R*stepsize(i,j); 
           if predator(1,j)>ub
              predator(1,j)=ub;
          end
          if predator(1,j)<lb
              predator(1,j)=lb;
          end
          
         %if i>size(gazelle,1)/2
          
         % if mod(i,2)==0
         %    stepsize(i,j)=RB(i,j)*(RL(i,j)*Elite(i,j)-gazelle(i,j));
         %    gazelle(i,j)=Elite(i,j)+S*mu*CF*stepsize(i,j); 
         % else
         %    stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*gazelle(i,j));                     
         %    gazelle(i,j)=gazelle(i,j)+S*mu*R*stepsize(i,j);  
         % end  
         
          
       end  
      end                                         
  end    
        
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

