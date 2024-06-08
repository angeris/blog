+++
title = "Another short proof of OCO and miscellanea"
date = Date(2024, 3, 27)
+++

A short post with two silly, but ultimately useful, results. The first is [yet
another proof of OGD being low regret](/content/direct-oco-proof). The second
is that the last iterate, or even the average iterate (or, indeed, any convex
combination of the iterates) can be very far away from the optimal point, even
though they are low regret, without further assumptions on the functions we are
optimizing over.

Why yet another proof? No idea. OCO still feels incredibly magical to me on
many levels and getting several clean proofs is usually useful for
understanding that kind of thing.

On the other hand, I'm not sure this gets anyone closer to that goal, but it's
(probably) worth pursuing anyways.

## (Yet another) Proof of the regret of online gradient descent
Using an identical set up and notation to the [previous post on
OCO](/content/direct-oco-proof) note that, given subgradient $g_t \in \reals^n$
bounded by $L > 0$, we only have to bound the quantity
\[
    \sum_{t=1}^T g_t^T(x_t - x^\star).
\]
Here, for $t=0, \dots, T$, we define
\[
    x_{t+1} = x_t - \eta g_t,
\]
and $x^\star \in \reals^n$ is any point in some bounded subset with
diameter at most $M > 0$.

The new proof is almost silly. Let $\|z\|^2 = z_1^2 + \dots + z_n^2$ be the sum
of squares norm, then
\[
    0 \le \|x_{T+1} - x^\star\|^2.
\]
But, $x_{T} = x_{T-1} - \eta g_t$, so
\[
    \begin{aligned}
        0 \le \|x_{T+1} - x^\star\|^2 &= \|x_{T} - x^\star\|^2 - 2\eta g_T^T(x_T - x^\star) + \eta^2 \|g_T^2\|^2 = \dots\\
        &= \|x_0 - x^\star\|^2 - 2\eta \sum_{t=1}^T g_t^T(x_t - x^\star) + \eta^2 \sum_{t=1}^T \|g_t\|^2.
    \end{aligned}
\]
Rearranging gives
\[
    \sum_{t=1}^T g_t^T(x_t - x^\star) \le \frac{1}{2\eta}\|x_0 - x^\star\|^2 + \frac{\eta}{2} \sum_{t=1}^T \|g_t\|^2.
\]
The rest is mechanical of course, but it's worth writing anyways. Using our
bounds on the diameter of the domain and the gradients, we get
\[
    \sum_{t=1}^T g_t^T(x_t - x^\star) \le \frac{M^2}{2\eta} + \frac{\eta TL^2}{2},
\]
and, setting $\eta = M/(L\sqrt{T})$ gives the result
\[
    \sum_{t=1}^T g_t^T(x_t - x^\star) \le \frac{ML\sqrt{T}}{2}.
\]
Funnily enough, note that this bound is slightly tighter than the previous one
by a factor of 2, even though the previous proof relied on an exact rewriting.

### Projected online gradient descent
Another nice point is that this proof immediately carries over to the projected
case, unlike the previous one. Say the optimal point $x^\star$ lies in some
closed, convex set $C\subseteq \reals^n$ with diameter at most $M$, then, let
$\Pi(x)$ denote the projection of $x$ onto $C$, defined
\[
    \Pi(x) = \argmin_{z \in C} \|z - x\|^2.
\]
(We can say *the* projection, since this is unique from the convexity of $C$.)
A fun exercise is to note that, for any two points $x, y\in \reals^n$ the
projection satisfies
\[
\|\Pi(x) - \Pi(y)\|^2 \le \|x - y\|^2.
\]
In other words, the projection $\Pi$ is *nonexpansive*.

Anyways, in this case, note that the gradient update step is given by
\[
    x_{t+1} = \Pi(x_t - \eta g_t);
\]
*i.e.*, we project $x_t$ into the set $C$ after every gradient update.
The proof, using the fact that $\Pi$ is nonexpansive, is essentially
identical to the previous proof since
\[
    0 \le \|x_{T+1} - x^\star\|^2 = \|\Pi(x_T - \eta g_T) - x^\star\|^2 \le \|x_T - \eta g_T - x^\star\|^2.
\]
(Note the second inequality, there.) The rest of the proof proceeds identically
as the previous one, except instead of exact equalities, we have inequalities
coming from the nonexpansiveness property of $\Pi$.

## No bounds on distance
The above proof is kind of interesting: we used the (trivial) inequality
\[
    \|x_{T+1} - x^\star\|^2 \ge 0,
\]
to get a fairly tight bound on the regret. This 'suggests' (to me, at least)
that this bound is likely somewhat tight in many cases, might it be 'close
to tight' in general? By this I mean, is it the case that
\[
    \|x_{T+1} - x^\star\|^2 \approx 0,
\]
for some notion of $\approx$?

Certainly, this is true in the case where $g_t$ are the subgradients of some
fixed function evaluated at the $x_t$ (that is, when $g_t \in \partial f(x_t)$
for some $f$) and $x^\star$ is, say, the unique minimizer of $f$. Might it be
true in the more general scenario where the $g_t$ are adversarial?

Unfortunately the answer is no.

Indeed, we can show that there is a (silly) set of gradients $g_t$ such that
the distance between the last iterate (or, really, any iterate, or convex
combination of the iterate, such as the average) and the $x^\star$ that
maximizes the regret bound is the diameter of the set.

Let $C$ be any compact convex set with diameter $M$, then there are points
$x_0$ and $y$ such that $\|x_0 - y\| = M$. Now, let $g_t = 0$ for $t=1, \dots,
T-1$ and $g_T = \alpha(x_0 - y)$, where $\alpha = L/\|x_0 - y\|$, which we can
do as adversaries. Then the $x^\star$ that maximizes regret is
the one that solves
\[
\min_{z \in C} \left(\sum_{t=1}^T g_t^Tz\right) = \min_{z \in C} \left((x_0 - y)^Tz\right),
\]
with minimizer $x^\star = y$. Since $x_T = x_0$ then it's game over since
$\|x_0 - x^\star\| = M$. It's clear that any convex (indeed, affine)
combination of the $x_t$ is always equal to $x_0$, so, unlike in the stochastic
case, this does not help either.

### Linearity is hard
The main problem with the above is that (a) we have to choose a move before the
last gradient is revealed to us, and (b) the maximizers of linear functions are
*extremely sensitive* to the parameters of the problem. This means that even a
very small change in the gradients can have drastic movements in $x^\star$,
which prevents us from getting control over these conditions.

One 'simple-ish' technique for getting rid of this sensitivity is to assume
that the functions $f_t$ are strongly convex. It is not quite 100% clear to me
if, in this case, the last iterate (or, say, the average iterate) is close to
the unique minimizer $x^\star$, but it does seem likely.

I unfortunately cannot find an easy source for this on my (admittedly cursory)
glance, but if there is one, that would be great!


