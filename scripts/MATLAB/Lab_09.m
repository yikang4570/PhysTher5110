%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Lab 09: Vectorization and linear algebra - cheat codes:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 1a.
% Multiply each row of a 4x4 matrix by the corresponding element of a
% 1x4 array, then create a separate variable that multiplies each column
% of the original matrix by the 1x4 array, both without a loop:

% create the data matrix and vector:
dat = magic(4);
% dat will = [16, 2,3,13;
%		5, 11, 10, 8;
%		9, 7, 6, 12;
%		4, 14, 15, 1];
vect = 1:4;
%
% your output for the row-wise multiplication should be:
%   [16     4     9    52;
%	5    22    30    32;
%	9    14    18    48;
%	4    28    45     4];
rowMultiplier = dat.*vect;
colMultiplier = dat.*vect';
% Keith, I think this element-wise multiplication with implicit expansion
% is going to require numpy.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1b.
% Say you have a matrix of arbitrary numbers with a range of [-1,1] and
% dimensions 10,000x20,000. You want to set all of the entries that are
% greater than 1 equal to zero. With no loops. What is the most efficient
% way to vectorize this computation?

% create data matrix:
data = -2 + 2*rand(10000, 20000);
%
% replace the following loop-based with a 1-line
% vectorized alternative:
for i=1:10000
    for j=1:20000
        if data(i,j) > 1
            data(i,j) = 0;
        end
    end
end
%
% Solution:
data(data>1) = 0;
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1c.
% Find the maximum of sin(x) * cos(y), where x=1:7 and y=1:5. Do not use
% loops. Hint: one good solution uses matrix math…
%
x=1:7;
y=1:5;
%
% solution:
[rx,cx]=size(x);
[ry,cy]=size(y);
%
X=repmat(x,cy,1);
Y=repmat(y',1,cx);
%
maxVal = max(max( sin(X).*cos(Y)));
% Note, the above finds the max in one line. To know the location of the 
% maximum too, use:
%
XY = sin(X).*cos(Y);
[r,c]=max(XY);
[r2,c2]=max(max(XY));
sprintf('The biggest element in XY is %d at XY(%d,%d)',r2,c(c2), ...
    c2)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
