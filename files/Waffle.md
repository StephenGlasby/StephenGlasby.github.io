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
  2025.02 Author: Stephen Glasby
  A Magma program to find all Waffle solutions. It assumes that the six
  words are in the dictionary Words.
*/

/*  2024.12.14
  Magma code for solving Waffle games
    S.P. Glasby, Mathematics of the NYT daily word game Waffle.
  I use the dictionary FiveLetterWords.txt
  A Waffle state is a sequence [h1,h2,h3,v1,v2,v3] of 5 letter words from
  a seuence Words (h1 top, h2 middle, h3 bottom,v1 left,v2 middle, v3 right).
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


Words:=Words cat ["omega","enema","aider","emcee","recap","dopey","yikes","hippo","erode","tarot","tangy","catty","teddy","bicep","cyber"];

_Letter:=function(S,pos)
/*
  Input:  a Waffle state S=[h1,h2,h3,v1,v2,v3], and a pos in {1,...,21}
  Output: the letter in position pos of WaffleState
*/
  local h1,h2,h3,i,L,v1,v2,v3;
  h1:=S[1];h2:=S[2];h3:=S[3];v1:=S[4];v2:=S[5];v3:=S[6];
  V:=[v1,v2,v3];
  L:=[h1[i]:i in [1..5]] cat [v[2]: v in V] cat [h2[i]:i in [1..5]]
    cat [v[4]: v in V] cat [h3[i]:i in [1..5]];
  return L[pos];
end function;

/*
S1:=["snarl","undid","force","snuff","aider","ledge"];
print [_Letter(S1,pos): pos in [1..21]];
S2:=["scgol","indee","ffare","snirf","gndia","ldeue"];GS2:={1,5,6,10,11,17,21};
print _Value(S1),_Value(S2);
S3:=["bight","clamp","sword","bucks","guano","typed"];
print [_Letter(S3,pos): pos in [1..21]];
S4:=["dupos","ewkrg","tlhmb","dieat","pukyh","sngcb"];GS4:={7};
print _Value(S3),_Value(S4);
*/

_CheckOverlaps:=function(S)
/*
  Input:  a Waffle state S=[h1,h2,h3,v1,v2,v3]
  Output: true if the 9 overlaps between h1,h2,h3,v1,v2,v3 match; false o/w
  Remark: it is really easy to mistype a Waffle state, so this is a great check
*/
  local H,h1,h2,h3,V,v1,v2,v3;
  h1:=S[1];h2:=S[2];h3:=S[3];v1:=S[4];v2:=S[5];v3:=S[6];
  H:=[h1[1],h1[3],h1[5],h2[1],h2[3],h2[5],h3[1],h3[3],h3[5]];
  V:=[v1[1],v2[1],v3[1],v1[3],v2[3],v3[3],v1[5],v2[5],v3[5]];
  //print H,V,H eq V;
  return H eq V;
end function;

// print [_CheckOverlaps(S): S in [S1,S2,S3,S4]];

/*
S5:=["abcde","ijklm","qrstu","afinq","cgkos","ehmpu"];
print _CheckOverlaps(S5);
S6:=_Swap(S5,<1,2>);print S6,_CheckOverlaps(S6);
*/

_PossibleWords:=function(S,hx,GS)
/*
  Input:  a (scrambled) Waffle state S=[h1,h2,h3,v1,v2,v3], hx a string in the
    set {"h1","h2","h3","v1","v2","v3"}, GS is set of numbers of green squares
  Output: a set of possible words from Words that hx could be
  WARNING: Words is a golbal variable
*/
  local c,I,i,K,NonGreen,Possible,U,w,X;
  // K = numbers of known (green) letters; U = numbers of unknown letters
  if hx eq "h1" then I:={1..5};K:=I meet GS;U:=I diff GS;end if;
  if hx eq "h2" then I:={9..13};K:=I meet GS;U:=I diff GS;end if;
  if hx eq "h3" then I:={17..21};K:=I meet GS;U:=I diff GS;end if;
  if hx eq "v1" then I:={1,6,9,14,17};K:=I meet GS;U:=I diff GS;end if;
  if hx eq "v2" then I:={3,7,11,15,19};K:=I meet GS;U:=I diff GS;end if;
  if hx eq "v3" then I:={5,8,13,16,21};K:=I meet GS;U:=I diff GS;end if;
  Possible:={};NonGreen:={1..21} diff GS;
  for X in Subsequences(NonGreen,#U) do // X is an ordered #U-subsequence
//  for X in Permutations(NonGreen,#U) do // X=ordered #U-sequence distinct entries
    w:="";c:=0;
    for i in Sort(SetToSequence(I)) do
      if i in K then w:=w*_Letter(S,i);
      else c+:=1;w:=w*_Letter(S,X[c]);end if;
    end for;
    //print "X,w,K,I=",<X,w,K,I>;
    if w in Words then Possible:=Possible join {w};end if;
  end for;
  return Possible;
end function;

/*
for hx in ["h1","h2","h3","v1","v2","v3"] do
  PW:=_PossibleWords(S2,hx,GS2);print #PW,PW;
end for;
*/

_PossibleSolutions:=function(S,GS)
/*
  Input:  a (scrambled) Waffle state S, GS is set of numbers of green squares
  Output: a sequence of possible Waffle solutions
  Remark: use _PossibleWords and _CheckOverlaps; we ignore yellow squares here
*/
  local H1,H2,H3,h1,h2,h3,L,Sh1,Sh2,Sh3,SL,Sv1,Sv2,Sv3,V1,V2,V3,v1,v2,v3,WS;
  H1:=_PossibleWords(S,"h1",GS);
  H2:=_PossibleWords(S,"h2",GS);
  H3:=_PossibleWords(S,"h3",GS);
  V1:=_PossibleWords(S,"v1",GS);
  V2:=_PossibleWords(S,"v2",GS);
  V3:=_PossibleWords(S,"v3",GS);
  Sh1:=S[1];Sh2:=S[2];Sh3:=S[3];Sv1:=S[4];Sv2:=S[5];Sv3:=S[6];
  // check that S and [h1,...,v3] have the same letters with same multiplicities
  SL:=Sh1*Sv1[2]*Sv2[2]*Sv3[2]*Sh2*Sv1[4]*Sv2[4]*Sv3[4]*Sh3;
  SL:={*SL[i]:i in [1..#SL]*}; // multiset of letters of S

  WS:=[];
  for h1 in H1 do
    for h2 in H2 do
      for v1 in V1 do
        if <v1[1],v1[3]> ne <h1[1],h2[1]> then continue v1;end if;
        for v2 in V2 do
          if <v2[1],v2[3]> ne <h1[3],h2[3]> then continue v2;end if;
	  for v3 in V3 do
            if <v3[1],v3[3]> ne <h1[5],h2[5]> then continue v3;end if;
  	    for h3 in H3 do
              if <h3[1],h3[3],h3[5]> ne <v1[5],v2[5],v3[5]> then
	          continue h3;end if;
	      L:=h1*v1[2]*v2[2]*v3[2]*h2*v1[4]*v2[4]*v3[4]*h3;
              L:={*L[i]:i in [1..#L]*}; // multiset of letters of [h1,...,v3]
              if SL ne L then continue h3;end if;
	      Append(~WS,[h1,h2,h3,v1,v2,v3]);  
	    end for;
	  end for;
        end for;
      end for;
    end for;
  end for;
  return WS;
end function;

_CheckYellow:=function(SOld,SNew,YS)
/*
  Input:  Waffle states SOld and SNew, YS = numbers of yellow squares of SOld
  Output: true if SNew is compatible with the yellow squares of SOld
  Remark: Suppose that L is the character in position x of SOld. If x is an even
    position and L is not in the unique word of SNew containing it, then
    return false. If x is an odd position, and L is not in either of the two
    words of SNew containing it, then return false. Otherwise return true.
*/
  local H1,H2,H3,L,V1,V2,V3,x;
  H1:=SOld[1];H2:=SOld[2];H3:=SOld[3];V1:=SOld[4];V2:=SOld[5];V3:=SOld[6];
  h1:=SNew[1];h2:=SNew[2];h3:=SNew[3];v1:=SNew[4];v2:=SNew[5];v3:=SNew[6];
  // check that SOld and SNew have the same letters with the same multiplicities
  LOld:=H1*V1[2]*V2[2]*V3[2]*H2*V1[4]*V2[4]*V3[4]*H3;
  LOld:={*LOld[i]:i in [1..#LOld]*};
  LNew:=h1*v1[2]*v2[2]*v3[2]*h2*v1[4]*v2[4]*v3[4]*h3;
  LNew:={*LNew[i]:i in [1..#LNew]*};
  if LOld ne LNew then return false;end if;
  for x in YS do
    L:=_Letter(SOld,x); // L is the character in position x of SOld
    // suppose that x is in an even position
    if x in {2,4}   and not(L in H1) then return false;end if; // unique word containing L is H1
    if x in {10,12} and not(L in H2) then return false;end if;
    if x in {18,20} and not(L in H3) then return false;end if;
    /*if x in {6,14}  and not(L in V1) then return false;end if;
    if x in {7,15}  and not(L in V2) then return false;end if;
    if x in {8,16}  and not(L in V3) then return false;end if;*/
    // suppose that x is in an odd position
    if x eq 1  and not(L in H1*V1) then return false;end if;
    if x eq 3  and not(L in H1*V2) then return false;end if;
    if x eq 5  and not(L in H1*V3) then return false;end if;
    if x eq 9  and not(L in H2*V1) then return false;end if;
    if x eq 11 and not(L in H2*V2) then return false;end if;
    if x eq 13 and not(L in H2*V3) then return false;end if;
    if x eq 17 and not(L in H3*V1) then return false;end if;
    if x eq 19 and not(L in H3*V2) then return false;end if;
    if x eq 21 and not(L in H3*V3) then return false;end if;
  end for;
  return true;
end function;


SO:=[];SN:=[];GS:=[];YS:=[];HV:=["h1","h2","h3","v1","v2","v3"];

n:=1;SO[n]:=["fboue","lsoom","oemna","fglgo","oioem","eumla"];
SN[n]:=["fugue","loose","omega","folio","globe","enema"];
GS[n]:={1,4,5,9,11,17,21};YS[n]:={10,12,13,15,18,19};
WS:=_PossibleSolutions(SO[n],GS[n]); // "omega","enema" not in Words
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;

n:=2;SO[n]:=["scgol","indee","ffare","snirf","gndia","ldeue"];
SN[n]:=["snarl","undid","force","snuff","aider","ledge"]; // "aider" not in Words;
GS[n]:={1,5,6,10,11,17,21};YS[n]:={8,9,13,15,19,20};
WS:=_PossibleSolutions(SO[n],GS[n]); // "omega","enema" not in Words
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;

n:=3;SO[n]:=["speed","tocir","peiey","satnp","etcei","dprmy"];
SN[n]:=["spend","recap","piety","strip","emcee","dopey"];
GS[n]:={1,2,3,5,11,15,17,21};YS[n]:={8,9,13,18,19};
WS:=_PossibleSolutions(SO[n],GS[n]); // "emcee","recap","dopey" not in Words
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;

n:=4;SO[n]:=["ndeey","traec","dnsks","netkd","eeaas","ylcis"];
SN[n]:=["needy","knack","dress","naked","elate","yikes"];
GS[n]:={1,3,5,11,17,21};YS[n]:={2,4,6,7,13,14,16,19};
WS:=_PossibleSolutions(SO[n],GS[n]); // "yikes" not in Words
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;

n:=250;SO[n]:=["apsee","idpup","nsere","auirn","sopme","esphe"];
SN[n]:=["amuse","hippo","nurse","ashen","upper","erode"];
GS[n]:={1,5,11,17,21};YS[n]:={3,9,13,18,19,20};
WS:=_PossibleSolutions(SO[n],GS[n]); // "hippo","erode" not in Words
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;

n:=252;SO[n]:=["leerc","iinag","tliid","lhied","eenri","cegid"];
SN[n]:=["lilac","genie","tired","light","liner","creed"];
GS[n]:={1,5,11,17,21};YS[n]:={3,6,8,9,13,15,19};
WS:=_PossibleSolutions(SO[n],GS[n]); // 
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;

n:=260;SO[n]:=["cuenm","dcocr","taafh","chdrt","erota","mrrnh"];
SN[n]:=["charm", "acorn", "tenth", "craft", "adorn", "munch"]; // WARNING 2 solutions
SN[n]:=["charm", "adorn", "tenth", "craft", "acorn", "munch"]; // "acorn" <-> "adorn"
GS[n]:={1,5,11,17,21};YS[n]:={7,9,13,14,16,19};
WS:=_PossibleSolutions(SO[n],GS[n]); // two slns !!
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;

n:=276;SO[n]:=["vashm","oniee","sroor","veogs","seino","mueir"];
SN[n]:=["venom", "reign", "sheer", "virus", "noise", "manor"]; // 1 solution
GS[n]:={1,5,11,17,21};YS[n]:={3,7,10,12,15,18};
WS:=_PossibleSolutions(SO[n],GS[n]); // 
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;

n:=280;SO[n]:=["frint","nonni","teeet","fanat","iunne","tlilt"];
SN[n]:=["fleet", "inner", "taint", "flint", "ennui", "tarot"]; // "tarot" not in Words
GS[n]:={1,5,11,17,21};YS[n]:={3,7,10,12,15,18};
WS:=_PossibleSolutions(SO[n],GS[n]); // 
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for; // two transpose slns!
/* The coloured squares not symmetric about the main diag. However, remarkably
   reflecting about the main diag (AKA transposing) changes one solution of
   six words to another*/

n:=292;SO[n]:=["bmatd","rpawi","ezley","bmrle","asall","daimy"];
SN[n]:=["based", "alarm", "empty", "blaze", "swamp", "dimly"]; // 
GS[n]:={1,5,11,17,21};YS[n]:={3,7,9,13,14,16}; 
WS:=_PossibleSolutions(SO[n],GS[n]); // # #WS=552 before comparing multisets
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;

n:=298;SO[n]:=["crout","aicua","cnagy","coanc","oucta","tbaty"];
SN[n]:=["court","bacon","catty","cubic","uncut","tangy"]; // "tangy","chatty" not in Words
GS[n]:={1,5,11,17,21};YS[n]:={2,3,4,7,9,13,15,19}; 
WS:=_PossibleSolutions(SO[n],GS[n]); // 
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;
for hx in HV do print <hx,_PossibleWords(SO[n],hx,GS[n])>;end for;

n:=304;SO[n]:=["timie","segnn","tseoy","tdsdt","mrgee","elnay"];
SN[n]:=["terse","angle","teddy","toast","rigid","enemy"]; // "teddy" not in Words
GS[n]:={1,5,11,17,21};YS[n]:={7,9,10,11,12,13,19}; 
WS:=_PossibleSolutions(SO[n],GS[n]); // "teddy" not in Words
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;
// if I add "teddy" to Words, then there is unique solution :-)
for hx in HV do print <hx,_PossibleWords(SO[n],hx,GS[n])>;end for;

n:=308;SO[n]:=["blegl","iabaa","pciee","bciop","enbei","lraye"];
SN[n]:=["banal","cyber","piece","bicep","noble","large"]; // "bicep","cyber" not in Words
GS[n]:={1,5,11,17,21};YS[n]:={3,6,7,8,9,13,18,19,20}; 
WS:=_PossibleSolutions(SO[n],GS[n]); // 
for W in WS do if _CheckYellow(SO[n],W,YS[n]) then print W;end if;end for;
//for hx in HV do print <hx,_PossibleWords(SO[n],hx,GS[n])>;end for;

//-----------------------------------------------------------------------------
```