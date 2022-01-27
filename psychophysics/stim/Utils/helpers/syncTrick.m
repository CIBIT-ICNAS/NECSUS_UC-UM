function syncTrick
% --- Trick by the PTB authors to avoid synchronization problem ---


figure(1);
plot(sin(0:0.1:3.14));
% Close figure with sin plot
close Figure 1
% --- end of synchronization trick ---

end