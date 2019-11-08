
%load data
load('here_path_to_your_data');
sig=X6;
signal_NN=sig(:);
l=length(sig);

[AVNN,SDNN,RMSSD,pNN50] = timedomain (signal_NN)
signal_NN=signal_NN./1000;
t=cumsum(signal_NN)./60;
[LFnu,HFnu,LFHFfft] = frequencydomain (signal_NN,t)

[ sd1, sd2,sd1sd2,x_old,y_old,sd1_line_old,sd2_line_old] = poincareplot(signal_NN);

figure(1)
plot(t,signal_NN);
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
