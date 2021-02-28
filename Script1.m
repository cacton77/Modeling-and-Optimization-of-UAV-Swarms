%% Project 2
% Colin Acton
% E 150

%% Objects and Interactions Parameters
Nm = 15;  %Number of initial agents
No = 25;  %Number of initial obstacles
Nt = 100; %Number of initial targets
%% Initialize Target, Obstacle, and Swarm Locations

x_range = 100;
y_range = 100;
z_range = 10;

%Targets and obstacles randomly positioned throughout the region.
targets   = [2*x_range*rand(1,Nt)-x_range;
             2*y_range*rand(1,Nt)-y_range;
             2*z_range*rand(1,Nt)-z_range];
         
obstacles = [2*x_range*rand(1,No)-x_range;
             2*y_range*rand(1,No)-y_range;
             2*z_range*rand(1,No)-z_range];

%Agents can be purposefully arranged. Right now they are randomly placed.
agents = [[linspace(-150,-110,5),linspace(-150,-110,5),linspace(-150,-110,5)];
          [zeros(1,5)-10,zeros(1,5),zeros(1,5)+10]; 
           zeros(1,15)];
% agents = [[linspace(-150,-130,5),linspace(-150,-110,5),linspace(-150,-110,5)];
%           [zeros(1,5)-2,zeros(1,5),zeros(1,5)+2]; 
%           [zeros(1,5)-2,zeros(1,5),zeros(1,5)-2]];
%agents = [linspace(-150,-110,Nm);zeros(1,Nm);zeros(1,Nm)];

%% Genetic Algorithm without reevaluating parents
% [PI, Orig, Lambda] = geneticAlgorithm3(cf, lambda_lower, lambda_upper, parents, TOL_GA, G, S, dv)
w1 = 70;
w2 = 10;
w3 = 20;

cf = @(M_star,T_star,L_star) w1*M_star+w2*T_star+w3*L_star;
lambda_lower = 0;
lambda_upper = 2;
parents = 6;
TOL_GA = 0.1;
G = 100;
S = 20;
dv = 15;

% Generate empty output arrays.
PI = zeros(G,S);
Orig = zeros(G,S);
PC = zeros(G,S,3);
% Randomly generate first generation.
Lambda = lambda_lower + rand(S,dv).*(lambda_upper-lambda_lower);

t0 = tic;
for g = 1:G
    myProgressBar(toc(t0), g, G);
    % Test fitness of members of first generation.
    if (g == 1)
        for i = 1:S
            lambda = Lambda(i,:);
            [L_star,M_star,T_star] = swarmSim2(obstacles, targets, agents, lambda, false);
            PI(g,i) = cf(M_star,T_star,L_star);
            PC(g,i,:) = [M_star,T_star,L_star];
        end
    else
        PI(g,1:parents) = PI(g-1,1:parents);
        PC(g,1:parents,:) = PC(g-1,1:parents,:);
        for i = parents+1:S
            lambda = Lambda(i,:);
            [L_star,M_star,T_star] = swarmSim2(obstacles, targets, agents, lambda, false); 
            PI(g,i) = cf(M_star,T_star,L_star);
            PC(g,i,:) = [M_star,T_star,L_star];
        end
    end
    
    % Rank genetic strings.
    [PI(g,:),Orig(g,:)] = sort(PI(g,:));
    Lambda = Lambda(Orig(g,:)',:);
    PC(g,:,:) = PC(g,Orig(g,:),:);
    % Break if tolerance is met
    if (PI(g,1) <= TOL_GA)
        break;
    end
    % Mate top pairs.
    children = zeros(parents,dv);
    for p = linspace(1, parents-1, parents/2)
        parent1 = Lambda(p,:);
        parent2 = Lambda(p+1,:);
        phi1 = rand;
        phi2 = rand;
%         children(p,:)   = parent1.*phi1 + parent2.*(1-phi1);
%         children(p+1,:) = parent1.*phi2 + parent2.*(1-phi2);
        Lambda(parents+p,:) = parent1.*phi1 + parent2.*(1-phi1);
        Lambda(parents+p+1,:) = parent1.*phi1 + parent2.*(1-phi2);
    end
    %Lambda(parents+1:2*parents,:) = children;
    Lambda(2*parents+1:end,:) = lambda_lower + rand(S-2*parents,dv).*(lambda_upper-lambda_lower);
end
%%
[L_star,M_star,T_star] = swarmSim2(obstacles, targets, agents, Lambda(1,:), true);
figure
plot(linspace(0,G,G),PI(:,1));
hold on
plot(linspace(0,G,G),mean(PI(:,1:parents),2));
plot(linspace(0,G,G),mean(PI,2));
legend('Best designs','Mean of parents','Mean of population');
title('Cost vs Generation')
xlabel('Generation');
ylabel('Cost');
hold off
figure
plot(linspace(0,G,G),PC(:,1,1))
hold on
plot(linspace(0,G,G),PC(:,1,2))
plot(linspace(0,G,G),PC(:,1,3))
legend('M*','T*','L*');
title('Best Performance Components vs Generation');
xlabel('Generation');
ylabel('Performance');
hold off
figure
plot(linspace(0,G,G),mean(PC(:,1:parents,1),2))
hold on
plot(linspace(0,G,G),mean(PC(:,1:parents,2),2))
plot(linspace(0,G,G),mean(PC(:,1:parents,3),2))
legend('M*','T*','L*');
title('Mean Performance Components of Parents vs Generation');
xlabel('Generation');
ylabel('Performance');
hold off
figure
plot(linspace(0,G,G),mean(PC(:,:,1),2))
hold on
plot(linspace(0,G,G),mean(PC(:,:,2),2))
plot(linspace(0,G,G),mean(PC(:,:,3),2))
legend('M*','T*','L*');
title('Mean Performance Components vs Generation');
xlabel('Generation');
ylabel('Performance');
hold off
Lambda1 = Lambda(1,:)
Lambda2 = Lambda(2,:)
Lambda3 = Lambda(3,:)
Lambda4 = Lambda(4,:)
figure
familyTree(Orig, parents, S)

%% Plotting
[L_star,M_star,T_star] = swarmSim2(obstacles, targets, agents, Lambda4, false); 
cf(M_star,T_star,L_star)
