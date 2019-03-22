%
%    ziegler-nichols.m  
%
%    (C) Marco Vedovati - 2019
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <https://www.gnu.org/licenses/>.
%

filename = "step-response.txt";
A = importdata(filename, " ");
inStep = A(:, 1);
outResp = A(:, 2);

% shift inStep to be aligned with outResp
inStep = inStep + abs(inStep(1) - outResp(1));

interpFactor=10;
l = length(inStep);
t=[0:1/interpFactor:l-1];
stepInterp=interp1([0:l-1], inStep, t);
respInterp=interp1([0:l-1], outResp, t);
outResp=respInterp;
inStep=stepInterp;
l = length(inStep);

hold on
plot(t,inStep)
pResp = plot(t,outResp);
set(pResp,'LineWidth',4);

% Get beginning of inStep
dStep = gradient(inStep,t);
tmp = find(dStep==max(dStep));
x_maxdStep = tmp(1);
% Get the tangent to response steepest point
dResp = gradient(outResp,t);
tmp = find(dResp==max(dResp));
x_maxdResp = tmp(1);
tang = (t-t(x_maxdResp)) * dResp(x_maxdResp) + outResp(x_maxdResp);
hold on;
pTang = plot(t,tang);
set(pTang,'LineWidth',4);

scatter(t(x_maxdResp), outResp(x_maxdResp));
grid on;
grid minor;
axis ([0 t(length(t)) min(outResp)-10 max(outResp)+10]);

% Make fullscreen
figure(1,"position",get(0,"screensize"))


stepStart = vline(t(x_maxdStep), 'c-->', 'L start');
respEnd = hline(outResp(l), 'g-.', 'End of response');
respStart = hline(outResp(1), 'g-.', 'Start of response');

% Draw line at steady response
tmp = find(tang >= outResp(1));
Tstart = tmp(1);
tmp = find(tang >= outResp(l));
Tend   = tmp(1);
tstart_line = vline(t(Tstart), 'b-->','T start');
tend_line   = vline(t(Tend),'b--<','T end');

hold off;
T = t(Tend) - t(Tstart);
L = t(Tstart) - t(x_maxdStep);
printf("T = %d, L = %d \n\n",T,L)

Kp = T/L;
Ki = 0;
Kd = 0;
printf("P: Kp = %.2f Ki = %.2f Kd = %.2f\n\n", Kp, Ki, Kd)

Kp = 0.9*T/L;
Ti = L/0.3;
Ki = Kp/Ti;
Kd = 0;
printf("PI: Kp = %.2f Ki = %.2f Kd = %.2f\n\n", Kp, Ki, Kd)

Kp = 1.2*T/L;
Ti = 2*L;
Ki = Kp/Ti;
Td = 0.5*L;
Kd = Kp*Td;
printf("PID: Kp = %.2f Ki = %.2f Kd = %.2f\n\n", Kp, Ki, Kd)


