
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

function [Top_gazelle_fit,Top_gazelle_pos,Convergence_curve]=GOA8(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

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

 gazelle_done=zeros(1,SearchAgents_no);
 predator_done=zeros(1,50-SearchAgents_no);
predator=initialization(50-SearchAgents_no,dim,ub,lb);
gazelle=initialization(SearchAgents_no,dim,ub,lb);
attack_from_to=zeros(2,50-SearchAgents_no);
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

 distance_reqd=0;
 for i=1:size(gazelle,1)
     for j=1:size(predator,1)
         temp=norm(predator(j,:) - gazelle(i, :));
         distance_reqd=distance_reqd+norm(predator(j,:) - gazelle(i, :));
     end
 end
 distance_reqd=distance_reqd/(SearchAgents_no*(50-SearchAgents_no));


if Iter==0
    for i=1:size(gazelle,1)
        for k=1:size(predator,1)
            if predator_done(1,k)==1
                continue;
            end
        %  if mu==mupredator
        %     mu=-mupredator;
        % end
            if mod(Iter,2)==0
                   mu=1;
                   mupredator=mu;
            else
                  mu=-1;
                  mupredator=mu;
            end 
            if mod(Iter,3)==0
                mupredator=mu;
            end
            temp=norm(predator(k,:) - gazelle(i, :));
            if temp<distance_reqd*0.85
                R=rand();
                count=count+1;
                for j=1:size(gazelle,2)
                    stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*gazelle(i,j));
                    stepPredator=25+(35-25).*rand();
                    gazelle(i,j)=gazelle(i,j)+S*mu*R*stepsize(i,j); 
                %stepPredator=RL(i,j)*(Elite(i,j)-RL(i,j)*predator(k,j));
                    if gazelle(i,j)>predator(k,j)
                        predator(k,j)=predator(k,j)+abs(CF*Spredator*R*stepPredator);
                    else
                        predator(k,j)=predator(k,j)-abs(CF*Spredator*R*stepPredator);
                    end
                % predator(k,j)=predator(k,j)+mupredator*CF*Spredator*R*stepPredator;
                
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
                %if Iter==0
                attack_from_to(1,count)=k;
                attack_from_to(2,count)=i;
            %end
                break;
            end
        end
    end

 %disp(count);

else
    for i=1:count
        pindex=attack_from_to(1,i);
        gindex=attack_from_to(2,i);
        for j=1:size(gazelle,2)
                %disp(gindex);
                stepsize=RL(gindex,j)*(Elite(gindex,j)-RL(gindex,j)*gazelle(gindex,j));
                stepPredator=25+(35-25).*rand();
                gazelle(gindex,j)=gazelle(gindex,j)+S*mu*R*stepsize; 
                %stepPredator=RL(i,j)*(Elite(i,j)-RL(i,j)*predator(k,j));
                if gazelle(gindex,j)>predator(pindex,j)
                    predator(pindex,j)=predator(pindex,j)+abs(CF*Spredator*R*stepPredator);
                else
                    predator(pindex,j)=predator(pindex,j)-abs(CF*Spredator*R*stepPredator);
                end
                % predator(k,j)=predator(k,j)+mupredator*CF*Spredator*R*stepPredator;
                
           %str=func2str(fobj);
                if ubsize(1,2)>1
                    if predator(pindex,j)>ub(1,j)
                        predator(pindex,j)=ub(1,j);
                    end
                    if predator(pindex,j)<lb(1,j)
                        predator(pindex,j)=lb(1,j);
                    end
                else
                    if predator(pindex,j)>ub
                        predator(pindex,j)=ub;
                    end
                    if predator(pindex,j)<lb
                        predator(pindex,j)=lb;
                    end
                end
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
            stepPredator=25+(35-25).*rand();
            % stepPredator=RL(i,j)*(Elite(i,j)-RL(i,j)*predator(i,j));
            predator(i,j)=predator(i,j)+mupredator*CF*Spredator*R*stepPredator;
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
                             
   for i=1:count
        pindex=attack_from_to(1,i);
        gindex=attack_from_to(2,i);
        for j=1:size(gazelle,2)
                %disp(gindex);
            if norm(predator(pindex,j)-gazelle(gindex,j))<1
                gazelle(gindex,j)=gazelle(gindex,j)+CF*((Xmin(gindex,j)+rand().*(Xmax(gindex,j)-Xmin(gindex,j))).*1);
            %end
            else
                % r=rand();
                % stepsize=(PSRs*(1-r)+r)*(gazelle(randperm(Rs),:)-gazelle(randperm(Rs),:));
                % gazelle=gazelle+stepsize;
            end
        end
    end

  for i=1:size(gazelle,1)
     if gazelle_done(1,i)==1
         continue;
     end
     r=rand();  Rs=size(gazelle,1);
     stepsize=(PSRs*(1-r)+r)*(gazelle(randperm(Rs),:)-gazelle(randperm(Rs),:));
     gazelle=gazelle+stepsize;
  end
                                                        
  Iter=Iter+1;  
  Convergence_curve(Iter)=Top_gazelle_fit; 
       
end

