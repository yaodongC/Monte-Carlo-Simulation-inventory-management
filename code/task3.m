%% find the optimal choice from order 0-6 and threshold 0-6,
clear all
%% initialize varibles
N=52;
demand=zeros(1,N);
holds=zeros(7,7);
runCount=1000;
optOrder=zeros(1,runCount);
optBreakPoint=zeros(1,runCount);
cost=zeros(7,7);
orderIndex=1;
breakpointIndex=1;
probabiltyCombin=zeros(1,49);
choiceOp=zeros(1,49);
costHistogram=zeros(runCount,49);
inventoryWeekly=zeros(49,52);
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
choiceOp(1,(7*(row(ii)-1)+column(ii)))=choiceOp(1,(7*(row(ii)-1)+column(ii)))+1;
end
%% converte cost set from 2 choice to combination
  for i1=1:7
      for i2=1:7
          costHistogram(j,7*(i1-1)+i2)=cost(i1,i2);
      end
  end
end
%% calculate the possibility of each choice
for i4=1:49
    probabiltyCombin(1,i4)=choiceOp(1,i4)/breakpointIndex;
end

%% plot Histogram  of optimal order number and re-order threshold
histogram(optBreakPoint);
hold on
mean(optOrder)
mean(optBreakPoint)
std(optOrder)
std(optBreakPoint)
histogram(optOrder);
title('Histogram of optimal order number and re-order threshold')
xlabel('order number/re-order threshold ')
ylabel('number of instance')
txt1 = ['The mean of order number is ',num2str(mean(optOrder))];
txt11 = ['The variance of order number is ',num2str(std(optOrder))];
txt2 = ['The mean of re-order threshold is ',num2str(mean(optBreakPoint))];
txt22 = ['The variance of re-order threshold is ',num2str(std(optBreakPoint))];
text(4,0.8*runCount,txt1,'FontSize',14)
text(4,0.7*runCount,txt2,'FontSize',14)
text(4,0.6*runCount,txt11,'FontSize',14)
text(4,0.5*runCount,txt22,'FontSize',14)
legend('re-order threshold','order number')
hold off
%% plot Histogram of optimal combination of order number and re-order threshold
figure()
bar(choiceOp);
title('Histogram of optimal combination')
xlabel('combination of order number and re-order threshold ')
ylabel('number of instance')
%% plot distribution of total cost of every combination
figure()
hold on
for i3=1:49
histogram(costHistogram(:,i3));
end
hold off
title('distribution of total cost of every combination')
xlabel('total cost')
ylabel('number of instance')
%% plot box plot of total cost
figure()
boxplot(costHistogram);
title('box plot of total cost ')
xlabel('combination')
ylabel('total cost')
%% plot weekly inventory change of all combinations
figure()
hold on
for i=1:49
plot(inventoryWeekly(i,:)')
end
hold off
title('weekly inventory change of all combinations')
xlabel('week ')
ylabel('number of stock left')
%% plot weekly inventory change of order number 3 re-order level 1
figure()
plot(inventoryWeekly(23,:)')
title('weekly inventory change of the optimal combination')
xlabel('week ')
ylabel('number of stock left')
