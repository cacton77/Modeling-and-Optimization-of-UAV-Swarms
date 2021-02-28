# Modeling-and-Optimization-of-UAV-Swarms

UAV swarms have numerous applications in our modern world.  They can facilitate mapping, observing,and overseeing large areas with ease. It is necessary for these agents to autonomously navigate potentially dangerous terrain and airspace in order to log information about areas. In this project we simulate the motion of a swarm of drones, and their interaction with obstacles, and targets.

The goal of this project is to optimize this simulation using a Genetic Algorithm to maximize the numberof targets mapped, minimize the number of crashed drones, and minimize the amount of time used in thesimulation. To do this we will use 15 design parameters to determine the dynamics and kinematics of eachdrone, using Forward Euler time discretization to update drone positions.

A Genetic Algorithm will be used to train this swarm of drones by generating random strings of design parameters and breeding new strings to find the optimal string for this simulation.

In this paper, I will present relevant background information and equations to describe the simulation. I will also describe the process by which I go about optimizing the Genetic Algorithm. Finally, I present the outcome of the simulation and Genetic Algorithm and discuss the relevance of my results.
