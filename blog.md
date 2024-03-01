---
layout: page
title: Blog
permalink: /Blog/
---

<h2> How to describe relatives with up-down notation</h2>

It is very clear that a lot of children and even adults struggle with
the nomenclature for relatives, and understanding where relatives fit onto
the family tree. What do I call my cousin's daughter? How am I related to
my father's cousin? A solution is to view your relatives as located at the
vertices of a binary tree, and use the mathematical fact that there is a
unique path from any one vertex on the tree to another. Then you just need to
describe how many steps from you *up* to a common ancestor, and then *down* to
your relative. For example, with this naming scheme your cousin is called
2-up-2-down because you must go up two steps (parent, then grandparent)
to a common ancestor, and two steps down (to aunt or uncle), and then to
their child (your first cousin).

Here is a small dictionary: a sibling is 1-up-1-down, a parent is 1-up,
a son/daughter is 1-down, a grandson/daughter is 2-down and a
grandmother/father is 2-up. A second cousin is 3-up-3-down and a third cousin
is 4-up-4-down. If you go down one more than you go up, then you say "once
removed". Hence your first cousin once removed is 2-up-3-down, and a second
cousin once removed is 3-up-4-down.

Unfortunately, our naming system for relatives also uses "once removed" if
you go up one more than you go down. Hence 3-up-2-down is also called
your second cousin once removed. At this point, I think you can see that our
naming system for relatives is not up to the job, and up-down notation
is much clearer.

Genealogists know all of this intuitively, but tend not to describe relations
via the position on a binary tree. Hence they take a lot of words to distinguish
between 2-up-3-down and 3-up-2-down. I prefer to use this compact unambiguous
notation to describe complicated relationships. I am not suggesting calling
your sibling 1-up-1-down or your parent 1-up, but cousins and beyond would be
fair game. The notation is gender-neutral, which some may like, but many
genealogist will dislike. It is shorter to say my aunt than my female
2-up-1-down, or my nephew than my male 1-up-2-down. A good compomise
is to use *both* naming systems: choosing the one that is brief, unambiguous
and easy to understand. To help learn the system up-down system here is a
[Table of Consanguinity](files/TableOfConsanguinityLandscape.pdf) source [Wikipedia](https://en.wikipedia.org/wiki/Consanguinity).

<h2> Why so few open access journals?</h2>

Mathematicians are good at seeing how to solve problems, but how good
are they at implementing the solutions?

In 2012 Tim Gowers wrote a
[blog](https://gowers.wordpress.com/2012/01/21/elsevier-my-part-in-its-downfall/)  that went viral.
He described how mathematics was being negatively impacted by Elsevier, and
it did not need to be. Mathematicians can set up high quality journals
which are free to the user, or very low cost. Your university library has likely
cut the number of journals it offers because it can not afford the
astronomical prices of journals offered by large publishers such as Elsevier/Taylor-Francis.

One of the oldest electronic journals, founded in 1994 by Herbert S. Wilf
and Neil Calkin, is
[The Electronic Journal of Combinatorics](https://www.combinatorics.org/).
Since then there have been others including:
+ Enumerative Combinatorics and Applications,
+ Algebraic Combinatorics,
+ Advances in Combinatorics,
+ Discrete Analysis,
+ Ars Inveniendi Analytica.

I am surprised that the list of Open Access, arXiv overlay journals is so
small and that commercial publishers abound. There are many commercial
journals (as opposed to society journals) with very low academic standards
and fewer with high academic standards which are very expensive and
lock up mathematical research via expensive paywalls and, at times,
lengthy copyright agreements.

If you do not know about the many benefits, and few challenges, associated
with Open Access publishing, then you may be interested in
[Open Access Directory](http://oad.simmons.edu/oadwiki/Main_Page).

For an informative (if lengthy) historical account of background to
this area, see the [letter](files/joalet.pdf) from Donald E. Knuth to fellow members
of the Journal of Algorithms editorial board outlining the problem, describing
the open-access solution.

A list of journals whose editorial boards have resigned can be found
[here](http://oad.simmons.edu/oadwiki/Journal_declarations_of_independence).

So my questions are: Why are there so few Open Access journals? and
Why do ruthless commercial publishers like Elsevier/Springer have such a
strong hold on academic publishing (in mathematics).

Of course academics trade in reputation/status, and if commercial journals
are perceived to have higher status than society journals (because they cost
much more, for example), then there will be some academics who will wish to
submit to, referee for, and act as editors for, commercial journals even if it is to the long-term detriment of mathematics.
In a separate blog I will consider best practice academic publishing: how are
errors/updates handled? when non-trivial computer programs form part of a proof
is computer code stored? is mathematical research immediately available?
Can mathematics flourish with 5, 10, 20 year copyright agreements? etc

<hr />
<h2> How should we handle errors?</h2>

It is no surprise that there are many more mathematical papers published now
than previously. Data from the International Association of Scientific,
Technical and Medical Publishers (STM) from 1968-2018 can be seen
[here](https://academia.stackexchange.com/questions/126980/global-number-of-publications-over-time). They show a threefold increase from 1980 to 2012 and a
five-sixfold increase from 1975 to 2018. It is reasonable to assume that the
number of mathematical errors have increased proportionally, or maybe at a
greater rate as the number of publications per mathematician grows.

Some mistakes are worse than others. The simplest mistake is a typo, and this is
can commonly be detected and corrected, but occasionally the typo occurs in
a complex mathematical expression and correction is not straightforward.
Sometimes authors give incomplete arguments and while the reader may believe
the claimed result, the proof might be have a gap. Of course there are examples
also of results/statements that are just plain wrong. The last two examples
raise questions of what should be done for the paper concerned and for
the papers that rely on erroneous or incomplete arguments.

Over the last century many databases of groups have been published
(*p*-groups, simple groups, primitive groups, groups of ``small'' order).
Many had errors of omission, of duplication, or incorrect entries commonly
due to typos or transcription errors. For example, 
the number of groups of order
1024 was believed to be 49,487,365,422 for 20 years. However, recently
David Burrell rechecked the original computer calculations and found that
1,867 groups had been omitted from the correct total of 49,487,367,289.
Moreover, software can have bugs, known to experts but not fixed due to lack
of resources. For example a 
[bug](https://github.com/gap-system/gap/issues/3940)
in [GAP](https://www.gap-system.org/), involving isomorphism of groups of
order 512, has not yet been fixed since April 2020. Volunteers are often not
rewarded/regognized for their service.

Proofs that depend on long and complicated arguments, or on
complicated computer calculations, are naturally more prone to error. Worse,
such results are less likely to be rechecked by others, so errors can go
undetected for a long time as illustrated above. I do not believe that
computer-free proofs are less or more error-prone than computer-assisted proofs.
A simple computer check can be more convincing than a very long and complicated
hand calculation. Complexity is the problem. But there is another problem:
many mathematical publications do not have accompanying computer code for a
referee to check. Of course this is not needed for simple computer checks, but
for complicated checks it certainly is, and mathematicians have not collectively
insisted that a complete proof (including supporting calculations) should
be published.

Mathematics builds on itself it a way that is unique in the sciences,
and authors commonly trust the correctness of the published
literature, so it is conceivable that if mistakes proliferate that in
the future Mathematics could face a crisis of reliability. A replication crisis
has been observed in the Medical Sciences, Psychology and other fields since
roughly 2010. These fields have taken a number of steps to address this problem,
see [here](https://en.wikipedia.org/wiki/Replication_crisis). The arbitrary
choice of p < 0.05 for significance, and the attendant problem of p-hacking,
is less of a problem for pure mathematics.
However, other biases such as lack of availability of qualified referees,
pressure to publish, confirmation bias, etc can play a role. Should mathematics
place more emphasis on reproving central results whose veracity has been
checked only by one or two people ever? A rare example of this is the
"The Classification of the Finite Simple Groups" by Gorenstein, Lyons, Solomon.
At the time of writing 8 of the 12 proposed volumes have been written.
It is unclear whether the surviving authors (Lyons and Solomon) will complete
the proof or whether another proof strategy will prevail. It would be a
rude shock if a new finite simple group was discovered (but nobody suspect this).

Mathematics has undergone crises in the past, for example the foundational
problems in set theory and
[problems of rigor in algebraic geometry](https://mathoverflow.net/questions/19420/what-mistakes-did-the-italian-algebraic-geometers-actually-make). It is possible that future mathematics may
inadvertently build large bodies of knowledge based on some erroneous results.

There are many issues: who rechecks results? should MathSciNet be updated
to include errors? what if canonical names for groups in databases change
because of errors? what about publications that depend on flawed results?

Published papers can in principle be updated by using [Crossmark](https://www.crossref.org/services/crossmark/).
This says: *Research doesn't stand still: even after publication, articles can be updated with supplementary data or corrections. It’s important to know if the content being cited has been updated, corrected, or retracted - and that’s the assurance that publishers can offer readers by using Crossmark. It’s a standardized button, consistent across platforms, revealing the status of an item of content, and can display any additional metadata the member chooses. Crucially, the Crossmark button can also be embedded in PDFs, which means that members have a way of alerting readers to changes months or even years after it’s been downloaded.*

<hr />
<h2> Journal of Conjectures and Proof Strategies</h2>

Academics want publications. I will talk about academic mathematicians because I
know them best. Lots of publications improve your chances as an
applicant for a job, or for a promotion. Junior mathematicians are advised to
research safe topics: perhaps were established methods can be applied to
a new problem that has a good chance of success. If the problem has
applications, or is interesting, then the fact that the methods are established
may not be an impediment to publication. Many established mathematicians follow
this lower risk approach.

Should Mathematics encourage more risk-taking?
If so, there had better be publications as a reward.
It is not uncommon for a mathematical paper to include a conjecture or
question, after a series of established theorems/propositions/lemmas.
We tend to be cautious about stating a conjecture: if it can be solved
quickly with little effort, we will feel embarrassed. A mathematician may well
have many reasons for believing a conjecture and maybe has an outline of
a proof but some part can not be completed. The evidence for a conjecture and
strategies for its proof are commonly not published, so different researchers
who try to solve the conjecture may well repeat the same work. If Mathematics
had respected avenues to publish what could be regarded as incomplete work, then
the field may advance more quickly. There are caveats:
1. the work should be on a conjecture of interest to a broad community of mathematicians;
2. the proposed methods/ideas should make notable progress, ideally offering some hope of success;
3. the research should be written in a general manner so that other researchers
  can build on the results to either prove the conjecture or significantly close
  the gap;
4. the paper may include computational evidence that the conjecture is true
  (ideally with well written supporting computer code),  or the paper
  may reduce the problem to a different problem requiring specific expertise.

Is MathOverflow a suitable avenue for such risk-taking? Yes and no. A posting on
MathOverflow is not a refereed journal article, and may not lead to one.
A mathematician may posts 70% of a solution on MathOverflow (I know
that is hard to quantify), and someone may contribute the remaining 30% in
a single author publication generously acknowledging your post. You can
doubtless think of examples where a joint author paper would be more
appropriate. In the competitive world of academia there will be winners and
losers and gracious and ungracious authors. Having a published partial result
is less risky, and more attractive (especially to junior mathematicians).
A 70% proof of the P = NP conjecture may well be easy to get published, but for
less important (but still significant) problems I think you could find it hard
to get your work published by a respectable journal. I wonder whether fictional
journals such as "Journal of Conjectures and Proof Strategies" could
help mathematics advance more rapidly, by reducing the amount of replication,
and by building on the shoulders of other researchers?


