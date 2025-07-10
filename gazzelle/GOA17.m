
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

function [Top_gazelle_fit,Top_gazelle_pos,Convergence_curve]=GOA17(SearchAgents_no,Max_iter,lb,ub,dim,fobj)
Total=SearchAgents_no;
SearchAgents_no=0.80*Total;

Top_gazelle_pos=zeros(1,dim);
%1 row , dim columns
% 0 0 0 
Top_gazelle_fit=inf;
%int_max

Convergence_curve=zeros(1,Max_iter);
stepsize=zeros(Total,dim);
fitness=inf(Total,1 );
%search agents jitti rows , 1 column 
%initially int_max

%predator=initialization(50-SearchAgents_no,dim,ub,lb);
gazelle=initialization(Total,dim,ub,lb);
%predator=rand(lb,ub);
%gazzelle initialised
  
Xmin=repmat(ones(1,dim).*lb,Total,1);
% search agent X dim
Xmax=repmat(ones(1,dim).*ub,Total,1);
%sabka upper bound
         

Iter=0;
PSRs=0.34;
S=0.88;
Spredator=1.15;
s=rand();
sPredator=rand();
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
     
 Elite=repmat(Top_gazelle_pos,Total,1);  %(Eq. 3) 
 CF=(1-Iter/Max_iter)^(2*Iter/Max_iter);
                             
 RL=0.05*levy(Total,dim,1.5);   %Levy random number vector
 RB=randn(Total,dim);          %Brownian random number vector
 mupredator=1;
 mu=1;


 ubsize=size(ub);
 %r=(ub-lb)/2*rand(); 
 %disp(r);
 count=0;
 
 gazelle_done=zeros(SearchAgents_no);
 predator_done=zeros(Total-SearchAgents_no);

 for i=1+SearchAgents_no:Total
     for k=1:SearchAgents_no
        %  if mu==mupredator
        %     mu=-mupredator;
        % end
        if mod(Iter,2)==0
               mu=1;
        else
              mu=-1;
        end
        R=rand();
        r=rand();
        if r>0.5
            for j=1:dim
                stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*gazelle(i,j));
                gazelle(i,j)=gazelle(i,j)+S*mu*R*stepsize(i,j);
                stepsize=(RL(i,j)*(RL(i,j)*gazelle(k,j)-gazelle(i,j)));
                gazelle(i,j)=Elite(i,j)+Spredator*R*stepsize;
           %str=func2str(fobj);
                if ubsize(1,2)>1
                    if gazelle(k,j)>ub(1,j)
                        gazelle(k,j)=ub(1,j);
                    end
                    if gazelle(k,j)<lb(1,j)
                        gazelle(k,j)=lb(1,j);
                    end
                else
                    if gazelle(k,j)>ub
                        gazelle(k,j)=ub;
                    end
                    if gazelle(k,j)<lb
                        gazelle(k,j)=lb;
                    end
                end
            end
            gazelle_done(1,k)=1;
            predator_done(1,i)=1;
            break;
        end
     end
     if predator_done(1,i-SearchAgents_no)==0
         for j=1:dim
             stepsize=(RB(i,j)*(RB(i,j)*gazelle(k,j)-gazelle(i,j)));
             gazelle(i,j)=Elite(i,j)+sPredator*R*stepsize; 
         end
     end
 end
 

for i=1:SearchAgents_no
    R=rand();
    if gazelle_done(1,i)==1
        continue
    else
        for j=1:dim
            stepsize(i,j)=RB(i,j)*(Elite(i,j)-RB(i,j)*gazelle(i,j));
            gazelle(i,j)=gazelle(i,j)+s*R*stepsize(i,j);
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
     U=rand(Total,dim)<PSRs;                                                                                              
     gazelle=gazelle+CF.*((Xmin+rand(Total,dim).*(Xmax-Xmin)).*U);

  else
     r=rand();  Rs=size(gazelle,1);
     stepsize=(PSRs*(1-r)+r)*(gazelle(randperm(Rs),:)-gazelle(randperm(Rs),:));
     gazelle=gazelle+stepsize;
  end
                                                        
  Iter=Iter+1;  
  Convergence_curve(Iter)=Top_gazelle_fit; 
       
end

