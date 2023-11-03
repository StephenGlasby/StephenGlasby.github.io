---
layout: page
permalink: /BerryEsseenMagmaCode/
---

```
/*
  Compare the GCF approximation to Berry-Esseen approximation
*/

_GCFValue:=function(Aseq,Bseq)
/*
  Input: [a_1,...,a_r], [b_1,...,b_r] sequences of field elements (same length)
  Output: the value of the generalized continued fraction (GCF)
    b_1/(a_1+(b_2/(a_2+...+b_{r-1}/(a_{r-1}+a_r/b_r))))
  Remark: a simple continued fraction has Bseq = [1,1,...,1]
*/
  local a1,b1;
  if #Aseq ne #Bseq then error "_GCFValue: #Aseq ne #Bseq",#Aseq,#Bseq;end if;
  if #Bseq eq 0 then return 0;end if;
  a1:=Aseq[1];b1:=Bseq[1];
  return b1/(a1+$$(Remove(Aseq,1),Remove(Bseq,1)));
end function;

// Check that the simple continued fraction [1;2,2,2,...,2] approximates Sqrt(2)
// S:=[1..40];Aseq:=[2:i in S];Bseq:=[1:i in S];print 1.0+_GCFValue(Aseq,Bseq);

_Phi:=function(x)
// The cumulative distribution function for the standard normal distribution
  return (1/2)*(1+Erf(x/Sqrt(2))); // 1/\Sqrt(2\pi)\int_{-\infty}^x e^{-t^2/2}dt
end function;

// How good is the kth head H_k of our GCF at approximating s_m(r)?
// How does H_k compare to the approximation using the Berry-Esseen inequality?

// The following code verifies the GCF expansion in Theorem 1.1
m:=10;
for r in [0..m] do
  s:=&+[Binomial(m,i):i in [0..r]];
  Aseq:=[m-2*r+3*i: i in [1..r]];Bseq:=[2*i*(r+1-i): i in [1..r]];
  K:=m-2*r+_GCFValue(Aseq,Bseq);Q:=(r+1)*Binomial(m,r+1)/s;
  if not (K eq Q) then print <m,r,K,Q>;end if;
end for;

// The following code compares H_k to the Berry-Esseen approximation
// Note that H_m equals 0, that is K equals m when r=m.
R:=RealField(6);
for m in [10000] do
  for r in [1000,4500,5000] do
    s:=&+[Binomial(m,i):i in [0..r]];
    for k in [3,5,21] do
      Aseq:=[m-2*r+3*i: i in [1..k]];Bseq:=[2*i*(r+1-i): i in [1..k]];
      a0:=m-2*r;Hk:=_GCFValue(Aseq,Bseq);
      Approx1:=(r+1)*Binomial(m,r+1)/((a0+Hk)*s);
      Approx2:=2^m*_Phi((2*r-m)/Sqrt(m))/s;
      print <m,r,k,R!(1-Approx1),R!(1-Approx2)>;
    end for;
  end for;
end for;
```