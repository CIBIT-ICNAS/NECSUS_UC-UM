function [inverseGammaInput, Rb, Gb, Bb] = luminanceToRgbUncorrectedGamma(lumRequired, bitsRes, lcd)
% example [invertGammaInput, Rb, Gb, Bb] = luminanceToRgb(20, 8, 'Common\LCD_linear_Acromatic_grey_data.mat')

% VARGIN
if nargin<3  
    pathToGreydata=lcd.pathT;%'Common\LCD_linear_Acromatic_grey_data.mat';
%     pathToGreydata='C:\Users\Bruno\Desktop\LuminanciaLCD-PR650-dez2018\LCDnexus\necsusLightsONLedsON-GRAY-LCD_monitor_RGB_Lum11-Dec-2018.mat';
end

if nargin<2
    bitsRes=8;
end

if nargin<1
    lumRequired=20;
end

% --- load data ---
% LCD monitor RGB matrix on input
% returns RGB_lum (true output), FitParamters (gamma, offset)
load(pathToGreydata);

indexValues=RGB_lum(:,1) * (2^bitsRes - 1);
luminanceMeasurements=RGB_lum(:,2);

% plot values
figure(1); clf;
plot(indexValues,luminanceMeasurements,'b+');
hold on;
xlabel('Pixel Values');
ylabel('Luminance (cd/m2)');


%%
% normalized range
normGammaData = luminanceMeasurements(2:end)./max(luminanceMeasurements);
normGammaInput =  indexValues(2:end,1);

% --- estimate Gamma function ---
output = linspace(0,(2^bitsRes - 1),100)';

% Fit extended gamma power function.
fitType = 2;  %extended power function
[extendedFit,extendedX] = FitGamma(normGammaInput,normGammaData,output,fitType);

% plot sampled luminance and curve fit results
figure(2);clf;
hold on;
plot(output,extendedFit,'g');
plot(normGammaInput,normGammaData,'+'); %sampled luminance

fprintf(1,'\nFound exponent %g, offset %g\n\n',extendedX(1),extendedX(2));

% Inverse function based on gamma data
maxInput = max(normGammaInput);
maxLum=max(luminanceMeasurements);

normLumRequired=lumRequired/maxLum;
inverseGammaInput = InvertGammaExtP(extendedX,maxInput,normLumRequired);
inverseGammaInput = inverseGammaInput / (2^bitsRes - 1);
fprintf('Inverted input %.4f\n\n',inverseGammaInput);

%% prepare output
% ~Gray - RGB equal
Rb = round(inverseGammaInput*(2^bitsRes - 1));
Gb = round(inverseGammaInput*(2^bitsRes - 1));
Bb = round(inverseGammaInput*(2^bitsRes - 1));

end