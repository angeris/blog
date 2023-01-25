+++
title = "When are fields bounded over all possible designs?"
date = Date(2022, 4, 17)
draft = true
+++

There are a few important questions that popped up while writing many
of the bounds present in [this paper](https://arxiv.org/abs/2011.08002).
One of the main questions that popped up repeatedly was: when are the
solutions to the physics equation bounded over all possible designs?

One specific case in which this question is useful is in the field bounds
paragraph in pages 18 and 19 of [the paper](https://arxiv.org/abs/2011.08002),
though more generally this question can also help answer a number of other
important results (which we do not mention here).

Unfortunately, this post will end in a bit of a disappointing note:
the result given here depends on some condition which is likely not
easy to check in practice. On the other hand, it does lead to a suggestive
definition I have never seen before of an "elementwise nonexpansive operator."
I would be quite curious to see if anyone had any references!

## Problem formulation
In this case, we will again focus on the *diagonal physics
equation*. Here, the physics equation is:
$$
    (A + \mathbf{diag}(\theta))z = b,
$$
where $\theta \in \reals^n$ are the design parameters
(usually the permittivities in many problems) while
$z \in \reals^n$ are the fields. In general, we are only
allowed to choose parameters within a certain range,
so we will write this as
$$
-1 \le \theta \le 1,
$$
without loss of generality. (In particular, if $\theta$
is constrained to lie within any range, we can always
rescale the physics equation to make $\theta$ lie between
$-1$ and $1$. For more details on how to do this,
see section 1.2 of [the paper](https://arxiv.org/pdf/2011.08002).)

### Eliminating the design variable
Taking this formulation, we can "eliminate" the design parameter.
In other words, we will write a number of equations, depending only
on the variable $z$, such that, when $z$ satisfies all the equations,
there exists some design $\theta \in [-1, 1]^n$ which makes
the physics equation true.

To do this, note that, we can take the initial physics equation and
rearrange it as follows:
$$
Az - b = -\mathbf{diag}(\theta)z.
$$
Taking the elementwise absolute value of both sides gives
$$
|Az - b| = |\mathbf{diag}(\theta)z|.
$$
(Here, we interpret $|\cdot|$ to be elementwise.)
Because $|\theta| \le 1$, we can see that
$$
|\mathbf{diag}(\theta)z| \le |z|,
$$
so
$$
|Az - b| \le |z|.
$$
In fact, $|\mathbf{diag}(\theta)z| \le |z|$ is true if, and only if, $|\theta| \le 1$.
Meaning the inequality we just derived, depending only on $z$,
is true if, and only if, there exists some design $\theta$
satisfying $|\theta| \le 1$ that makes the original
physics equation true.

The nice part about this equation is that it encapsulates all of the important
parts of the problem in a simple-to-reason-about format. (It also suggests some
[interesting heuristics](https://www.nature.com/articles/s41598-021-92451-1),
but that's for another time!)

## When are fields bounded?
Now, finally, to answer the question! At least partially.

The proof technique here is relatively simple: we will 
