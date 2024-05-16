clc; close; clear;

M = 1e-4; K = 5e4; B = 0.9; g = 9.81;
A = 1e-1; d = 0.02;
er = 10; e0 = 8.854e-12;
numerator = e0 * er * A;

num = 1;
den = [1, B/M, K/M];
G = tf(num, den);

a = [10 20 30 40 50 60];  % accelerations in Gs

t = 0:1e-5:0.0015;  % Running time 1.5 ms

%% RUN SIMULATION
extend = zeros(32,1);

for i = 1:6
    subplt = i*2;       % subplot counter
    if i>3; subplt = subplt-6; end    % second figure

% SET INPUT
    acc = a(i)*g;   % accelerations in m/s
    [x, t] = impulse( acc* G, t);      % output for impulse acceleration
    x = [extend(1:32); x(1:(length(x)-length(extend)))];    % left padding zeros

    for j = 1:length(x)
        x(j) = min(max(x(j), -0.018), 0.018);   % stop at 18mm or -18mm
    end

    C1 = numerator ./ (d-x);
    C2 = numerator ./ (d+x);

% SIMULATION INPUTS
    input_x = [t, x];
    input_C1 = [t C1];
    input_C2 = [t C2];

    sim("circuit.slx");     % run simulation
    load("outputs.mat");    % load array outputs

% PLOTS
    subplot(3, 2, subplt-1);
    plot(t, x);
    title("Plate Movement for "+string(a(i))+"G deceleration");
    ylabel("Amplitude (m)"); xlabel("Time (seconds)");
    grid on;

    subplot(3, 2, subplt);
    plot(outputs(1,:),outputs(2,:))
    title("Impulse Response for "+string(a(i))+"G deceleration");
    ylabel("Amplitude (V)"); xlabel("Time (seconds)");
    grid on;

    if i == 3; figure; end
end