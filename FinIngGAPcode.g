LoadPackage("fining");

cases := [];

for q in [2,3,4,5] do
        for eps in [-1,1] do
        for sig1 in [-1,1] do
        for sig2 in [-1,1] do
                Add(cases, [q, 1, 1, eps, sig1, sig2]);
        od;
        od;
        od;
od;

for M in [[1,2], [1,3], [2,2]] do
        for eps in [-1,1] do
        for sig1 in [-1,1] do
        for sig2 in [-1,1] do
                Add(cases, [2, M[1], M[2], eps, sig1, sig2]);
        od;
        od;
        od;
od;

bad_cases := [];

for C in cases do

Display(Concatenation("Case ", String(C)));

q := C[1];

m1 := C[2];
m2 := C[3];
eps := C[4];
sig1 := C[5];
sig2 := C[6];

e1 := 2*m1;
e2 := 2*m2;
d := e1+e2;

pg := PG(d-1, q);

X1 := AsSet(ElementsOfIncidenceStructure(pg, e1));;
X2 := AsSet(ElementsOfIncidenceStructure(pg, e2));;

if eps = 1 then
        ps := HyperbolicQuadric(d-1, q);
else
        ps := EllipticQuadric(d-1, q);
fi;

# G := CollineationGroup(ps);

if sig1 = 1 then
        type1 := "hyperbolic";
else
        type1 := "elliptic";
fi;

if sig2 = 1 then
        type2 := "hyperbolic";
else
        type2 := "elliptic";
fi;

Y1 := Filtered(X1, x -> TypeOfSubspace(ps, x) = type1);
Y2 := Filtered(X2, x -> TypeOfSubspace(ps, x) = type2);

cnt := Size(Filtered(Y2, x -> Meet(x, Y1[1]) = EmptySubspace(pg)));
density := cnt/Size(Y2);

Display([density, Float(density), 1-1.5/q]);
if 1-3/q/2 > density then
        Display("WARNING!");
        Add(bad_cases, C);
fi;

od;

