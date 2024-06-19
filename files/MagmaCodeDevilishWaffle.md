---
layout: page
permalink: /MagmaCodeDevilishWaffle/
---

```
/*
  2024.06.19
  A Magma program to find all Waffle solutions with 20 or 21 distinct letters.
  Our words are chosen from a list of 3075 common (non-swapable) 5-letter
  English words. 
  Case 1: v1[1] ne h1[5]. Then WMA that #(h1Chars join v1Chars) eq 9
  Case 2: v1[1] eq h1[5] and #(h1Chars join v1Chars) ge 8
  Notation: If w,w' are words then I will write |w| and |w U w'| to denote the
    number of disinct letters in w and w or w', respectively.
  Case 1: |h1|=5, |h1 U v1|=9, |h1 U v1 U v3|>=12,
    |h1 U v1 U v3 U h2|>=15, |h1 U v1 U v3 U h2 U v2|>=18 
  Case 2: v1[1] eq h1[5] and |h1|=5, |h1 U v1|=8, |h1 U v1 U v3|>=12,
    |h1 U v1 U v3 U h2|=15, |h1 U v1 U v3 U h2 U v2|>=18
  The program below gives 767 Waffle Case 1 solutions with d=19 in 3.0 hrs.
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

Words:=NewWords; // just consider `non-swapable' words
Solutions:=[]; // Waffle solutions with >=19 distinct letters
c19:=0; // number of Waffle solutions with >=19 distinct letters found so far
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
            if #Chars ge 19 then
	      c19+:=1;Append(~Solutions,Waffle);
	      print "T,c19,#C,W,M=",Round(Cputime()),c19,#Chars,Waffle,M;
	    end if;
          end for;
	end for;
      end for;
    end for;
  end for;
end for;
Case1Solutions:=Solutions;
// Case2Solutions:=Solutions; // *Case 2*
```