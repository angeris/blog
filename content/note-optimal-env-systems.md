+++
title = "A note on \"Optimal Design of Controlled Environment Agricultural Systems (...)\""
date = Date(2021, 3, 17)
+++

This is just a basic note on Cetegen and Stuber's paper (apologies for the paywall) published a few days
ago, [*Optimal Design of Controlled Environment Agricultural Systems Under Market Uncertainty*](https://www.sciencedirect.com/science/article/pii/S0098135421000636). This post "simplifies" problem (4) from a bilevel optimization problem to a single (convex) optimization problem which can be readily solved. As a side note, I only skimmed the references provided, and some were too complicated for me to understand, especially at first glance.[^wat] It is possible this technique is well known in the specific literature referenced, but hidden under mountains of notation and definitions. I also note that this is not the problem they (approximately) solve, but the method presented here might be useful in that case, too.

## The One (Duality) Trick Doctors Don't Want You To Know™

I've used this trick before in a few other papers, with the main example being a paper coauthored with Kunal Shah and Mac Schwager, found [here](https://arxiv.org/abs/1905.12875), specifically in equation (8) and below, starting on page 10.

The basic (very general!) idea is to replace a "min-max" optimization problem with a "min" optimization problem. For example, say we are given the following
optimization problem
$$
\begin{aligned}
& \text{minimize} && \max_{g(y) \le 0} f(x, y)\\
& \text{subject to} && h(x) \le 0,
\end{aligned}
$$
with variables $x \in \mathbb{R}^m$ and $y \in \mathbb{R}^n$ and functions $f : \mathbb{R}^m \times \mathbb{R}^n \to \mathbb{R}$, $g:\mathbb{R}^n \to \mathbb{R}$, and $h: \mathbb{R}^m \to \mathbb{R}$. Now, consider the usual Lagrangian of the "inner problem" (the one with the max over $y$), which we know is
$$
L(x, y,\lambda) = f(x, y) - \lambda g(y).
$$
If we define
$$
\bar f(x, \lambda) = \sup_{y} L(x, y, \lambda),
$$
then, for any $\lambda \ge 0$ and any feasible $y$ (*i.e.*, $y$ that satisfies $g(y) \le 0$), we have that
$$
\bar f(x, \lambda) \ge L(x, y, \lambda) = f(x, y) - \lambda g(y) \ge f(x, y).
$$
(The first inequality follows from the definition of $\sup$ while the last inequality follows since $\lambda \ge 0$ and $g(y) \le 0$ which means that $\lambda g(y) \le 0$.)
So, for any $x$, we know that, if you give me any $\lambda \ge 0$, then $\bar f(x, \lambda)$ is an "overestimator" of $f(x, y)$ for any feasible $y$. 

But, since this is true for any $\lambda \ge 0$ and $x$, then certainly
$$
\inf_{\lambda \ge 0} f(x, \lambda) \ge \sup_{g(y) \le 0} f(x, y),
$$
for any $x$.[^weakduality]

If we use our new overestimator $\bar f$ instead of $f$, our new problem is now a simple optimization problem
$$
\begin{aligned}
& \text{minimize} && \bar f(x, \lambda)\\
& \text{subject to} && h(x) \le 0\\
&&& \lambda \ge 0,
\end{aligned}
$$
that is not in min-max form and requires no other special techniques to solve. The optimal value of this problem need not be the same as that of the original, but is always guaranteed to be at least as large.

Of course, this *can* help, but it certainly doesn't solve our problem. We just need one more piece to the puzzle!

### The hammer

If you've studied a bit of convex analysis the punchline is this: the inequality we have for $f$ and $\bar f$ above holds exactly at equality when $f$ is concave in $y$ and $g$ is convex in $y$. More specifically
$$
\inf_{\lambda \ge 0} \bar f(x, \lambda) = \sup_{g(y) \le 0} f(x, y),
$$
for any $x$.[^strongduality]

When this is true, the new problem has the same optimal value as the original and any solution $x$ for the original is a solution to the new problem! (Why?)

I won't cover more since the specifics don't matter too much, but the general idea is simple enough, and we now have all the parts to convert the min-max problem (4) of Cetegen and Stuber to a simple convex optimization problem.

### The (new and shiny) problem

Things are mostly algebra from here on out, so apologies in advance, I guess. I will leave much of the "hard" work to the reader :)

The complete problem (4) is, as written in the paper, using (mostly) their notation:
$$
\begin{aligned}
    & \text{minimize} && \max_{M \in \mathcal{M}} x^TMx \\
    & \text{subject to} && r^Tx \ge r_\mathrm{min}\\
    &&& 1^Tx = 1\\
    &&& 0 \le x \le 1,
\end{aligned}
$$
with variable $x \in \mathbb{R}^n$, where $r$ is some vector of returns (but the specifics don't matter) and $\mathcal{M}$ is:
$$
\mathcal{M} = \{M \ge 0 \mid M^-_{ij} \le M_{ij} \le M^+_{ij}, ~~ i, j=1, \dots, n\}.
$$
In other words, $\mathcal{M}$ is the set of positive semidefinite matrices ($M \ge 0$) whose entries lie between those of $M^-$ and $M^+$. I've also dropped some constant terms in the objective since those don't change the problem.

In this case, the "inner" optimization problem is the one in the objective, which is just
$$
\begin{aligned}
    & \text{maximize} && x^TMx \\
    & \text{subject to} && M^-_{ij} \le M_{ij} \le M^+_{ij}, ~~ i, j=1, \dots, n\\
    &&& M \ge 0,
\end{aligned}
$$
with variable $M \in \mathbb{R}^{n\times n}$. We can easily write a (slightly not canonical) Lagrangian:
$$
L(x, M, \Lambda^+, \Lambda^-) = x^TMx - \mathrm{tr}(\Lambda^+(M - M^+)) + \mathrm{tr}(\Lambda^-(M - M^-)),
$$
where $\Lambda^+, \Lambda^- \in \mathbb{R}^{n\times n}_+$ are elementwise nonnegative. (The Lagrangian is non-canonical because I have not included the constraint $M \ge 0$, which we will enforce below.) It is not hard to show that
$$
\sup_{M \ge 0} L(x, M, \Lambda^+, \Lambda^-) = \begin{cases}
    \mathrm{tr}(\Lambda^+M^+) - \mathrm{tr}(\Lambda^-M^-) & xx^T \le \Lambda^+ - \Lambda^-\\
    + \infty & \text{otherwise}.
\end{cases}
$$
As before, the inequality between matrices is with respect to the semidefinite cone.

Plugging this back into the original problem formulation, we now have a convex optimization problem:
$$
\begin{aligned}
    & \text{minimize} &&  \mathrm{tr}(\Lambda^+M^+) - \mathrm{tr}(\Lambda^-M^-)\\
    & \text{subject to} && r^Tx \ge r_\mathrm{min}\\
    &&& xx^T \le \Lambda^+ - \Lambda^-\\
    &&& 1^Tx = 1\\
    &&& 0 \le x \le 1\\
    &&& \Lambda^+_{ij}, \Lambda^-_{ij} \ge 0, \quad i,j =1, \dots, n.
\end{aligned}
$$
The (extra!) variables $\Lambda^+, \Lambda^- \in \mathbb{R}^{n\times n}$ are included along with the original variable $x \in \mathbb{R}^n$, and the same problem data as before. This problem, by use of the Schur complement applied to the semidefinite inequality, is easily recast into standard SDP form and can be solved by most standard convex optimization problem solvers, such as [SCS](https://github.com/cvxgrp/scs) or [Mosek](https://www.mosek.com).

Quick edit (3/18/22): Thanks to [bodonoghue85](https://twitter.com/bodonoghue85) for [finding a typo](https://twitter.com/bodonoghue85/status/1372634252924358662)!

<!-- Footnotes -->


[^wat]: See, *e.g.* page 429 of [this paper](https://aiche.onlinelibrary.wiley.com/doi/epdf/10.1002/aic.690290312), where they seem to re-prove basic things like "the supremum of a bunch of convex functions is convex," and "partial minimization of a convex function is convex," but I'm honestly not 100% sure.

[^weakduality]: This is called *weak duality*, *c.f.* sections 5.1.3 and 5.2.2 of [Convex Optimization](https://web.stanford.edu/~boyd/cvxbook/).

[^strongduality]: This is often referred to as *strong duality*, *c.f.* section 5.3.2 of [Convex Optimization](https://web.stanford.edu/~boyd/cvxbook/). There are some additional conditions for equality to hold, but these are almost always met in practice.