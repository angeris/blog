+++
title = "A non-counting lower bound for the expected distance of a simple random walk"
date = Date(2023, 6, 20)
+++

It's been a while since I've updated the blog (likely due to the fact that I've been struggling to get it to work with Github pages...).
Anyways, it'll, at some point, be migrated over, but for now this will have to do.

This post will focus on a particular, nearly silly, proof of a lower bound for the distance of an unbiased random walk, defined as
\[
X = \sum_{i=1}^n X_i,
\]
where $X_i \sim \{\pm 1\}$, uniformly. The quantity we want to find a lower bound to is
\[
\E[|X|],
\]
as $n$ is large. We know from a basic, if somewhat annoying, counting argument that
\[
\mathbf{E}[|X|] \sim \sqrt{\frac{2}{\pi}}\sqrt{n},
\]
when $n \gg 1$. In general, we're interested in bounds of the form
\[
\E[|X|] \ge \Omega(\sqrt{n}).
\]
Bounds like these are applicable in a number of important lower bounds for online convex optimization
(see, *e.g.*, Hazan's [lovely overview](https://arxiv.org/abs/1909.05207), section 3.2) though we won't
be talking too much about the applications on this one.

Additionally, since $\E[X^2] = n$ (which follows by expanding and using the fact that $X_i$ are independent with mean zero)
then
\[
    \E[|X|] \le \sqrt{\E[X^2]} = \sqrt{n},
\]
so we know that this bound is tight up to a constant. The first inequality here follows from an application
of Jensen's inequality to the square root function (which is concave).

## Why a non-counting proof?

Mostly because I'm bad at counting and always end up with a hilarious number of
errors. Plus, this proof is easily generalizable to a number of other similar
results!

## Proof idea
One simple method for lower-bounding the expectation of a variable like $|X|$ is to note that
$|X|$ is nonnegative, so we have the following 'silly' bound
\[

\E[|X|] \ge \E[a\ones_{|X| \ge a}] = a \Pr(|X| \ge a),
\]
for any $a \ge 0$, where $\ones_{|X| \ge a}$ is the indicator function for the
event $|X| \ge a$, that is 1 if $|X| \ge a$ and zero otherwise. (The bound
follows from the fact that $|X| \ge a \ones_{|X|\ge a}$ pointwise.) Maximizing
over $a$, assuming we have a somewhat tight lower bound over the probability
that $|X| \ge a$, then this approach might give us a reasonable lower bound.

In a very general sense, we want to show that $|X|$ is 'anticoncentrated'; *i.e.*, it is reasonably
'spread out', which would indicate that its expectation cannot be too small, since it is nonnegative.


## Attempt #1
The first idea (or, at least, my first idea) would be to note that, since $\E[X^2]$ is on the order of
$n$, then maybe we can use this fact to construct a bound for $\E[|X|]$ which 'should be' on the order
of $\sqrt{n}$ assuming some niceness conditions, for example, that $|X| \le n$ is a bounded variable.

Unfortunately, just these two simple facts are not enough to prove the claim! We can construct a nonnegative
random variable $Y\ge 0$ such that its second moment is $\E[Y^2] = n$, it is bounded by $Y \le n$, yet $\E[Y] = 1$.
In other words, we wish to construct a variable that is very concentrated around $0$, with 'sharp' peaks at larger
values.

Of course, the simplest example would be to take $Y = n$ with probability $1/n$
and $Y=0$ with probability $1-1/n$. Clearly, this variable is bounded, and has
$n$ as its second moment. On the other hand,
\[
\E[Y] = (1/n)n + (1-1/n)0 = 1,
\]
which means that the best bound we can hope for, using just these conditions
(nonnegativity, boundedness, and second moment bound) on a variable, is a
constant. (Indeed, applying a basic argument, we find that this is the smallest
expectation possible.)

This suggests that we need a little more control over the tails of $|X|$, which
gets us to...

## Attempt #2 (and solution)
Another easy quantity to compute in this case is $\E[X^4]$. (And, really, any
even power of $X$ is easy. On the other hand, since $X$ has a distribution that
is symmetric around 0, all odd moments are 0.) Splitting the sum out into each
of the possible quartic terms, we find that any term containing an odd power of
$X_i$ will be zero in expectation as the $X_i$ are independent. So, we find
\[
\E[X^4] = \sum_{i} \E[X_i^4] + \sum_{i\ne j} \E[X_i^2X_j^2] = n + 3n(n-1) \le 3n^2.
\]
This quantity will come in handy soon.

We can, on the other hand, split up the expectation of $X^2$ in a variety of ways.
One is particularly handy to get a tail *lower bound* like the one we wanted in our
proof idea (above):
\[
\E[X^2] = \E[X^2\ones_{|X| < a}] + \E[X^2\ones_{|X| \ge a}] \le a^2 + \E[X^2\ones_{|X| \ge a}].
\]
The latter term can be upper bounded using Cauchy--Schwarz,[^csproof]
\[
\E[X^2\ones_{|X| \ge a}] \le \sqrt{\E[X^4]}\sqrt{\E[\ones_{|X| \ge a}]}.
\]
(Since $\ones_{|X| \ge a}^2 = \ones_{|X| \ge a}$.) And, since $\E[\ones_{|X| \ge a}] = \Pr(|X| \ge a)$,
we finally have:
\[
\E[X^2] \le a^2 + \sqrt{\E[X^4]}\sqrt{\Pr(|X| \ge a)}.
\]
Rearranging gives us the desired lower bound,
\[
\Pr(|X| \ge a) \ge \frac{(\E[X^2] - a^2)^2}{\E[X^4]}.
\]
(This is a Paley--Zygmund-style bound, except over $X^2$ rather than nonnegative $X$.)

Now, since we know that
\[
\E[|X|] \ge a \Pr(|X| \ge a),
\]
then we have
\[
\E[|X|] \ge a \frac{(\E[X^2] - a^2)^2}{\E[X^4]}.
\]
Parametrizing $a$ by $a = \alpha\sqrt{\E[X^2]}$ for some $0 \le \alpha \le 1$, we then have
\[
\E[|X|] \ge \alpha(1-\alpha^2)^2\frac{\E[X^2]^{3/2}}{\E[X^4]}.
\]
The right-hand-side is maximized at $\alpha = 1/\sqrt{5}$, which gives the following
lower bound
\[
\E[|X|] \ge \frac{16}{25\sqrt{5}}\frac{\E[X^2]^{3/2}}{\E[X^4]}.
\]
And, finally, using the fact that $\E[X^2] = n$ and $\E[X^4] \le 3n^2$, we get the final result:
\[
\E[|X|] \ge \frac{16}{75\sqrt{5}}\sqrt{n} \ge \Omega(\sqrt{n}),
\]
as required, with no need for combinatorics! Of course the factor of
$16/(75\sqrt{5}) \approx .095$ is rather weak compared to the factor of
$\sqrt{2/\pi} \approx .80$, but this is ok for our purposes.

## General extensions
Of course, similar constructions also hold rather nicely for things like
uniform $[-1, 1]$ variables, or Normally distributed, mean zero variables. Any
variable for which the second and fourth moment can be easily computed allows
us to compute a lower bound on this expectation. (Expectations of the absolute
value of the sums of independently drawn versions of these variables could be
similarly computed.) These have no obvious combinatorial analogue, so those
techinques cannot be easily generalized, whereas this bound applies immediately.

## Thanks
A big thank you to [George
Lowther](https://twitter.com/Almost_Sure/status/1755601562737737766) for
pointing out that I was missing a factor of 3 in the fourth moment calculation
in an earlier version of this post!



[^csproof]: Possibly the most elegant proof of Cauchy--Schwarz I know is based on minimizing a quadratic, and goes a little like this. Note that $\E[(X - tY)^2]\ge 0$ for any $t \in \reals$. (That this expectation exists can be shown for any $t$ assuming both $X$ and $Y$ have finite second moment. If not, the inequality is also trivial.) Expanding gives $\E[X^2] - 2t\E[XY] + t^2\E[Y^2] \ge 0$. Minimizing the left hand side over $t$ then shows that $t^\star = \E[XY]/\E[Y^2]$, which gives \[ \E[X^2] - \frac{\E[XY]^2}{\E[Y^2]} \ge 0.\] Multiplying both sides by $\E[Y^2]$ gives the final result.
