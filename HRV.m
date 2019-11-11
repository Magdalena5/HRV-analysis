
%load data
sig=load('here_path_to_your_data');
signal_NN=sig(:);
l=length(sig);



signal_NN=signal_NN./1000;
t=cumsum(signal_NN);
% Remove ectopic beats
signal_NN(signal_NN < 0.2 | signal_NN > 2000) = NaN;
for i= 2:l
    signal_NN(abs(signal_NN(i-1)-signal_NN(i)) <= 0.2 * signal_NN(i-1)) = NaN;
end
t2 =t(1):t(end);

%signal interpolation
signal_NNt = interp1(t,signal_NN,t2,'spline');
signal_NNt=signal_NNt.*1000;
[AVNN,SDNN,RMSSD,pNN50] = timedomain (signal_NNt)

%interpolcja sygnału
 t2 =t(1):0.2:t(end);
 signal_NNf = interp1(t,signal_NN,t2,'spline');
[LFnu,HFnu,LFHFfft] = frequencydomain (signal_NNf)

[ sd1, sd2,sd1sd2,x_old,y_old,sd1_line_old,sd2_line_old] = poincareplot(signal_NNt);

figure(1)
plot(t,sig);
title('tachogram');xlabel('Time');ylabel('RR(s)');

%Poincare plot
figure(3)
hold on;
plot(x_old,y_old,'b.');
plot(sd1_line_old(1,:),sd1_line_old(2,:), 'r-','LineWidth',2);
plot(sd2_line_old(1,:),sd2_line_old(2,:), 'g-','LineWidth',2);
title('Poincare plot');xlabel('RR_{i}(sec)');ylabel('RR_{i+1}(sec)');
legend('','SD1','SD2')
hold off;
