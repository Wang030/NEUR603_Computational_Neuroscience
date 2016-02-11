function [ d ] = hamming_distance(m1,m2)
%Calculates hamming distance between two matrices

%Convert to binary representation
m1(m1 == -1) = 0;
m2(m2 == -1) = 0;

d = sum(abs(m1-m2));

end

