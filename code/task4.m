%% find the optimal choice from order 0-6 and threshold 0-6,
clear all
%% initialize varibles
N=52;
demand=zeros(1,N);
holds=zeros(7,7);
runCount=50;
runCount2=1000;
optOrder=zeros(1,runCount);
optBreakPoint=zeros(1,runCount);
cost=zeros(7,7);
orderIndex=1;
breakpointIndex=1;
probabiltyCombin=zeros(1,49);
choiceOp=zeros(runCount2,49);
costHistogram=zeros(runCount,49);
costMean=zeros(runCount2,49);
inventoryWeekly=zeros(49,52);
lowerBoun=zeros(1,49);
higherBound=zeros(1,49);
possibleOptimal=zeros(2,49);
for k=1:runCount2
 costHistogram2=zeros(1,49);
%% repeat 5000 times
for j=1:runCount
cost=zeros(7,7);
%% generate 52 week demand
  demand=demandWeekly(N);
for i=1:N
%% go through every combination   
%% find the optimal choice from order 0-6 and threshold 0-6
for order=0:6
    for breakPoint=0:6
%% import apple
if holds(order+1,breakPoint+1)<=breakPoint
    holds(order+1,breakPoint+1)=holds(order+1,breakPoint+1)+order;
end
%% weekly consume and shortage cost
if holds(order+1,breakPoint+1)>=demand(1,i)
   holds(order+1,breakPoint+1)=holds(order+1,breakPoint+1)-demand(1,i);
else 
    cost(order+1,breakPoint+1)=cost(order+1,breakPoint+1)+20;
    holds(order+1,breakPoint+1)=0;
end
%% holding cost
if holds(order+1,breakPoint+1)>0
    cost(order+1,breakPoint+1)=cost(order+1,breakPoint+1)+holds(order+1,breakPoint+1)*5;
end
inventoryWeekly(7*order+breakPoint+1,i)=holds(order+1,breakPoint+1);
    end
    end
end
%% find the minimum cost and the combinations lead to it
cost(order+1,breakPoint+1)=cost(order+1,breakPoint+1)+holds(order+1,breakPoint+1)*10;
m=min(cost);
mm=min(m);
[row,column]=find(cost==mm);
%% produce optimal combination set
for ii=1:length(row)
optOrder(1,orderIndex)=row(ii)-1;
orderIndex=orderIndex+1;
optBreakPoint(1,breakpointIndex)=column(ii)-1;
breakpointIndex=breakpointIndex+1;
choiceOp(k,(7*(row(ii)-1)+column(ii)))=choiceOp(k,(7*(row(ii)-1)+column(ii)))+1;
end
%% converte cost set from 2 choice to combination
  for i1=1:7
      for i2=1:7
          costHistogram(j,7*(i1-1)+i2)=cost(i1,i2);
          costHistogram2(1,7*(i1-1)+i2)=cost(i1,i2)+costHistogram2(1,7*(i1-1)+i2);
      end
  end
end
costMean(k,:)=costHistogram2/runCount;
end
%% calculate the possibility of each choice
for j=1:runCount2
for i4=1:49
    probabiltyCombin(j,i4)=choiceOp(j,i4)/breakpointIndex*runCount2;
end
end
figure()
histogram(probabiltyCombin(:,23))
title('Histogram of probability of total cost of optimal combination')
xlabel('probability')
ylabel('number of instance')


%%
aaaa=0;
for i=1:runCount2
  %CombinOpt(i)=find(choiceOp(i,:)==max(choiceOp(i,:)))
  if find(choiceOp(i,:)==max(choiceOp(i,:)))~=23
      aaaa=aaaa+1
  end
end
%% find low and high bound of cost for every combination
for i=1:49
    lowerBound(1,i)=min(costMean(:,i))
    higherBound(1,i)=max(costMean(:,i))
end
%compare the lowest bound of other combination to the high bound of optimal
%combination
for i=1:49
    if i~=23
       if lowerBound(1,i)<= higherBound(1,23)
           possibleOptimal(1,i)=lowerBound(1,i);
           possibleOptimal(2,i)=higherBound(1,23)-lowerBound(1,i);
       end
    end  
end
%% plot distribution of total cost of possible optimal combination
a=find(possibleOptimal(1,:)~=0)
figure()
hold on
histogram(costMean(:,23));
meanCost = mean(costMean(:,23))
variance = std(costMean(:,23))
for i3=1:length(a)
histogram(costMean(:,a(i3)));
end
hold off
title('distribution of total cost of possible optimal combination')
xlabel('total cost')
ylabel('number of instance')
legend('combination (3,1)','combination (3,1)')
%% plot box plot of total cost with N times experiment
figure()
boxplot(costMean);
title(['box plot of total cost with ',num2str(runCount),' times experiment'])
xlabel('combination of order number and re-order stock level')
ylabel('total cost')
%% plot box plot of total cost
figure()
boxplot(costHistogram);
title('box plot of total cost ')
xlabel('combination')
ylabel('total cost')