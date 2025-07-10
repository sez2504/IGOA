
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

function [Top_gazelle_fit,Top_gazelle_pos,Convergence_curve]=GOA10(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

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
predator=initialization(50-SearchAgents_no,dim,ub,lb);
%predator=rand(lb,ub);
%gazzelle initialised
  
Xmin=repmat(ones(1,dim).*lb,SearchAgents_no,1);
% search agent X dim
Xmax=repmat(ones(1,dim).*ub,SearchAgents_no,1);

Xminp=repmat(ones(1,dim).*lb,50-SearchAgents_no,1);
% search agent X dim
Xmaxp=repmat(ones(1,dim).*ub,50-SearchAgents_no,1);
%sabka upper bound
         

Iter=0;
PSRs=0.34;
S=0.88;
Spredator=1.15;
sPredator=rand();
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
   fit_old=fitness;    Prey_old=gazelle; Predator_old=predator;
 end
     
  Inx=(fit_old<fitness);
  Indx=repmat(Inx,1,dim);
  gazelle=Indx.*Prey_old+~Indx.*gazelle;
  fitness=Inx.*fit_old+~Inx.*fitness;
        
  fit_old=fitness;    Prey_old=gazelle; predator=Predator_old;

     %------------------------------------------------------------   
     
 Elite=repmat(Top_gazelle_pos,SearchAgents_no,1);  %(Eq. 3) 
 CF=(1-Iter/Max_iter)^(2*Iter/Max_iter);
                             
 RL=0.05*levy(SearchAgents_no,dim,1.5);   %Levy random number vector
 RB=randn(SearchAgents_no,dim);%Brownian random number vector
 % for i=1:size(gazelle,1)
 %     for j=1:size(gazelle,2)
 %       R=rand();
 %       r=rand();
 %       xo=0;
 %       gamma=1;
 %       randomwalk=xo+gamma*tan(pi*(r-0.5)); 
 %       randomwalk=sin(randomwalk);
 %       RB(i,j)=randomwalk;
 %     end
 % end
 mupredator=1;
 mu=1;
 

 ubsize=size(ub);
 %r=(ub-lb)/2*rand(); 
 %disp(r);
 count=0;
 
 gazelle_done=zeros(SearchAgents_no);
  distance_reqd=0;
 for i=1:size(gazelle,1)
     for j=1:size(predator,1)
         temp=norm(predator(j,:) - gazelle(i, :));
         distance_reqd=distance_reqd+norm(predator(j,:) - gazelle(i, :));
     end
 end
 distance_reqd=distance_reqd/(SearchAgents_no*(50-SearchAgents_no));
 for i=1:size(gazelle,1)
     
     for k=1:size(predator,1)
        %  if mu==mupredator
        %     mu=-mupredator;
        % end
        R=rand();
        if mod(Iter,2)==0
               mu=1;
        else
              mu=-1;
        end 
        if mod(Iter,3)==0
            mupredator=mu;
        end
        temp=norm(predator(k,:) - gazelle(i, :));
        if temp<distance_reqd
            count=count+1;
            for j=1:size(gazelle,2)
                stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*gazelle(i,j));
                %stepPredator=25+(35-25).*rand();
                stepPredator=RL(i,j)*(Elite(i,j)-RL(i,j)*predator(k,j));
                predator(k,j)=predator(k,j)+mupredator*Spredator*R*stepPredator;
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
        else 
          for j=1:size(gazelle,2)
              stepsize(i,j)=(Elite(i,j)-RB(i,j)*gazelle(i,j));                    
              gazelle(i,j)=gazelle(i,j)+s*R*RB(i,j)*stepsize(i,j);
              %stepsize(i,j)=abs(stepsize(i,j));
              % stepPredator=25+(35-25).*rand();
              stepPredator=RB(i,j)*(Elite(i,j)-RL(i,j)*predator(k,j));
              predator(k,j)=predator(k,j)+sPredator*R*stepPredator;
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
    Predator_old=predator;
    fit_old=fitness;    Prey_old=gazelle;

     %---------- Applying PSRs ----------- 
                             
   if rand()<PSRs
      U=rand(SearchAgents_no,dim)<PSRs; 
      % UP=rand(50-SearchAgents_no,dim)<PSRs;
      gazelle=gazelle+CF*((Xmin+rand(SearchAgents_no,dim).*(Xmax-Xmin)).*U);
      % predator=predator+((Xminp+rand(50-SearchAgents_no,dim).*(Xmaxp-Xminp)).*UP);
   else
      r=rand();  Rs=size(gazelle,1);
      Rsp=size(predator,1);
      stepsize=(PSRs*(1-r)+r)*(gazelle(randperm(Rs),:)-gazelle(randperm(Rs),:));
      gazelle=gazelle+stepsize;
      stepsizeP=(PSRs*(1-r)+r)*(predator(randperm(Rsp),:)-predator(randperm(Rsp),:));
      % predator=predator+stepsizeP;
   end
                                                        
  Iter=Iter+1;  
  Convergence_curve(Iter)=Top_gazelle_fit; 
       
end