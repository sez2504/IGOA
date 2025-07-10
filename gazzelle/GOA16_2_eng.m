
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

function [Top_gazelle_fit,Top_gazelle_pos,Convergence_curve]=GOA16_2_eng(SearchAgents_no,Max_iter,lb,ub,dim,fobj,VioFactor)
%numWorkers = gcp('KnowWorkers');
%pool = parpool(8);

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


gazelle=initialization(Total,dim,ub,lb);
indices = randperm(Total, Total-SearchAgents_no);


% Convert row and column indices to linear indices

% predator=initialization(50-SearchAgents_no,dim,ub,lb);
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
sPredator=rand();
s=rand();

while Iter<Max_iter    
     %------------------- Evaluating top gazelle -----------------    
 for i=1:size(gazelle,1)  
        
    Flag4ub=gazelle(i,:)>ub;
    Flag4lb=gazelle(i,:)<lb;    
    gazelle(i,:)=(gazelle(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;                    
        
    [fitness(i,1),g,h]=fobj(gazelle(i,:));
    v = sum(VioFactor.*max(0,[g h]));
    fitness(i,1) = fitness(i,1) + v;
    %har gazzelle ke liye fitness
     %compare with top gazzelle
     if fitness(i,1)<Top_gazelle_fit 
       Top_gazelle_fit=fitness(i,1); 
       Top_gazelle_pos=gazelle(i,:);
     end          
 end

 % for i=1:size(predator,1)  
 % 
 %    Flag4ub=predator(i,:)>ub;
 %    Flag4lb=predator(i,:)<lb;    
 %    predator(i,:)=(predator(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;                    
 % 
 %    fitness(i+SearchAgents_no,1)=fobj(predator(i,:));
 %    %har gazzelle ke liye fitness
 %     %compare with top gazzelle
 %     if fitness(i+SearchAgents_no,1)<Top_gazelle_fit 
 %       Top_gazelle_fit=fitness(i+SearchAgents_no,1); 
 %       Top_gazelle_pos=predator(i,:);
 %     end          
 % end
     
     %------------------- Keeping tract of fitness values------------------- 
    
 if Iter==0
   fit_old=fitness;    Prey_old=gazelle;
   % Predator_old=predator;
 end
     
  
  Inx=(fit_old<fitness);
  Indx=repmat(Inx,1,dim);
  gazelle=Indx.*Prey_old+~Indx.*gazelle;
  fitness=Inx.*fit_old+~Inx.*fitness;
  
%   for i = SearchAgents_no+1:50
%     Inx=(fit_old(i,:)<fitness(i,:));
%     Indx=repmat(Inx,1,dim);
%     predator=Indx.*Predator_old(i-SearchAgents_no,:)+~Indx.*predator;
%     fitness(i,:)=Inx.*fit_old(i,:)+~Inx.*fitness(i,:);
% end
        
  fit_old=fitness;    Prey_old=gazelle;
  % Predator_old=predator;

     %------------------------------------------------------------   
     
 Elite=repmat(Top_gazelle_pos,Total,1);  %(Eq. 3) 
 CF=(1-Iter/Max_iter)^(2*Iter/Max_iter);
                             
 RL=0.05*levy(Total,dim,1.5);   %Levy random number vector
 RB=randn(Total,dim);%Brownian random number vector
  % for i=1:size(gazelle,1)
  %      for j=1:size(gazelle,2)
  %        R=rand();
  %        r=rand();
  %        xo=0;
  %        gamma=1;
  %        randomwalk=xo+gamma*tan(pi*(r-0.5)); 
  %        randomwalk=sin(randomwalk);
  %        RL(i,j)=randomwalk*RL(i,j);
  %      end
  %  end
 mupredator=1;
 mu=1;


 ubsize=size(ub);
 %r=(ub-lb)/2*rand(); 
 %disp(r);
 count=0;
 count2=0;
 gazelle_done=zeros(SearchAgents_no);


     for i = 1:size(gazelle,1)
            R=rand();
            if mod(Iter,2)==0
                   mu=1;
            else
                  mu=-1;
            end 
        ispresent=false;
        for l=1:size(indices,2)
            if indices(1,l)==i
                ispresent=true;
                break;
            end
        end
        if ispresent==true
            for j=1:size(gazelle,2)
                for k=1:size(gazelle,1)
                    r=rand();
                    if(r>0.5)
                        ispresent=false;
                        for l=1:size(indices,2)
                            if indices(1,l)==k
                                ispresent=true;
                                break;
                            end
                        end
                        if ispresent==false
                            stepsize=sign(RL(i,j)*(RL(i,j)*gazelle(k,j)-gazelle(i,j)));
                            gazelle(i,j)=Elite(i,j)+Spredator*R*stepsize; 
  
                        end
                        % else
                        %     stepsize=sign(RL(i,j)*(Elite(i,j)-RL(i,j)*gazelle(i,j)));
                        %     gazelle(i,j)=gazelle(i,j)+Spredator*R*stepsize;  
                        % end
                    else
                        ispresent=false;
                        for l=1:size(indices,2)
                            if indices(1,l)==k
                                ispresent=true;
                                break;
                            end
                        end
                        if ispresent==false
                            stepsize=sign(RB(i,j)*(RB(i,j)*gazelle(k,j)-gazelle(i,j)));
                            gazelle(i,j)=Elite(i,j)+sPredator*R*stepsize;  
                            
                          
                        % else
                        %     stepsize=sign(RB(i,j)*(Elite(i,j)-RB(i,j)*gazelle(i,j)));
                        %     gazelle(i,j)=gazelle(i,j)+sPredator*R*stepsize;  
                        % end  
                        end
                    end

                end
            end
        else
    
            for j = 1:size(gazelle,2)
                r=rand();
                if(r>0.5)
                    
                    stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*gazelle(i,j));
                    gazelle(i,j)=gazelle(i,j)+S*mu*R*stepsize(i,j);
                 

                else
                    stepsize(i,j)=RB(i,j)*(Elite(i,j)-RB(i,j)*gazelle(i,j));
                    gazelle(i,j)=gazelle(i,j)+s*R*stepsize(i,j);
                  
                end
            end
        end
     end      

     %------------------ Updating top gazelle ------------------        
  for i=1:size(gazelle,1)  
        
    Flag4ub=gazelle(i,:)>ub;  
    Flag4lb=gazelle(i,:)<lb;  
    gazelle(i,:)=(gazelle(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
  
    [fitness(i,1),g,h]=fobj(gazelle(i,:));
    v = sum(VioFactor.*max(0,[g h]));
    fitness(i,1) = fitness(i,1) + v;    
      if fitness(i,1)<Top_gazelle_fit 
         Top_gazelle_fit=fitness(i,1);
         Top_gazelle_pos=gazelle(i,:);
      end     
  end
 %   for i=1:size(predator,1)  
 % 
 %    Flag4ub=predator(i,:)>ub;
 %    Flag4lb=predator(i,:)<lb;    
 %    predator(i,:)=(predator(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;                    
 % 
 %    fitness(i+SearchAgents_no,1)=fobj(predator(i,:));
 %    %har gazzelle ke liye fitness
 %     %compare with top gazzelle
 %     if fitness(i+SearchAgents_no,1)<Top_gazelle_fit 
 %       Top_gazelle_fit=fitness(i+SearchAgents_no,1); 
 %       Top_gazelle_pos=predator(i,:);
 %     end          
 % end
        
     %---------------------- Updating history of fitness values ----------------
    
 if Iter==0
    fit_old=fitness;    Prey_old=gazelle;
    % Predator_old=predator;
 end
     
  Inx=(fit_old<fitness);
  Indx=repmat(Inx,1,dim);
  gazelle=Indx.*Prey_old+~Indx.*gazelle;
  fitness=Inx.*fit_old+~Inx.*fitness;
%   for i = SearchAgents_no+1:50
%     Inx=(fit_old(i,:)<fitness(i,:));
%     Indx=repmat(Inx,1,dim);
%     predator=Indx.*Predator_old(i-SearchAgents_no,:)+~Indx.*predator;
%     fitness(i,:)=Inx.*fit_old(i,:)+~Inx.*fitness(i,:);
% end
        
    fit_old=fitness;    Prey_old=gazelle;
    % Predator_old=predator;
     %---------- Applying PSRs ----------- 
  % probab=count*0.34/(count+count2*0.66);                      
  if rand()<PSRs
     U=rand(Total,dim)<PSRs;                                                                                              
     gazelle=gazelle+CF*((Xmin+rand(Total,dim).*(Xmax-Xmin)).*U);

  else
     r=rand();  Rs=size(gazelle,1);
     stepsize=(PSRs*(1-r)+r)*(gazelle(randperm(Rs),:)-gazelle(randperm(Rs),:));
     gazelle=gazelle+stepsize;
  end
                                                        
  Iter=Iter+1;  
  Convergence_curve(Iter)=Top_gazelle_fit; 
%delete (pool);       
end
%delete (pool);  

