function [ invertedCLUT ] = getInverseGammaTable(  )
%GETINVERSEGAMMATABLE Summary of this function goes here
%   Detailed explanation goes here

% LCD lab 95
pathToGreydata='C:\Users\bdireito\Documents\GitHub\NECSUS\contrastSensEstimation\code\Utils\luminance\NecsusNolightGray-rgblum11-Dec-2018.mat';

% MR projector
% pathToGreydata='C:\Users\bdireito\Documents\GitHub\NECSUS\contrastSensEstimation\code\Utils\luminance\rgblumGRAY10-Mar-2016.mat';

%'C:\Users\Bruno\Desktop\LuminanciaLCD-PR650-dez2018\LCDnexus\NecsusNolightGray-rgblum11-Dec-2018.mat';

%'Common\LCD_linear_Acromatic_grey_data.mat';
BITSRESOLUTION = 8;

% --- load data ---
% LCD monitor RGB matrix on input
% returns RGB_lum (true output), FitParamters (gamma, offset)
load(pathToGreydata);

indexValues=RGB_lum(:,1) * (2^BITSRESOLUTION - 1);
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
output = linspace(0,(2^BITSRESOLUTION - 1),100)';

% Fit extended gamma power function.
fitType = 2;  %extended power function
[extendedFit,extendedX] = FitGamma(normGammaInput,normGammaData,output,fitType);

% plot sampled luminance and curve fit results
figure(2);clf;
hold on;
plot(output,extendedFit,'g');
plot(normGammaInput,normGammaData,'+'); %sampled luminance

fprintf(1,'\nFound exponent %g, offset %g\n\n',extendedX(1),extendedX(2));

%%
% Inverse function based on gamma data
maxInput = max(normGammaInput);
invertedInput = InvertGammaExtP(extendedX,maxInput,normGammaData);

figure(3); clf; hold on
plot(normGammaInput,invertedInput,'r+');
axis('square');
axis([0 maxInput 0 maxInput]);
plot([0 maxInput],[0 maxInput],'r');

% fprintf('Inverted input %.4f\n\n',invertedInput);

%%
% --- generate inverse gamma luminance function (based on curve fit above) ---
maxLum=max(luminanceMeasurements);
luminanceRamp=0:1/255:1;
pow=extendedX(1);
offset=extendedX(2);
invertedCLUT=((maxLum-offset)*(luminanceRamp.^(1/pow)))+offset; %invert gamma w/o rounding
%normalize inverse gamma table
invertedCLUT=invertedCLUT./max(invertedCLUT);
%plot inverse gamma function
figure(4); clf; hold on;
pels=[0:255];
plot(pels,invertedCLUT,'r');
axis('square');
axis([0 255 0 1]);
xlabel('Pixel Values');
ylabel('Inverse Gamma Table');
strTitle{1}='Inverse Gamma Table Function';
strTitle{2}=['for Exponent = ',num2str(extendedX(1)),'; Offset = ',num2str(extendedX(2))];
title(strTitle);
hold off;

% Save data.
save('invertedCLUT.mat','invertedCLUT')

end

