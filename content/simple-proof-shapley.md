+++
title = "A simple proof of Shapley–Folkman"
date = Date(2024, 6, 9)
+++

This post goes over a simple proof of the Shapley–Folkman lemma which I
haven't seen published (though I'm sure everyone has a version or variation of
this sitting around!). It is (roughly) a combination of [Zhao's
proof](https://link.springer.com/article/10.1007/BF01212924) (which uses a
simple result about conic combinations, but has a funky construction) and
[Cassel's
proof](https://www.cambridge.org/core/journals/mathematical-proceedings-of-the-cambridge-philosophical-society/article/abs/measures-of-the-nonconvexity-of-sets-and-the-shapleyfolkmanstarr-theorem/CC6968E282DB5EB24BD6F7400EA2C2A4),
which, while nice, has unfortunately very annoying notation. Specifically, this
post proves the "slightly more general" statement given in Cassel's proof which
is a little nicer to handle, via a technique that is similar to Zhao's, but
uses only linear independence.

Anyways, if you're reading this I probably don't have to convince you
that this lemma is very useful, but, if you're unsure, I'd recommend just
Googling "Shapley–Folkman [your field of choice]" and you'll probably
get a hit or two that might be interesting.

## Statement
The statement of Shapley–Folkman is a little funny if you're unfamiliar with
it, but it's the following.

We have a collection of sets $S_1, \dots, S_m \subseteq \reals^n$, which need
not be convex. Let $y \in \reals^n$ be a vector in the sum of the convex hulls
of these sets; *i.e.*, one which satisfies
\[
    y = x_1 + x_2 + \dots + x_m,
\]
where $x_i \in \conv(S_i)$. Then $y$ can be written in the following way
\[
    y = \tilde x_1 + \tilde x_2 + \dots + \tilde x_m,
\]
where $\tilde x_i \in \conv(S_i)$ and, importantly, for at least $m-n$
indices $i$, satisfies $\tilde x_i \in S_i$. In other words, given any point
$y$ which is the sum of points lying in the convex hulls of the sets,
$\conv(S_i)$, then $y$ can be written as the sum of points lying in the *actual
sets* $S_i$, for 'most' indices $i$; no more than $n$ indices will lie in
$\conv(S_i)$
but not $S_i$.

One simple interpretation of this statement is that, given a lot of sets $S_i$,
relative to the number of dimensions (when $m \gg n$), then the resulting set,
which is the (Minkowski) sum of sets, is 'very close' to a set that is convex.

## Proof
The proof requires a little bit of extra set up, but not too much.

### Statement variation
We will show the proof in an inductive way, with a slightly different set up
than the one above. In our set up, there exist some sets $S_1, \dots, S_m
\subseteq \reals^m$ and some point $y \in \reals^n$ such that
\[
    y = x_1 + \dots + x_m,
\]
and each $x_i \in \conv(S_i)$. Using the definition of the convex hull, this is
the same as saying that, for each set $i=1, \dots, m$, there exist $z_{ij} \in
S_i$ and weights $\gamma_{ij} > 0$ with $j=1, \dots, n_i$, such that
\[
    x_i = \sum_{j=1}^{n_i} \gamma_{ij}z_{ij},
\]
and the weights sum to $1$:
\[
    \sum_{j=1}^{n_i} \gamma_{ij} = 1,
\]
for each $i=1, \dots, m$. In this case, $n_i$ denotes the number of elements of
$S_i$ whose convex combination results in $x_i$, all with nonzero coefficients.
(This is why we require that $\gamma_{ij} > 0$, otherwise, if $\gamma_{ij} = 0$
for some index $j$, we can remove this entry and reduce $n_i$ by 1.) We will
show the following inequality can be made true:
\[
    \sum_{i=1}^m \left(n_i - 1\right) \le n.
\]
This implies the original claim, since $x_i$ lies in $S_i$ if, and only if,
$n_i = 1$, so the sum is an upper bound on the number of sets which have $n_i >
1$; *i.e.*, the largest number of indices $i$ with $n_i > 1$ is $n$, or,
equivalently, at least $m-n$ indices satisfy $n_i = 1$ and therefore have $x_i
\in S_i$.

### Proof
Given that set up, we will show that, if
\[
    \sum_{i=1}^m \left(n_i - 1\right) > n,
\]
then we can always set at least one of the weights $\gamma_{ij}$ to $0$
(potentially changing some other weights along the way) such that the left hand
side decreases by at least 1. Applying this statement inductively gives us the
result.

So, let's get to it!

The one trick in this proof is to note that we can choose a 'privileged'
index $j$, which, in our case, we will just choose to be the first index.
We'll write $x_i$, for each $i$, splitting out the first entry:
\[
    x_i = \gamma_{i1} z_{i1} + \sum_{j=2}^{n_i} \gamma_{ij}z_{ij}.
\]
We interpret the sum on the right as zero if $n_i = 1$. (Note that, by
definition, $n_i$ cannot be zero! So this expression is always well-defined.)

We can then write $y$ as
\[
    y = \sum_{i=1}^m\gamma_{i1} z_{i1} + \sum_{i=1}^m\sum_{j=2}^{n_i} \gamma_{ij}z_{ij}.
\]
Now, if $\sum_{i=1}^m (n_i - 1) > n$, then there are at least $n+1$ vectors in
the second sum and $n$ is the dimension of the vectors. So there exists some weights
$\alpha_{ij} \in \reals$ such that
\[
    \sum_{i=1}^m\sum_{j=2}^{n_i} \alpha_{ij}(z_{ij} - z_{i1}) = 0,
\]
where $i=1, \dots, m$ and $j=2, \dots, n_i$. (Very importantly, note that
the $\alpha_{ij}$ need not be nonnegative!) Because this is zero, we can
multiply it by any constant, $\eta \in \reals$ and add it to our expression
for $y$ to get, for any choice of $\eta$:
\[
    y = \sum_{i=1}^m\left(\gamma_{i1} - \eta \sum_{j=2}^{n_i} \alpha_{ij}\right) z_{i1} + \sum_{i=1}^m\sum_{j=2}^{n_i} (\gamma_{ij} + \eta \alpha_{ij}) z_{ij}.
\]
There exists at least one $\eta$ such that at least one of the terms
\[
    \gamma_{i1} - \eta \sum_{j=2}^{n_i} \alpha_{ij}, \quad \text{or} \quad \gamma_{ij} + \eta\alpha_{ij},
\]
where $i=1, \dots, n$ and $j=1, \dots, n_i$, is equal to zero. The smallest (in
absolute value) such $\eta$ will ensure that all of the terms are nonnegative
and at least one is zero. (Why?) For this $\eta$, define
\[
    \tilde \gamma_{i1} = \gamma_{i1} - \eta \sum_{j=2}^{n_i} \alpha_{ij}, \quad \text{and} \quad
    \tilde \gamma_{ij} = \gamma_{ij} + \eta\alpha_{ij},
\]
for $i=1, \dots, m$ and $j=1, \dots, n_i$. From the definition of $\eta$ and
the discussion above, we know that $\tilde \gamma_{ij} \ge 0$, with at least
one entry zero, and satisfies
\[
    \sum_{j=1}^{n_i} \tilde \gamma_{ij} = \sum_{j=1}^{n_i} \gamma_{ij}  = 1,
\]
for each $i=1, \dots, m$, which is easy to show from the definition. Removing
the nonzero entries, we then reduce at least one $n_i$ by one, proving the
claim.

### Discussion
Interestingly, this procedure is essentially constructive: we only need the
ability to solve a linear system to perform it, but the 'algorithm' provided
will be very slow. (I say "essentially" here, since there's a hidden cost: we
also need to be able to write an explicit convex combination of points in $S_i$
that yield $x_i$; it is not obvious how to do that in general if the set $S_i$
does not admit a simple polyhedral description, but is fairly 'easy' for many
structured sets in practice.)
