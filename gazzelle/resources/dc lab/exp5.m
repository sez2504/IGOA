% Clear the workspace and command window
clear;
clc;

% Define signal parameters
f = 30e3;
fs = 2 * f;
Ts = 1/fs;
t1 = 0:1e-7:5/f;
x1 = cos(2 * pi * f * t1);

t2 = 0:Ts:5/f;
x2 = cos(2 * pi * f * t2);

% Initialize reconstructed signal
xr = zeros(size(t1));

% Reconstruct the signal
for i = 1:length(t1)
    for j = 1:length(t2)
        xr(i) = xr(i) + x2(j) * mysinc(2 * fs * t1(i) - j);
    end
end

% Plot the original continuous signal
subplot(3, 1, 1);
plot(t1, x1);
title('Continuous Signal x(t)');
xlabel('Time');
ylabel('Amplitude');

% Plot the sampled signal
subplot(3, 1, 2);
stem(t2, x2, 'r');
title('Sampled Signal x(nT)');
xlabel('Time');
ylabel('Amplitude');

% Plot the reconstructed signal
subplot(3, 1, 3);
plot(t1, xr);
title('Reconstructed Signal x_r(t)');
xlabel('Time');
ylabel('Amplitude');


