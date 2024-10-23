# Humanoid hip workout

*Author:* [\@stephane-caron](https://github.com/stephane-caron)

Consider a humanoid robot in the following configuration:

![JVRC humanoid model lying on a horizontal floor.](figures/jvrc-abs.svg){#fig:jvrc-abs width=60%}

We consider the problem in the sagittal plane. The robot is lying on a horizontal floor, holding a static posture where its hips are making an angle $\varphi$ with the horizontal.

Let us denote by $m_1$ and $G_1$ the total mass and center of gravity of the robot's upper body (all links above the hips, red in Figure \ref{fig:jvrc-abs}), and similarly $m_2, G_2$ for the legs (blue in Figure \ref{fig:jvrc-abs}).

- **Question 1:** *What angle $\varphi$ maximizes the hip torque $\tau$?*

We assume that all forces between the floor and the back of the robot are exerted over a horizontal surface located at an altitude $\delta z$ below the center of gravity $G_1$.

- **Question 2:** *What is the largest angle $\varphi$ at which the robot can lift its legs while keeping its back flat on the floor?*
