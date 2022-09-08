%% Script initialization
clear
clc
close all

global pod;
constants_H7()

beta = 20;

%% Data extraction 

maxFactor = 20;

time = out.tout;
rotx =             reshape(out.rotx.Data,size(time));
roty = maxFactor * reshape(out.roty.Data,size(time));
rotz = maxFactor * reshape(out.rotz.Data,size(time));

%% Static plot
x = [0 0];
y = [-1000,1000];

figure(1)

p1 = plot(time, rotx, 'r');
hold on
p2 = plot(time, roty, 'b');
hold on

p3 = plot(time, rotz, 'g');

title('Euler Angle (degree)')

timeLine  = line('XData',x,'YData',y);

timeValue = xlabel('');
legend([p1 p2 p3],{'Phi', 'Theta', 'Psi'},'Location','northwest','AutoUpdate','off');
axis([0 time(end) -30 30])
%% Dynamic Plot

load('mesh.mat')

figure(2)
view(3)

axis equal
axis([-1100 1100 -1100 1100 -1100 1100])
grid on

podmodel = patch('Faces', mesh.top, 'Vertices', mesh.nodes);
podmodel.FaceAlpha = 0.8;
podmodel.FaceColor = 'red';
podmodel.EdgeAlpha = 0.8;

title('Pod attitude (real time)')
realTime = xlabel(' ');


dt = 0;
nN = size(mesh.nodes,1);

for dt = 1:numel(time)-1
    Rz = [cosd(rotz(dt)) -sind(rotz(dt)) 0; sind(rotz(dt)) cosd(rotz(dt)) 0; 0 0 1];
    Ry = [cosd(roty(dt)) 0 sind(roty(dt)); 0 1 0; -sind(roty(dt)) 0 cosd(roty(dt))];
    Rx = [1 0 0; 0 cosd(rotx(dt)) -sind(rotx(dt)); 0 sind(rotx(dt)) cosd(rotx(dt))];
    deltaT = time(dt+1) - time(dt);

    for k = 1:nN
        rotNodes(k,:,dt) = Rx*Ry*Rz*mesh.nodes(k,:)'; 
    end

    set(podmodel, 'Vertices', rotNodes(:,:,dt))
    set(realTime, 'String', sprintf('time = %.2f [s]', time(dt)))
    set(timeValue, 'String', sprintf('Phi: %.2f  Theta: %.2f  Psi: %.2f', rotx(dt), roty(dt), rotz(dt)));
    set(timeLine, 'XData', [time(dt) time(dt)]);
    drawnow
end



















