function [score] = Fscore(data, label)
% F-score feature selection
% reference: Combining SVMs with Various Feature Selection Strategies

uniLabel = unique(label);
nFea = size(data, 2);
score = zeros(nFea, 1);

for i = 1:nFea
    negScore = 0;
    posScore = 0;
    aver = mean(data(:, i));
    neg = data(find(label == uniLabel(1, 1)), i);
    averNeg = mean(neg);
    pos = data(find(label == uniLabel(2, 1)), i);
    averPos = mean(pos);
    
    numerator = (averNeg-aver)^2+(averPos-aver)^2; % eq.4
    
    for j = 1:length(neg)
        negScore = negScore + (neg(j, 1)-averNeg)^2;
    end
    negS = 1/(length(neg) - 1)*negScore;
    
    for j = 1:length(pos)
        posScore = posScore + (pos(j, 1)-averPos)^2;
    end
    posS = 1/(length(pos) - 1)*posScore;
    
    score(i, 1) = numerator/(negS+posS);
    
end



