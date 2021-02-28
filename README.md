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

The dynamics of each member is described by Newton's second law:

![eq4](https://user-images.githubusercontent.com/52175303/109431422-61b48d80-79bb-11eb-9099-4087ecf0b618.png)

The magnitude, and direction of the interaction force between an agent, i, and another object, j, is given by the equation:

![eq5](https://user-images.githubusercontent.com/52175303/109431434-798c1180-79bb-11eb-8935-5f84cae50708.png)

![eq6](https://user-images.githubusercontent.com/52175303/109431443-8c9ee180-79bb-11eb-95ef-3b9b3b6877cd.png)

The w1 term scales the force of attraction the member experiences from the object, and the w2 term scales the force of repulsion the member experiences from the object.

![eq17](https://user-images.githubusercontent.com/52175303/109431717-cae8d080-79bc-11eb-8194-ce1fce7bfaad.png)

The total interaction vector on each member is the weighted summation of the interaction force between a member and all targets, a member and all obstacles, and a member and all other members.

![eq17](https://user-images.githubusercontent.com/52175303/109431723-d1774800-79bc-11eb-9a43-549d58aea589.png)

![eq7](https://user-images.githubusercontent.com/52175303/109431468-aa6c4680-79bb-11eb-8e6b-77a6fc9204c1.png)

![eq8](https://user-images.githubusercontent.com/52175303/109431484-ba842600-79bb-11eb-88fe-94c5fa6d4e1f.png)

The direction of the force of propulsion experienced by the member is:

![eq9](https://user-images.githubusercontent.com/52175303/109431500-d091e680-79bb-11eb-9314-bf7969f6ed21.png)

And the total force, including drag, is:

![eq10](https://user-images.githubusercontent.com/52175303/109431542-01721b80-79bc-11eb-9b93-978dfb3c03ca.png)

![eq11](https://user-images.githubusercontent.com/52175303/109431554-1353be80-79bc-11eb-9c16-b7d9a8245b01.png)

Including the forces of lift, and buoyancy would require the orientation, shape, and size of each member to be taken into consideration, therefore we consider these forces as secondary, and leave them out in order to idealize the members as point-masses.

The propulsive force of each member is constant, therefore the terminal velocity can be calculated by equating the magnitude of the propulsive force and the magnitude of the drag force.

![eq12](https://user-images.githubusercontent.com/52175303/109431577-2e263300-79bc-11eb-93cb-c06dedc0f3b9.png)

In our simulation, the air velocity is zero. Plugging in the values for each variable, and solving for terminal velocity yields:

![eq13](https://user-images.githubusercontent.com/52175303/109431610-4d24c500-79bc-11eb-91f5-57dec10a1c94.png)

Once the total force on a member is known, its position and velocity are updated using the Forward Euler method.

![eq14](https://user-images.githubusercontent.com/52175303/109431639-6463b280-79bc-11eb-9066-91e770140bf3.png)

![eq15](https://user-images.githubusercontent.com/52175303/109431648-734a6500-79bc-11eb-90fb-ee03ea2feade.png)

Forward Euler time discretization is a useful tool for simulation. It will never lead to a perfect solution for the position of the members, but it allows us to avoid solving the complicated differential equations that are the member's kinematic equations. If the time step is small, the Forward Euler solution will be close to the actual value. A large time step will speed up our code, but will lead to a small number of discrete steps, and will cause a large amount of error.

# Procedure and Methods

The cost function for this simulation is described by the following equation:

![eq16](https://user-images.githubusercontent.com/52175303/109431692-a260d680-79bc-11eb-9bad-a24628bc6cec.png)

![eq17](https://user-images.githubusercontent.com/52175303/109431731-d76d2900-79bc-11eb-8f4b-881d0ecd4938.png)

There are 15 design parameters involved in this simulation, so we chose to use a Genetic Algorithm to minimize the cost function. A gradient-based approach would result in a poorly optimized solution because there are likely many thousands of local minima in this 15-dimensional space. Gradient-based approaches will settle in the local minimum that is closest to the initial guess, making it extremely unlikely to find the global minimum.

A Genetic Algorithm is much better suited to this kind of optimization problem because it tests numerous randomly generated strings of design parameters against each other, and mates the top strings to create the next generation. Over many generations the best randomly generated, or bred strings will rise to the top, and plunge the depths of the cost function. Although the solutions aren't minima, they are more likely to reach a global minimum than a gradient-based solution.

The control-model we use in this project is relatively effective, but some parameters may be unnecessary. There may or may not be circumstances in which two members should feel an attractive force between them, or when a target should repel a drone, so further tests should be performed to see if some parameters can be left out or held constant during the Genetic Algorithm.

If any of the a, b, or c design variables became negative, the force between the member and object would become directly proportional to the distance between the two. This would be bad for the performance of the swarm because it would cause members to be more drawn to objects farther away than those close. As they get close to those far away objects, the force of attraction would become smaller, and would become overpowered by the ones that were initially closer.

My strategy for removing mapped targets and crashed agents was to move the agent, or target to Inf, and remove it from the position array at the end of the time-step. 

My initial strategy for removing mapped targets and crashed agents was to initialize boolean arrays called "crashed," and "mapped," as false, then change the index of the crashed member, or mapped target to true when they meet the criteria for crashing or mapping. I left the crashed members, and mapped targets in their position arrays, but skipped over any targets or members with a "true" value in their corresponding boolean array. However, this results in a sub-optimal simulation because the size of the position arrays we loop over never get any smaller. In the early generations when plenty of drones are crashing, and in the later generations when most targets have been mapped the simulation will run much faster if the position arrays decrease in size.

I initially place the agents as far apart as possible within the starting zone. If the members are far apart they are less likely to be drawn to the same target in the beginning of the simulation. If they all vie for the same target they are more likely to crash into each other. However, placing the members near each other has its benefits because the force of repulsion between members is higher, and they could potentially spread out more.

In order to speed up the Genetic Algorithm, I do not reevaluate the design parameter strings of parents from the previous generation. Instead I copy their cost function value into the next row of PI before evaluating their children, and the new, randomly generated strings.

## Results and Discussion

![fig1](https://user-images.githubusercontent.com/52175303/109431802-30d55800-79bd-11eb-8718-c2942ee6023b.png)

The best design converges on its final value around generation 20. This could be caused by inbreeding, wherein the best design parameters for multiple generations in a row are all related, and all converge to a steady state value. The only way to decrease the cost further would be for a randomly generated string to beat these strings.

![fig2](https://user-images.githubusercontent.com/52175303/109431831-45195500-79bd-11eb-808b-87ecda3eab92.png)

The effects of inbreeding can be seen here as well. The performance components all plateau early on. If inbreeding were discouraged the performance would likely decrease a couple more times within the final 80 generations. The least successful part of this optimization was the amount of time used by the simulation. A potential way to decrease T* could be to weigh it higher in the cost function. There could also be some improvements made in the simulation to optimize time.

![fig3](https://user-images.githubusercontent.com/52175303/109431848-5c584280-79bd-11eb-8634-32262b5ebfd4.png)

![fig4](https://user-images.githubusercontent.com/52175303/109431866-69753180-79bd-11eb-9da6-87376134a24a.png)

There is a slight decrease in the average performance of all strings across all generations. This is expected because most randomly generated strings, and many children perform poorly. Only a small number of strings in each generation perform very well.

![image](https://user-images.githubusercontent.com/52175303/109432215-084e5d80-79bf-11eb-8a2d-51a27a695701.png)

The top 4 design parameter strings all have similar design parameters. No negative values are present because the random strings are initialized between 0 and 2, and all children have parameters between their parents' parameters. If any negative values were present the repulsive and attractive forces could be switched, and the relationship between distance and magnitude of force could be inverted. Design parameters 10, and 15 are the smallest, approaching 0. Respectively, these cause the members to feel a very strong attractive force from targets, and a strong repulsive force from other members. Many of the design parameters are around 1. These mostly include the w scalars in front of the exponentials in the attractive and repulsive forces. This could mean that these parameters are unimportant, and that the parameters in the exponentials have a greater effect on the simulation. For future testing we could try setting these at a constant value of 1, and only optimizing the other parameters.

## Simulation

![FinalSim](https://user-images.githubusercontent.com/52175303/109432105-78a8af00-79be-11eb-817c-88c19a57121e.gif)

## Conclusion

The simulation was successfully optimized using a Genetic Algorithm. The dynamics, and kinematic equations of 15 UAVs were used to simulate the movements of these drones. Each drone was affected by a repulsive, and an attractive force from each other member, target, and obstacle. These equations utilized 15 design parameters that were optimized by a Genetic Algorithm. Random strings of design parameters were created at the beginning, passed into the simulator, and the resulting success of the strings was evaluated. The strings were then ranked, and the top strings were mated with each other, resulting in child strings. The next generation was filled out with more randomly generated strings, and the process was repeated for 100 generations. The GA resulted in a final cost of 25.3333. Additional optimizations for T*, and prevention of inbreeding could significantly decrease the cost, and should be implemented in future work on this, and other projects.
