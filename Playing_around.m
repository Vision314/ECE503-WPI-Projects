% first make our input responses, I want two types: a random sample and
% uniform sin wave sample

% amp, freq, stop_time, sampling_rate
[time_sin, x_sin] = create_sin(0.5, 1, 2, 16);

% amp, StopTime, sampling_rate
[time_rand, x_rand] = create_rand(1, 2, 10);

figure;
%stem(time_sin, x_sin, 'filled', 'LineWidth', 1.5, 'Color', 'r', 'DisplayName', 'Original Sine');
hold on;

scale_param = 1;
B = 2:1:16; % Reduced the range for clarity in this example

% Generate a colormap with enough colors
cmap = jet(length(B) + 6); % Using 'jet' colormap, can also use 'parula', 'hot', etc.


% Loop through different bit resolutions and plot the quantized signals
for i = 1:length(B)
    step_size = scale_param / (2^B(i));
    % Quantize the signal
    x_qsin = quantize_signal(x_sin, scale_param, B(i), step_size);

    % Generate a random color for each plot
    randomColor = rand(1, 3);

    % Plot the quantized signal
    stem(time_sin, x_qsin, 'filled', 'LineWidth', 1, 'Color', cmap(i+6,:), ...
        'DisplayName', sprintf('Quantized Sine B = %d bits', B(i)));
end

hold off;
xlabel('Time');
ylabel('Amplitude');
title('Quantized Sine Wave with Different Bit Resolutions');
legend;
grid on;


%[time_qrand, x_qrand] = quantize_signal(x_rand, scale_param, B, step_size);

%x_qsin = quantize_signal(x_sin, scale_param, B, step_size);

% figure;
% stem(time_sin, x_sin, 'filled', 'LineWidth', 1, 'Color', 'r');
% hold on;
% stem(time_sin, x_qsin, 'filled', 'LineWidth', 1, 'Color', ...
%     'b', 'LineStyle', '--');
% hold off;


%% PLOT INPUTS
figure;
%plot(time_rand, x_rand, 'x--');
stem(time_rand, x_rand, 'filled', 'LineWidth', 1, 'LineStyle','--');
hold on;
%plot(time_sin, x_sin, 'o--');
stem(time_sin, x_sin, 'filled', 'LineWidth', 1.5);
hold off;
%%





function quantized_signal = quantize_signal(signal, scale, B, step_size)

    scaled_signal = signal * scale;

    num_levels = 2^B;

    % Calculate the range of the signal
    minVal = min(scaled_signal);
    %maxVal = max(scaled_signal);

    % Quantize the signal
    quantized_signal = round((scaled_signal - minVal) / step_size);
    quantized_signal = min(max(quantized_signal, 0), num_levels - 1);
    quantized_signal = quantized_signal * step_size + minVal;

    % Rescale the quantized signal back
    quantized_signal = quantized_signal / scale;

end


%%
% function that creates a sin wave with a certain freq and  and returns x_sin

function [t, x_sin] = create_sin(amp, freq, stop_time, sampling_rate)
    dt = 1 / sampling_rate;
    t = 0:dt:stop_time;

    x_sin = amp * sin(2*pi*freq*t);

end

% fucntion that creates a random input

function [t, x_rand] = create_rand(amp, StopTime, sampling_rate)
    dt = 1 / sampling_rate;
    t = 0:dt:StopTime;
    
    % Generate a random signal within the amplitude range
    x_rand = amp * (2 * rand(size(t)) - 1);
end


