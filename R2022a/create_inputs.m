clc; close; clear;

M = 1e-4; K = 5e4; B = 0.9;

e0 = 8.854e-12; er = 10; 
A = 1e-1; d = 0.02; % Capacitor Characteristics
numerator = e0 * er * A;

num = 1;
den = [1, B/M, K/M];
G = tf(num, den); % Plate Movement Tranfser Function

a =  50 * 9.81; % Deceleration of vehicle

t = 0:1e-5:0.0015;

[x, t] = impulse(a*G, t); % Plate Movent

extend = zeros(32,1);

x = [extend(1:32); x(1:(length(x)-length(extend)))]; % Delay Impulse

C1 = numerator ./ (d-x);
C2 = numerator ./ (d+x);

input_x = [t x];
input_C1 = [t C1]; % Capacitor C1 values over time
input_C2 = [t C2]; % Capacitor C2 values over time