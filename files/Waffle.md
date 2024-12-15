---
layout: page
permalink: /Waffle/
---

```
//---------------------------------------------------------------------------

/*  2024.12.14
  Magma code is a companion to the manuscript
    S.P. Glasby, Mathematics of the NYT daily word game Waffle.
  I use two dictionaries: FiveLetterWords.txt and CollinsScrabbleWords2019.txt
  The code below creates from one of these dictionaries a sequence called
  Words or WordsScrabble of 5-letter non-swapable English words. A swappable
  word w is a string with w[2] ne w[4] and w[1]*w[4]*w[3]*w[2]*w[5] in Words
*/

WordsFile:=Read("FiveLetterWords");
Words:=[&*[WordsFile[6*(i-1)+j]: j in [1..5]]: i in [1..3103]];
SwapWords:=[];
// w in SwapWords if w[2] ne w[4] and w[1]*w[4]*w[3]*w[2]*w[5] in Words
for w in Words do 
  if w[2] eq w[4] then continue w;end if;
  if w[1]*w[4]*w[3]*w[2]*w[5] in Words then Append(~SwapWords,w);end if;
end for;
for w in SwapWords do
  ww:=w[1]*w[4]*w[3]*w[2]*w[5];
  Remove(~Words,Position(Words,ww));
end for;
print "Number of SwapWords =",3103 - #Words; // FiveLetterWords has 3103 words
print "#Words =",#Words; // #Words equals 3075

x:="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
Alphabet:=[x[i]: i in [1..#x]];
ScrabbleWordsFile:=Read("CollinsScrabbleWords2019.txt");
AllWords:=[];w:="";
for i in [1..#ScrabbleWordsFile] do
  x:=ScrabbleWordsFile[i];
  if x in Alphabet then w:=w*x;end if;
  if x eq "\n" then Append(~AllWords,w);w:="";end if;
end for;
WordsScrabble:=[]; // the non-swappable 5-letter Scrabble words
for i in [1..#AllWords] do
  w:=AllWords[i];
  if #w ne 5 then continue i;end if;
  ww:=w[1]*w[4]*w[3]*w[2]*w[5];
  if not(ww in AllWords) then Append(~WordsScrabble,w);end if;
end for;
print "#WordsScrabble =",#WordsScrabble; // #WordsScrabble equals 11948

/*
  Compute the frequency of 2-letter strings in Words (or WordsScrabble)
*/

X:="abcdefghijklmnopqrstuvwxyz";
alphabet:=[X[i]: i in [1..#X]];
Frequencies:=[];
for x in alphabet do
  for y in alphabet do
    c:=0;
    for w in Words do  // replace Words with WordsScrabble?
      if x*y in {w[i]*w[i+1]: i in [1..4]} then c+:=1;end if;
    end for;
    Append(~Frequencies,<c,x,y>);
  end for;
end for;
Sort(~Frequencies);
print "Number of zero frequencies =",&+[1: w in Frequencies| w[1] eq 0];
print "Total number of frequencies =",#alphabet^2;

/*
  Compute the sum of the number of cycles of g in S_n divided by n!
  Call this x(n). Then x(n) - log(n) decreases from 1 to 0.583862
  as n inreases from 1 to 75.
  Q1. Does lim_{n\to\infty} x(n) - log(n) exist? Q2. If so, is it positive?
  Goncarov proves x(n) ~ log(n) as n\to\infty, see Erdos-Turan reference [2]
*/
  
_NumberOfCycles:=function(g)
// Input: g in S_n Output: the number of cycles (including 1-cycles) in g
  local C,i;
  C:=CycleStructure(g);
  return &+[C[i,2]: i in [1..#C]];
end function;

_ConjugacyClassSize:=function(lambda)
/*
  Input:  a partition lambda of n (nonincreasing sequence of positive integers)
  Output: the size of the conjugacy class of S_n 
*/
  local i,k,M,mult,n;
  k:=#lambda;n:=&+[lambda[i]: i in [1..k]];M:=[];
  for i in [1..n] do
    // compute the multiplicity m_i of part i
    mult:=0;for j in [1..k] do if lambda[j] eq i then mult+:=1;end if;end for;
    Append(~M,mult);
  end for;
  return Factorial(n) div &*[i^M[i]*Factorial(M[i]): i in [1..n]];
end function;

for n in [1..20] do
  f:=Factorial(n);
  print <n,&+[_ConjugacyClassSize(lambda): lambda in Partitions(n)] eq f>;
end for;

R:=RealField(6);
for n in [1..40] do
  total:=0;  // count the # of cycles in each conjugacy class and in S_n
  for lambda in Partitions(n) do
    total+:=#lambda*_ConjugacyClassSize(lambda);
  end for;
  x:=R!(total/Factorial(n));print <n,x,x-Log(n)>;
end for;

//---------------------------------------------------------------------------

/*
  A Magma program to find all Waffle solutions with >= 20 distinct letters.
  Our words are chosen from a list of 3075 common (non-swappable) 5-letter
  English words. 
  Case 1: v1[1] ne h1[5]. Then WMA that #(h1Chars join v1Chars) eq 9
  Case 2: v1[1] eq h1[5] and #(h1Chars join v1Chars) ge 8
  Notation: If w,w' are words then I will write |w| and |w U w'| to denote the
    number of disinct letters in w and w or w', respectively.
  Case 1: |h1|=5, |h1 U v1|=9, |h1 U v1 U v3|>=12,
    |h1 U v1 U v3 U h2|>=15, |h1 U v1 U v3 U h2 U v2|>=18 
  Case 2: v1[1] eq h1[5] and |h1|=5, |h1 U v1|=8, |h1 U v1 U v3|>=12,
    |h1 U v1 U v3 U h2|=15, |h1 U v1 U v3 U h2 U v2|>=18
  The program below gives 767 Waffle Case 1 solutions with d=20 in 3.0 hrs.
  To modify the program to find the Case 2 solutions look at the comments
  containing "*Case 2*". Case 2 has 2 solutions (both d=19) and took 1.5 hrs
  [[kings,adopt,sibyl,shack,brown,lutes], [kings,adopt,sibyl,smack,brown,lutes]]
*/

WordsFile:=Read("FiveLetterWords");  // read ASCII file of 3103 5-letter words
Words:=[&*[WordsFile[6*(i-1)+j]: j in [1..5]]: i in [1..3103]];
SwapWords:=[]; // w in SwapWords if swapping w[2] & w[4] is a new word in Words
for w in Words do 
  if w[2] ne w[4] and w[1]*w[4]*w[3]*w[2]*w[5] in Words then
    Append(~SwapWords,w);
  end if;
end for;
NewWords:=[];
for w in Words do if not w in SwapWords then Append(~NewWords,w);end if;end for;
print "#Words,#NewWords =",#Words,#NewWords;

Words:=NewWords; // just consider `non-swappable' words
Solutions:=[]; // Waffle solutions with >=20 distinct letters
c20:=0; // number of Waffle solutions with >=20 distinct letters found so far
I:=[1..5];
// Choose h1 to have 5 distinct letters (can assume this by taking transposes)
h1Words:=[];
for h1 in Words do
  if #{h1[i]:i in I} eq 5 then Append(~h1Words,h1);end if;
end for;
t:=Cputime();
for h1 in h1Words do  // 1st word
  pos:=Position(h1Words,h1);
  if pos mod 100 eq 0 then print pos,h1,Round(Cputime(t));end if;
  h1Chars:={h1[i]: i in I};
  Chars:=h1Chars; // Chars is the set of distinct letters found so far
  v1Words:=[];
  for v1 in Words do
//    if h1[1] eq v1[5] and #(Chars join {v1[i]: i in I}) eq 8 then // *Case 2*
    if h1[1] eq v1[5] and #(Chars join {v1[i]: i in I}) ge 9 then
      Append(~v1Words,v1);
    end if;
  end for;
  for v1 in v1Words do  // 2nd word
    v1Chars:={v1[i]: i in I};
    Chars:=h1Chars join v1Chars; // set of distinct letter in h1 U v1
    v3Words:=[];
    for v3 in Words do
      if h1[5] eq v3[5] and #(Chars join {v3[i]: i in I}) ge 12 then
        Append(~v3Words,v3);
      end if;
    end for;
    for v3 in v3Words do  // 3rd word
      v3Chars:={v3[i]: i in I};
      Chars:=h1Chars join v1Chars join v3Chars;  // letters in h1 U v1 U v3
      h2Words:=[];
      for h2 in Words do
        if h2[1] eq v1[3] and h2[5] eq v3[3]
	     and #(Chars join {h2[i]: i in I}) ge 15 then
	  Append(~h2Words,h2);
	end if;
      end for;
      for h2 in h2Words do  // 4th word
        h2Chars:={h2[i]: i in I}; // find letters in h1 U v1 U v3 U h2
        Chars:=h1Chars join v1Chars join v3Chars join h2Chars;
        v2Words:=[];
	for v2 in Words do
	  if v2[3] eq h2[3] and v2[5] eq h1[3]
	    and #(Chars join {v2[i]: i in I}) ge 18  then
	    Append(~v2Words,v2);
	  end if;
	end for;
	for v2 in v2Words do  // 5th word
          v2Chars:={v2[i]: i in I}; // find letters in h1 U v1 U v3 U h2 U v2
          Chars:=h1Chars join v1Chars join v3Chars join h2Chars join v2Chars;
          h3Words:=[];
          for h3 in Words do
	    if h3[1] eq v1[1] and h3[3] eq v2[1] and h3[5] eq v3[1] then
	      Append(~h3Words,h3);
	    end if;
	  end for;
	  for h3 in h3Words do  // 6th word
            h3Chars:={h3[i]: i in I};
	    // if h3[1] ne h1[5] then continue h3;end if; // *Case 2*
	    // find the set of letters in h1 U v1 U v3 U h2 U v2 U h3
            Chars:=h1Chars join v1Chars join v3Chars join h2Chars
	             join v2Chars join h3Chars;
	    Waffle:=[h1,h2,h3,v1,v2,v3];
	    M:={* w[i]: i in I, w in [h1,h2,h3]*};
	    M:=M join {*w[i]: i in [2,4], w in [v1,v2,v3] *};
            if #Chars ge 20 then
	      c20+:=1;Append(~Solutions,Waffle);
	      print "T,c20,#C,W,M=",Round(Cputime()),c20,#Chars,Waffle,M;
	    end if;
          end for;
	end for;
      end for;
    end for;
  end for;
end for;
Case1Solutions:=Solutions;
// Case2Solutions:=Solutions; // *Case 2*

/*
We list examples of Waffles with 20 distinct letters. If you choose
a repeat letter to be green, then g' permutes the 20 non-green squares.

T,c20,#C,W,M= 727 1 20 [ dingy, opals, fetch, fjord, twain, husky ]
{* a, c, d, e, f, g, h, i^^2, j, k, l, n, o, p, r, s, t, u, w, y *}
T,c20,#C,W,M= 727 2 20 [ dingy, ovals, fetch, fjord, twain, husky ]
{* a, c, d, e, f, g, h, i^^2, j, k, l, n, o, r, s, t, u, v, w, y *}
T,c20,#C,W,M= 1533 3 20 [ dusky, ozone, clamp, chord, avows, piety ]
{* a, c, d, e, h, i, k, l, m, n, o^^2, p, r, s, t, u, v, w, y, z *}
T,c20,#C,W,M= 1779 4 20 [ empty, amigo, bucks, blade, chirp, snowy ]
{* a, b, c, d, e, g, h, i, k, l, m^^2, n, o, p, r, s, t, u, w, y *}
T,c20,#C,W,M= 1779 5 20 [ empty, amigo, bucks, blaze, chirp, snowy ]
{* a, b, c, e, g, h, i, k, l, m^^2, n, o, p, r, s, t, u, w, y, z *}
T,c20,#C,W,M= 1867 6 20 [ entry, avows, claim, chafe, adopt, musky ]
{* a^^2, c, d, e, f, h, i, k, l, m, n, o, p, r, s, t, u, v, w, y *}
T,c20,#C,W,M= 1876 7 20 [ entry, avoid, scamp, shake, aloft, pudgy ]
{* a^^2, c, d, e, f, g, h, i, k, l, m, n, o, p, r, s, t, u, v, y *}
T,c20,#C,W,M= 1876 8 20 [ entry, avoid, swamp, shake, aloft, pudgy ]
{* a^^2, d, e, f, g, h, i, k, l, m, n, o, p, r, s, t, u, v, w, y *}
T,c20,#C,W,M= 3284 9 20 [ husky, twain, fjord, fetch, opals, dingy ]
{* a, c, d, e, f, g, h, i^^2, j, k, l, n, o, p, r, s, t, u, w, y *}
T,c20,#C,W,M= 3284 10 20 [ husky, twain, fjord, fetch, ovals, dingy ]
{* a, c, d, e, f, g, h, i^^2, j, k, l, n, o, r, s, t, u, v, w, y *}
T,c20,#C,W,M= 3952 11 20 [ musky, adopt, chafe, claim, avows, entry ]
{* a^^2, c, d, e, f, h, i, k, l, m, n, o, p, r, s, t, u, v, w, y *}
T,c20,#C,W,M= 4183 12 20 [ piety, avows, chord, clamp, ozone, dusky ]
{* a, c, d, e, h, i, k, l, m, n, o^^2, p, r, s, t, u, v, w, y, z *}
T,c20,#C,W,M= 4348 13 20 [ pudgy, aloft, shake, scamp, avoid, entry ]
{* a^^2, c, d, e, f, g, h, i, k, l, m, n, o, p, r, s, t, u, v, y *}
T,c20,#C,W,M= 4349 14 20 [ pudgy, aloft, shake, swamp, avoid, entry ]
{* a^^2, d, e, f, g, h, i, k, l, m, n, o, p, r, s, t, u, v, w, y *}
T,c20,#C,W,M= 5997 15 20 [ sight, clove, drays, ducks, among, swept ]
{* a, c, d, e, g, h, i, k, l, m, n, o, p, r, s^^2, t, u, v, w, y *}
T,c20,#C,W,M= 6828 16 20 [ snowy, chirp, blade, bucks, amigo, empty ]
{* a, b, c, d, e, g, h, i, k, l, m^^2, n, o, p, r, s, t, u, w, y *}
T,c20,#C,W,M= 6828 17 20 [ snowy, chirp, blaze, bucks, amigo, empty ]
{* a, b, c, e, g, h, i, k, l, m^^2, n, o, p, r, s, t, u, w, y, z *}
T,c20,#C,W,M= 6828 18 20 [ snowy, chide, blaze, bucks, amigo, every ]
{* a, b, c, d, e^^2, g, h, i, k, l, m, n, o, r, s, u, v, w, y, z *}
T,c20,#C,W,M= 7550 19 20 [ sport, chide, blaze, bucks, amigo, event ]
{* a, b, c, d, e^^2, g, h, i, k, l, m, n, o, p, r, s, t, u, v, z *}
T,c20,#C,W,M= 7989 20 20 [ stony, chide, blaze, bucks, amigo, every ]
{* a, b, c, d, e^^2, g, h, i, k, l, m, n, o, r, s, t, u, v, y, z *}
T,c20,#C,W,M= 8477 21 20 [ swept, among, ducks, drays, clove, sight ]
{* a, c, d, e, g, h, i, k, l, m, n, o, p, r, s^^2, t, u, v, w, y *}
T,c20,#C,W,M= 8582 22 20 [ sword, clamp, bight, backs, guano, typed ]
{* a^^2, b, c, d, e, g, h, i, k, l, m, n, o, p, r, s, t, u, w, y *}
T,c20,#C,W,M= 8584 23 20 [ sword, clamp, bight, bucks, guano, typed ]
{* a, b, c, d, e, g, h, i, k, l, m, n, o, p, r, s, t, u^^2, w, y *}
T,c20,#C,W,M= 9687 24 20 [ typed, guano, backs, bight, clamp, sword ]
{* a^^2, b, c, d, e, g, h, i, k, l, m, n, o, p, r, s, t, u, w, y *}
T,c20,#C,W,M= 9687 25 20 [ typed, guano, bucks, bight, clamp, sword ]
{* a, b, c, d, e, g, h, i, k, l, m, n, o, p, r, s, t, u^^2, w, y *}
*/

//-----------------------------------------------------------------------------

/*
  2024.06.23 Author: Stephen Glasby
  A Magma program to find all Waffle solutions with 21 distinct letters.
  Our words are chosen from a list of 8080 non-swappable 5-letter SCRABBLE words
  This list is obtained from the file CollinsScrabbleWords2019.txt using the
  Magma code below. Please email glasbys@gmail.com for a copy of the 3MB file
  CollinsScrabbleWords2019.txt
*/

Alphabet:=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
ScrabbleWordsFile:=Read("CollinsScrabbleWords2019.txt");
AllWords:=[];w:="";
for i in [1..#ScrabbleWordsFile] do
  x:=ScrabbleWordsFile[i];
  if x in Alphabet then w:=w*x;end if;
  if x eq "\n" then Append(~AllWords,w);w:="";end if;
end for;
I:=[1..5];
Words:=[]; // the 5 letter non-swappable words which have 5 distinct letters
for i in [1..#AllWords] do
  w:=AllWords[i];
  if #w eq 5 and #{w[i]: i in I} eq 5 then
    ww:=w[1]*w[4]*w[3]*w[2]*w[5]; // if w eq ww then w and ww are swappable
    if not(ww in AllWords) then Append(~Words,w);end if;
  end if;
end for;

Solutions:=[]; // Waffle solutions with 21 distinct letters
c21:=0; // number of Waffle solutions with 21 distinct letters found so far
I:=[1..5];
t:=Cputime();
h1Words:=[]; // Choose words ending in "Y"
for h1 in Words do if h1[5] eq "Y" then Append(~h1Words,h1);end if;end for;
for h1 in h1Words do  // 1st word
  pos:=Position(h1Words,h1);
  if pos mod 20 eq 0 then print #h1Words,pos,h1,Round(Cputime(t));end if;
  h1Chars:={h1[i]: i in I};
  Chars:=h1Chars; // Chars is the set of distinct letters found so far
  v1Words:=[];
  for v1 in Words do  // compute v1Words
    if h1[1] eq v1[5] and #(Chars join {v1[i]: i in I}) eq 9 then
      Append(~v1Words,v1);
    end if;
  end for;
  for v1 in v1Words do  // 2nd word  Note: v1Words is defined above
    v1Chars:={v1[i]: i in I};
    if v1[5] ne h1[1] and #(Chars join v1Chars) ne 9 then continue v1;end if;
    //pos:=Position(v1Words,v1);
    //if pos mod 50 eq 0 then print h1,pos,v1,Round(Cputime(t));end if;
    Chars:=h1Chars join v1Chars; // set of distinct letter in h1 U v1
    v3Words:=[];
    for v3 in Words do
      if h1[5] eq v3[5] and #(Chars join {v3[i]: i in I}) ge 13 then
        Append(~v3Words,v3);
      end if;
    end for;
    for v3 in v3Words do  // 3rd word
      v3Chars:={v3[i]: i in I};
      Chars:=h1Chars join v1Chars join v3Chars;  // letters in h1 U v1 U v3
      h2Words:=[];
      for h2 in Words do
        if h2[1] eq v1[3] and h2[5] eq v3[3]
	     and #(Chars join {h2[i]: i in I}) ge 16 then
	  Append(~h2Words,h2);
	end if;
      end for;
      for h2 in h2Words do  // 4th word
        h2Chars:={h2[i]: i in I}; // find letters in h1 U v1 U v3 U h2
        Chars:=h1Chars join v1Chars join v3Chars join h2Chars;
        v2Words:=[];
	for v2 in Words do
	  if v2[3] eq h2[3] and v2[5] eq h1[3]
	    and #(Chars join {v2[i]: i in I}) ge 19  then
	    Append(~v2Words,v2);
	  end if;
	end for;
	for v2 in v2Words do  // 5th word
          v2Chars:={v2[i]: i in I}; // find letters in h1 U v1 U v3 U h2 U v2
          Chars:=h1Chars join v1Chars join v3Chars join h2Chars join v2Chars;
          h3Words:=[];
          for h3 in Words do
	    if h3[1] eq v1[1] and h3[3] eq v2[1] and h3[5] eq v3[1] then
	      Append(~h3Words,h3);
	    end if;
	  end for;
	  for h3 in h3Words do  // 6th word
            h3Chars:={h3[i]: i in I};
	    // if h3[1] ne h1[5] then continue h3;end if; // *Case 2*
	    // find the set of letters in h1 U v1 U v3 U h2 U v2 U h3
            Chars:=h1Chars join v1Chars join v3Chars join h2Chars
	             join v2Chars join h3Chars;
	    Waffle:=[h1,h2,h3,v1,v2,v3];
	    M:={* w[i]: i in I, w in [h1,h2,h3]*};
	    M:=M join {*w[i]: i in [2,4], w in [v1,v2,v3] *};
            if #Chars ge 21 then
	      c21+:=1;Append(~Solutions,Waffle);
	      print "T,c21,#C,W,M=",Round(Cputime()),c21,#Chars,Waffle,M;
	    end if;
          end for;
	end for;
      end for;
    end for;
  end for;
end for;
print #Solutions;

//-----------------------------------------------------------------------------
```