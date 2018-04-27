clear all
%% variable initialize
N=52;
demand=zeros(1,N);
breakPoint=1;
runCount=500;
Ave=0;
cost=zeros(1,runCount);
%% choose a combination of order number and re-order level
holds=0;
order=3;
%% 500 time experiments 
for j=1:runCount
 %% generate 52 week demand
  demand=demandWeekly(N);
for i=1:N
%% import apple
 %fprintf('********************当前周数为%d周***********************\n',i)
 %fprintf('本周需求数为%d个\n',demand(1,i))
if holds<=breakPoint
    holds=holds+order;
    %fprintf('上周末进货之后库存为%d个\n',holds)
end

%% weekly consume and shortage cost
if holds>=demand(1,i)
   holds=holds-demand(1,i);
else 
    cost(1,j)=cost(1,j)+20;
    holds=0;
    %fprintf('本周结束时因为存货不足惩罚20金币，总支出为%d块\n',cost)
end

%% holding cost
if holds>0
    cost(1,j)=cost(1,j)+holds*5;
    %fprintf('本周结束时因为留有剩余库存%d个，惩罚%d金币，总支出为%d块\n',holds,holds*5,cost)
end
    %fprintf('本周结束时的库存为%d个\n',holds)
end
    cost(1,j)=cost(1,j)+holds*10;
    %fprintf('52周结束时的总成本为%d金币\n',cost(1,j))
end
%% the mean and variance of total cost
Ave = sum(cost)/runCount
meanCost = mean(cost)
variance = std(cost)
%% plot Histogram of 500 estimates of the total cost at order number 3 and re-order stock level 1
histogram(cost,10)
xlabel('costs of 52 weeks')
ylabel('number of instance')
title('Histogram of 500 estimates of the total cost at order number 3 and re-order stock level 1')
txt1 = ['The mean is ',num2str(meanCost)];
txt2 = ['The variance is ',num2str(variance)];
text(300,0.8*120,txt1,'FontSize',14)
text(300,0.7*120,txt2,'FontSize',14)
%% plot box plot of total cost
figure()
boxplot(cost);
title('box plot of total cost ')
xlabel('combination order number 3 and re-order stock level 1')
ylabel('total cost')