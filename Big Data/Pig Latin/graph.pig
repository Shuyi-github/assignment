
1.the frequency of each degree value
A = load 'ex_data/roadnet/roadNet-CA.txt' as (nodeA:chararray, nodeB:chararray);
B = group A by nodeA;
C = foreach B generate COUNT(A) as freq, group;
D = group A by nodeB;
E = foreach D generate COUNT($1), group;
F = union E, C;
G = group F by $0;
H = foreach G generate SUM(F.($1)) as sum, group;
I = group H by sum;
J = foreach I generate group , COUNT($1) as count;
dump J;

2.the percentage of dead-end nodes
A = load 'ex_data/roadnet/roadNet-CA.txt' as (nodeA:chararray, nodeB:chararray);
B = group A by nodeA;
C = foreach B generate COUNT(A) as freq, group;
D = join A by nodeB left outer, B by group;
E = filter D by $2 is null;
F = group E by $1;
G = group F all;
H = group B all;
I = foreach H generate (double)COUNT($1) as a, (double)COUNT (G.$1) as b;
J = foreach I generate (float)((a/a+b));
dump J;

3.he average degree of the graph
A = load 'ex_data/roadnet/roadNet-CA.txt' as (nodeA:chararray, nodeB:chararray);
B = group A by nodeA;
C = foreach B generate COUNT(A) as freq, group;
D = group A by nodeB;
E = foreach D generate COUNT($1), group;
F = union E, C;
G = group F by $0;
H = foreach G generate SUM(F.($1)) as sum, group;
I = group H by sum;
J = foreach I generate group as dv, COUNT($1) as count;
E = foreach J generate dv as deg, count, deg*count as total;
F = group E all;
G = foreach E generate (double)SUM(E.count) as a, (double)SUM(E.total) as b;
avg = foreach G generate (float)(b/a);
dump avg;



