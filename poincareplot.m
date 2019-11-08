function [ sd1, sd2,sd1sd2,x_old,y_old,sd1_line_old,sd2_line_old] = poincareplot(signal_NN)
% POINCARE poincare HRV chart
% Calculation of statistical data from the poincare chart
%
% What to give:
% - signal_NN: intervals length in seconds.
%
% What the function reflects
% - sd1: standard deviation along a perpendicular line
% - sd2: standard deviation along a horizontal line
% - sd1 / sd2 ratio

%% === Input
 
 [b,a] = butter(5,.03);
    y = filtfilt(b,a,signal_NN);

   
    %% PSD calculated using Fourier transform
    signal_NN=signal_NN-y;
    
% Normalize 
signal_NN = reshape(signal_NN, 1, length(signal_NN));

% Creating the x and y vector
x_old = signal_NN(1:end-1);   % NN(n)
y_old = signal_NN(2:end);     % NN(n+1)


alpha = -pi/4;

    mr= [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
    mrm= [cos(-alpha), -sin(-alpha); sin(-alpha), cos(-alpha)];


%% Rotation


% Data rotation for the new coordinate system
NNi_rotated = mr * [x_old; y_old];
x_new = NNi_rotated(1,:);
y_new = NNi_rotated(2,:);

% Calculation of the standard deviation along the new axis
sd1 = sqrt(var(y_new));
sd2 = sqrt(var(x_new));
sd1sd2=sd2/sd1;
%% Ellipse matching
% We use calculated data

% ellipse radius
r_x = 2* sd2;
r_y = 3 * sd1;

% Ellipse Center
c_x = mean(x_new);
c_y = mean(y_new);

% parametric equation of the ellipse
t = linspace(0, 2*pi, 200);
xt = r_x * cos(t) + c_x;
yt = r_y * sin(t) + c_y;

% Restore the ellipse to the old coordinate system
ellipse_old = mrm * [xt; yt];

%% lines for the ellipse axis
ellipse_center_new = [c_x; c_y];

% The lines created in the new coordinate system
sd1_line_new = [0, 0; -sd1, sd1] + [ellipse_center_new, ellipse_center_new];
sd2_line_new = [-sd2, sd2; 0, 0] + [ellipse_center_new, ellipse_center_new];

% Returns to the old layout
sd1_line_old = mrm * sd1_line_new;
sd2_line_old = mrm * sd2_line_new;


end

