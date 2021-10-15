clear all
close all
clc
load('results.mat')
[a,b]=size(results);
n=0;
for i=1:a
   Bb=[];
   Sc=[];
   La=[];  
 [c,d]=size(results.Boxes{i});
  if c > 3
     z=string(results.Labels{i});
     [hr,f]=size(find(strcmp(z,'H_R')));
     [hl,f]=size(find(strcmp(z,'H_L')));
     [he,f]=size(find(strcmp(z,'He')));
     for j=1:c
         if (results.Labels{i}(j) == 'H_R')
             if hr ==1
               Bb=[Bb;results.Boxes{i,1}(j,:)];
               Sc=[Sc;results.Scores{i}(j)];
               La=[La;results.Labels{i}(j)]; 
             else if hr > 1
                     g=find(strcmp(z,'H_R'));
                     max=0;
                     for l=1: hr
                         if (results.Scores{i}(g(l))> max
                            max=results.Scores{i}(g(l));
                         end
                     end
                     m=find(results.Scores{i}==max);
                     Bb=[Bb;results.Boxes{i,1}(m,:)];
                     Sc=[Sc;results.Scores{i}(m)];
                     La=[La;results.Labels{i}(m)];
                     
                 end
               end
         end
         if (results.Labels{i}(j) == 'H_L')
             if hl ==1
               Bb=[Bb;results.Boxes{i,1}(j,:)];
               Sc=[Sc;results.Scores{i}(j)];
               La=[La;results.Labels{i}(j)]; 
             else if hl > 1
                     g=find(strcmp(z,'H_L'));
                     max=0;
                     for l=1: hl
                         if results.Scores{i}(g(l))> max
                            max=results.Scores{i}(g(l));
                         end
                     end
                     m=find(results.Scores{i}==max);
                     Bb=[Bb;results.Boxes{i,1}(m,:)];
                     Sc=[Sc;results.Scores{i}(m)];
                     La=[La;results.Labels{i}(m)];
                     
                 end
               end
         end
               if (results.Labels{i}(j) == 'He')
             if he ==1
               Bb=[Bb;results.Boxes{i,1}(j,:)];
               Sc=[Sc;results.Scores{i}(j)];
               La=[La;results.Labels{i}(j)]; 
             else if he > 1
                     g=find(strcmp(z,'He'));
                     max=0;
                     for l=1: he
                         if results.Scores{i}(g(l))> max
                            max=results.Scores{i}(g(l));
                         end
                     end
                     m=find(results.Scores{i}==max);
                     Bb=[Bb;results.Boxes{i,1}(m,:)];
                     Sc=[Sc;results.Scores{i}(m)];
                     La=[La;results.Labels{i}(m)];
                     
                 end
               end
         end   
     end
     
     
      res(i).Boxes =Bb;
     res(i).Scores=Sc;
     res(i).Labels=La;
     
  else
     res(i).Boxes =results.Boxes{i};
     res(i).Scores=results.Scores{i};
     res(i).Labels=results.Labels{i};
  end
end

ress=struct2table(res);
save('ress','ress')