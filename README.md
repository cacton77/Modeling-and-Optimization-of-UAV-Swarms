# Modeling and Optimization of UAV Swarms

## Introduction

UAV swarms have numerous applications in our modern world. They can facilitate mapping, observing, and overseeing large areas with ease. It is necessary for these agents to autonomously navigate potentially dangerous terrain and airspace in order to log information about areas. In this project we simulate the motion of a swarm of drones, and their interaction with obstacles, and targets.

The goal of this project is to optimize this simulation using a Genetic Algorithm to maximize the number of targets mapped, minimize the number of crashed drones, and minimize the amount of time used in the simulation. To do this we will use 15 design parameters to determine the dynamics and kinematics of each drone, using Forward Euler time discretization to update drone positions.

A Genetic Algorithm will be used to train this swarm of drones by generating random strings of design parameters, and breeding new strings to find the optimal string for this simulation.

In this paper, I will present relevant background information, and equations to describe the simulation. I will also describe the process by which I go about optimizing the Genetic Algorithm. Finally, I present the outcome of the simulation and Genetic Algorithm, and discuss the relevance of my results.

## Background and Theory

The kinematics of each member is characterized by the following equations in a fixed Cartesian basis:

![eq1](https://user-images.githubusercontent.com/52175303/109431343-f7035200-79ba-11eb-9219-f6677e5cca4c.png)
![eq2](https://user-images.githubusercontent.com/52175303/109431372-17331100-79bb-11eb-9128-a8efce2f8261.png)
![eq3](https://user-images.githubusercontent.com/52175303/109431381-21eda600-79bb-11eb-9451-0f2466cdad62.png)

