---
title: Balancing a wheeled inverted pendulum
---

**This problem is still work in progress.**

Consider the wheeled inverted pendulum decpited in Figure \ref{fig:wheeled-inverted-pendulum}:

![Wheeled inverted pendulum model.](figures/wheeled-inverted-pendulum.svg){#fig:wheeled-inverted-pendulum height=15em}

Its equation of motion is:

$$
\ell \ddot{\theta} = g \sin(\theta) - \ddot{r} \cos(\theta)
$$

The wheel motor is commanded in wheel acceleration $\ddot{\phi}$, which is proportional to the ground acceleration $\ddot{r} = \rho \ddot{\phi}$. We therefore choose our control input as:

$$
u = \ddot{r}
$$

One way to characterize whether the robot "can balance" from a state is viability: a state $x(0) = [\theta\ r\ \dot{\theta}\ \dot{r}]$ of the robot is said to be *viable* if and only if there exists control inputs $u(t)$ such that, integrating the equation of motion above, there exists a future time $T \geq 0$ where the robot is back at its reference position $x(T) = x_{\mathrm{ref}} = [0\ 0\ 0\ 0]$.

## Question 1

In this question, the system starts from an initial state $x(0) = [\theta_{\mathrm{i}}\ 0\ 0\ 0]$. The wheel motor has a maximum acceleration yielding a control input constraint $u \leq a_{\mathrm{max}}$. What is the maximum initial angle $\theta_{\mathrm{i,max}}$ from which the robot can balance?

- Remember that, if $x_{\mathrm{ref}}$ is accessible from $x(0)$, then there exists a minimum-time trajectory from $x(0)$ to $x_{\mathrm{ref}}$ [1].
- We will admit that time-optimal solutions for this system are bang-bang, *i.e.*, $\forall t, u(t) = \pm a_{\mathrm{max}}$.

## References

[1] Theorem 3.1.1 in *Contrôle optimal: théorie & applications*, E. Trélat, 2005.
