+++
title = "Online gradient descent has low regret: a one-ish-liner"
date = Date(2024, 2, 7)
+++

This post is a bit silly in that this is an obviously well-known result, but
I've never seen a direct proof of this that did not at least introduce some
additional notation. This proof was particularly enlightening to me in
understanding 'why does OCO work', at least, much more so than the standard
"follow the regularized leader" proofs (such as those found
[here](https://www.nowpublishers.com/article/Details/MAL-018)) or more
'direct', but magical proofs, such as the one found
[here](https://people.eecs.berkeley.edu/~brecht/cs294docs/week1/03.Zinkevich.pdf).
If you're familiar with OCO already, you can scroll directly down
[to the almost-two-liner proof](#proof).

## Online convex optimization
The main setting of online convex optimization is as follows. We have two
players, us, and an adversary. The game proceeds in $T$ rounds. At each round
$t$ we have to choose a *move* $x_t \in \reals^n$, and the adversary, *after
observing our move*, gets to then choose some (convex) loss $f_t: \reals^n \to
\reals$ such that we incur a penalty $f_t(x_t)$ for having played move $x_t$.

After this game is over, we then compare our score, which is the sum of all of 
the losses over the $T$ rounds, to the best possible *fixed* strategy, which
we call $x^\star \in \reals^n$:
\[
    R = \sum_{t=1}^T f_t(x_t) - \sum_{t=1}^T f_t(x^\star).
\]
This $R$ is called the **regret** and the best possible fixed strategy, $x^\star$,
is, of course, the one that minimizes the sum of all losses:
\[
    x^\star \in \argmin_x \left(\sum_{t=1}^T f_t(x)\right),
\]
had we known the losses $f_t$ in advance.

The natural question is: just how small can $R$ be? Of course, we need *some*
conditions on $f_t$ and the optimal fixed strategy, $x^\star$, otherwise the
adversary can just grow the function to arbitrary amounts. The simplest
conditions, and the one we will use here, is that (a) the optimal price
$p^\star$ always has a bound $\|p^\star\| \le M$, and (b) that the functions
$f_t$ are $L$-Lipschitz: if $f_t$ are differentiable, then this is saying that
\[
    \|\nabla f_t(y)\| \le L
\]
for any $y \in \reals^n$. (We can relax this condition slightly, but the idea
will be the same.) In both cases, we write $\|\cdot\|$ for the usual Euclidean
norm, and I'll do this for the rest of the post.

## A simple strategy
The simplest strategy that "seems to have the right behavior" is probably
something like gradient descent: at round $t$, use the gradient of the function
at round $t-1$ (which we didn't know until we played $x_{t-1}$, since
the adversary chose it after!) and update slightly in that direction.
Written out, this is
\begin{equation}\label{eq:ogd}
    x_t = x_{t-1} - \eta\nabla f_t(x_{t-1}),
\end{equation}
where $\eta > 0$ is some parameter we will set soon, called the **step size**.
(Keep this in mind as this is the definition of $x_t$ we will use throughout.)
Note that we can write $x_t$ purely in terms of the previously-observed
gradients, since
\[
x_t = -\eta \sum_{\tau=1}^{t-1} \nabla f_\tau(x_\tau).
\]
(We will use this later as well!)

This silly strategy will turn out to be extremely useful in the future. Even
more interesting is that the strategy only depends on the gradient at $x_{t-1}$
and no other information! This setting actually comes up in practice (for
example in [blockchain resource pricing](https://arxiv.org/pdf/2208.07919.pdf),
where you have to set a price before you get to observe the market's reaction)
and can be used to analyze the performance of certain algorithms against
potential adversaries. (We are writing a paper on this particular topic of OCO
applied to resource pricing using the above model, which I'll link here once we
post it.)

## On the regret $R$
At first glance, this problem feels quite difficult! I mean, look: the
adversary can choose *any* functions $f_t$ in *any* way, after observing our
move $x_t$. It's almost like, given so much power, the adversary can always
make the loss roughly linear in the number of rounds $T$: each round, we may
expect to lose some (at least) constant amount from a very adversarial choice
of $f_t$.

Even the strategy above 'feels like' it's not going to do particularly well:
again the functions are chosen *with the knowledge of how we take our steps*!
Why can we expect to do well at all?

What is surprising is, we will show that
\[
    R \le C\sqrt{T},
\]
where $C > 0$ is some constant that depends on the bounds on the gradient $L$
and the bound on the price $M$. Alternatively, we can write this as, on
average, the longer the game continues, the better we perform:
\[
    \frac{R}{T} \le \frac{C}{\sqrt{T}}.
\]
(Again, it's worth reiterating: this is done *even in the presence of
adversarially chosen* $f_t$.) Indeed, after a long enough time scale, we see
that our strategy and the best fixed strategy, with complete knowledge of the
future, are, on average, about the same. Algorithms where the average regret
vanishes have a bit of a silly name, but I'll put it here for anthropological
reasons: they are called **no-regret algorithms**.

## Proof
Anyways, the proof is fairly easy. The first order of events is to note that,
since $f_t$ is convex, then, by definition, we have
\[
    f_t(y) \ge f_t(x_t) + \nabla f_t(x_t)^T(y - x_t),
\]
for any $y \in \reals^n$. (The $x_t$ are chosen in the same
way as the previous section.) This means, letting $g_t = \nabla f_t(x_t)$,
\[
    f_t(x_t) - f_t(y) \le g_t^T(x_t - y).
\]
Summing this and noting it is true for any $y$, then, certainly,
it is true for the optimal strategy, $y = x^\star$, so
\[
    R = \sum_{t=1}^T (f_t(x_t) - f_t(x^\star)) \le \sum_{t=1}^T g_t^T(x_t - x^\star).
\]
We will focus our attention on trying to show this last term, which we call the
**linear bound**, is 'small'.


### An inequality for the linear bound
The inequality is a one-liner and follows easily from the fact that
\[
    R \le \sum_{t=1}^T g_t^T(x_t - x^\star) = \frac{\eta}{2}\sum_{t=1}^T\left\| g_t\right\|^2 - \left\|\sqrt{\frac{\eta}{2}}\tilde g + \sqrt{\frac{2}{\eta}}x^\star\right\|^2  + \frac{2}{\eta}\|x^\star\|^2,
\]
where $\tilde g = \sum_{t=1}^T g_t$, using the definition of $x_t = -\eta
\sum_{\tau=1}^{t-1} g_\tau$. (To see this, expand the right hand side and cancel
terms.) Finally, the middle term is nonpositive, as it is a negative square, so
we get the bound
\[
    R \le \frac{\eta}{2}\sum_{t=1}^T\left\| g_t\right\|^2  + \frac{2}{\eta}\|x^\star\|^2.
\]
Since we know that $\|g_t\| \le L$ and $\|x^\star\| \le M$ by assumption, then
\[
    R \le \frac{\eta L^2 T}{2} + \frac{2M^2}{\eta}.
\]
Finally, choosing $\eta = M/(2L\sqrt{T})$, which minimizes the right hand side,
gives
\[
    R \le ML\sqrt{T},
\]
as required.

## Wait what?

Ok, fine, I'll explain it.

## Explanation
From before, we can write $x_t$ in terms of only the gradients $g_t$:
\[
    x_t = -\eta\sum_{\tau=1}^{t - 1} g_t,
\]
so the first term of the linear bound can be written
\[
    \sum_{t=1}^T g_t^Tx_t = -\eta\sum_{t=1}^T\sum_{\tau=1}^{t-1} g_t^Tg_\tau.
\]
This last double sum should look familiar if you've ever expanded the squared norm
of a sum before, but if you have not then:
\[
    \left\|\sum_{t=1}^T g_t\right\|^2 = \sum_{t=1}^T\left\| g_t\right\|^2 + 2\sum_{t=1}^T\sum_{\tau=1}^{t-1} g_t^Tg_\tau,
\]
so, rearranging,
\[
    \sum_{t=1}^T\sum_{\tau=1}^{t-1} g_t^Tg_\tau = \frac12\left(\left\|\sum_{t=1}^T g_t\right\|^2 - \sum_{t=1}^T\left\| g_t\right\|^2 \right)
\]
Plugging this back into the linear bound, we have
\[
    R \le \sum_{t=1}^T g_t^T(x_t - x^\star) = \frac{\eta}{2}\left(\sum_{t=1}^T\left\| g_t\right\|^2 - \left\|\sum_{t=1}^T g_t\right\|^2\right) - \sum_{t=1}^T g_t^Tx^\star.
\]
Here comes the only interesting part of the proof. (Though, honestly, it's not
even that interesting.) Note that we can pull a cute sleight of hand:
write $\tilde g = \sum_{t=1}^T g_t$ then, we can write the above as
\[
    R \le \frac{\eta}{2}\sum_{t=1}^T\left\| g_t\right\|^2 - \frac{\eta}{2}\|\tilde g\|^2 - \tilde g^Tx^\star.
\]
We can rewrite the last two terms in the following way:
\[
    R \le \frac{\eta}{2}\sum_{t=1}^T\left\| g_t\right\|^2 - \left\|\sqrt{\frac{\eta}{2}}\tilde g + \sqrt{\frac{2}{\eta}}x^\star\right\|^2  + \frac{2}{\eta}\|x^\star\|^2.
\]
(To see this, expand the middle term!) This is exactly the term we found in the previous part!

## Wrapping up
I mean, there isn't much interesting here and really not very much magic. The
one thing this brings up is: what does a 'clean but general' version of this
proof look like? In particular, the only important part of the proof is
recognizing that the interaction between $\tilde g$ and $x^\star$ is, in some
sense, bounded by the norm of $x^\star$ and the individual norms of $g_t$. It
feels like there should be some simple construction which allows this
interaction to be bounded in a more natural way. (Of course, this will play in
a variety of ways with how we choose $x_t$ based on the gradients and such.)

I should note that this bound is tight for any algorithm in that only the
constant can be improved. (In particular, it is possible to construct a
stochastic adversary that always achieves at least $R \ge CLM\sqrt{T}$ regret,
for some $C > 1/4$, no matter how $x_t$ is chosen.) Indeed, this question is
deeply related to the [previous post on finding a lower bound for a random
walk](/content/simple-proof-rademacher/), but I won't go into it here.
