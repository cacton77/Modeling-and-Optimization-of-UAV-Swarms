function [L_star,M_star,T_star] = swarmSim2(obstacles, targets, agents, lambda, animate)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Animated GIF Initialization
if (animate == true)
    f = figure;
    axis manual tight;
    filename = 'swarmSim2.gif';
end

%Break down lambda
Wmt = lambda(1);
Wmo = lambda(2);
Wmm = lambda(3);
wt1 = lambda(4);
wt2 = lambda(5);
wo1 = lambda(6);
wo2 = lambda(7);
wm1 = lambda(8);
wm2 = lambda(9);
a1  = lambda(10);
a2  = lambda(11);
b1  = lambda(12);
b2  = lambda(13);
c1  = lambda(14);
c2  = lambda(15);

% Dynamics and Integration Parameters
A    = 1;        %Agent characteristic area (m^2)
Cd   = 0.25;     %Agent coefficient of drag
m 	 = 10;       %Agent mass (kg)
Fp   = 200;      %Propulsion force magnitude (N)
rhoa = 1.225;    %Air density (kg/m^3)
dt   = 0.2;      %Time step size (s)
tf   = 60;       %Maximum task time (s)
va   = [0;0;0];  %Air velocity (m/s)

% Objects and Interactions Parameters
agent_sight = 5; %Target mapping distance (m)
crash_range = 2; %agent collision distance (m)
bounds = [150;150;60]; %Extent of testing grounds (m)

Nm0 = size(agents,2);
No = size(obstacles,2);
Nt0 = size(targets,2);

% Agent dynamics vectors (3 x Nm)
% Agents start with 0 velocity and 0 acceleration.
r = agents;
v = zeros(3,Nm0);

graveyard = [Inf;Inf;Inf];

%While loop starts here.
for t = 0:dt:tf
    Nm = size(r,2);
    Nt = size(targets,2);
    if (animate == true)
        time = strcat('time = ', num2str(fix(t)));
        map_tot = strcat('Targets Mapped: ', num2str(Nt0-Nt));
        crash_tot = strcat('Agents Crashed: ', num2str(Nm0-Nm));
        %Plot current Positions, and capture image
        if mod(t/dt,2)==1
            scatter3(r(1,:),r(2,:),r(3,:),'x')
            axis([-150 150 -150 150 -60 60]);
            drawnow
        else
            scatter3(r(1,:),r(2,:),r(3,:),'+')
            axis([-150 150 -150 150 -60 60]);
            drawnow
        end
        hold on
        tar = scatter3(targets(1,:),targets(2,:),targets(3,:),'o','r');
        tar.MarkerFaceColor = [1,1,1];
        scatter3(targets(1,:),targets(2,:),targets(3,:),8,'o','r');
        scatter3(obstacles(1,:),obstacles(2,:),obstacles(3,:),'*','g')
        xlabel('x')
        ylabel('y')
        zlabel('z')
        %legend('agent','target','obstacle');
        text(0,-300,-60,time);
        text(0,-200,150,map_tot);
        text(0,-200,140,crash_tot);
        hold off
        frame = getframe(f);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256); 
        % Write to the GIF File 
        if t == 0 
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.2); 
        else 
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.2); 
        end
    end    
    % Terminate loop if all targets are mapped or all members crashed.
    if (Nt == 0 || Nm == 0)
        break;
    end
    % Initialize dummy variables
    r_dummy = r;
    v_dummy = v;
    %Loop through each agent
    for i = 1:Nm
        ri = r(:,i);
        vi = v(:,i);
        Nimt = [0;0;0];
        Nimo = [0;0;0];
        Nimm = [0;0;0];
        % Member-Target interaction.
        for j = 1:Nt
            Tj = targets(:,j);
            dijmt = norm(ri-Tj);
            if (isequal(dijmt,NaN))
                continue;
            end
            if (dijmt <= agent_sight)
                targets(:,j) = graveyard;
                continue;
            end
            nijmt = (Tj-ri)./norm(Tj-ri);
            nijmt_hat = (wt1*exp(-a1*dijmt)-wt2*exp(-a2*dijmt)).*nijmt;
            if (isnan(nijmt_hat))
                nijmt_hat = [0;0;0];
            end
            Nimt = Nimt + nijmt_hat;
        end
        % Member-Member interaction.
        for j = 1:Nm
            if (i == j)
                continue;
            end
            rj = r(:,j);
            dijmm = norm(ri-rj);
            if (dijmm <= crash_range)
                r_dummy(:,j) = graveyard;
                ri = graveyard;
                break;
            end
            nijmm = (rj-ri)./norm(rj-ri);
            nijmm_hat = (wm1*exp(-c1*dijmm)-wm2*exp(-c2*dijmm)).*nijmm;
            if (isnan(nijmm_hat))
                nijmm_hat = [0;0;0];
            end
            Nimm = Nimm + nijmm_hat;
        end
        % Member-Obstacle interaction.
        for j = 1:No
            Oj = obstacles(:,j);
            dijmo = norm(ri-Oj);
            if (dijmo <= crash_range)
                ri = graveyard;
                break;
            end
            nijmo = (Oj-ri)./norm(Oj-ri);
            nijmo_hat = (wo1*exp(-b1*dijmo)-wo2*exp(-b2*dijmo)).*nijmo;
            if (isnan(nijmo_hat))
                nijmo_hat = [0;0;0];
            end
            Nimo = Nimo + nijmo_hat;
        end
        % Psi total calculation
        Nitot = Wmt.*Nimt+Wmo.*Nimo+Wmm.*Nimm;
        ni_star = Nitot/norm(Nitot);
        Fpi = Fp.*ni_star;
        Fdi = (1/2).*rhoa.*Cd.*A.*norm(va-vi).*(va-vi);
        Psi = Fpi + Fdi;
        %Update agent position
        ri = ri+dt.*vi;
        %Check if agent is outside boundary
        if (max(abs(ri) > bounds) == 1)
            ri = graveyard;
        end
        r_dummy(:,i) = ri;
        v_dummy(:,i) = vi+dt.*Psi./m;
    end
    % Update dynamics
    r = r_dummy(:,r_dummy(1,:) < Inf);
    v = v_dummy(:,r_dummy(1,:) < Inf);
    targets = targets(:,targets(1,:) < Inf);
end

L_star = (Nm0-Nm)/Nm0;
M_star = Nt/Nt0;
T_star = t/tf;

end

