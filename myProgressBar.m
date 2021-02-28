%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% E150 Runtime predictor and progress bar generator with support functions
% Avery Rock, UC Berkeley Mechanical Engineering, avery_rock@berkeley.edu
% Written for E150, Fall 2019.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function myProgressBar(tock, t, tf, m)
% Provides a status update on a calculation, printed to the command window.
% avoids the issues associated with the GUI-based equilvalent functions. 
% 
% Inputs: 
%   tock -- total run time so far, seconds
%   t -- cycles, simulation time, etc completed
%   tf -- total cycles, etc required for process
%   m -- optional message input, empty by default

% Outputs: 
% no variables, prints information to the command window in the format: 
% "#######-----------" + "m" + "Time remaining: " + "HH:MM:SS"

if nargin < 4
    m = '';
end
rem = max(tock*(tf/t - 1), 0);
clock = sec2Clock(rem);
totchar = 20;
fprintf(repeatStr("#", floor(t/tf*totchar)) + repeatStr("-", totchar - floor(t/tf*totchar)) ...
    + "   " + m + "   Time remaining: " + clock + "\n\n");
end

function out = sec2Clock(s)
% returns a string of characters that represents a number of seconds in
% format HH:MM:SS. Can include arbitrarily many hour digits to account for
% large times. Rounded down to nearest number of seconds. 
    remh = floor(s / 3600); s = s - 3600*remh; remm = floor(s / 60); s = s - 60*remm; rems = floor(s); 
    out = padStr(num2str(remh), "0", 2)  + ":" + padStr(num2str(remm), "0", 2) ...
    + ":" + padStr(num2str(rems), "0", 2); 
end

function out = padStr(st, pad, minlength)
% returns string st plus some number of pad characters such that the total
% string length is as least minlength. Puts the padding on the left side. 
out = st; 
while (strlength(out) < minlength) out = pad + out; end
end

function out = repeatStr(st, n)
% returns a given string st repeated n times
out = ""; for i = 1:n out = out + st; end
end