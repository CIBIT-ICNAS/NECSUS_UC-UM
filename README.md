# NECSUS_UC-UM
NECSUS code - collaboration between Maastricht and Coimbra

This repo contains the code for the psychophysics stimulus of the NECSUS project.

Brief description of the folder structure.

## /psychophysics/stim
contrast detection stimulus with glare frame (distractor) embedded.

Dependencies:
- PTB3 (http://psychtoolbox.org/)

### /psychophysics/stim/mainContrastStim_UM
Script that calls the stim and sets the required variables. It identifies the participant (names/IDs according to the NECSUS naming procedures - see SOP_Data_Acquisition).
Each section represents the definition of specific properties of the paradigm: Stim presets (run, participant, study, display, gabor, frame).

IMPORTANT NOTES (site specific):
- The stimulus is defined based on visual angles that depend on: *VIEWINGDISTANCE*
- The stimulus is presented on a specific display - confirm variable *ptb.screenNumber*
- contrast detection should be determined on a screen with gamma function correction that varies for each display- our gamma function is located here *pathToGreyData*


#### /psychophysics/stim/Utils/

#### /psychophysics/stim/Utils/glare
glare dimensions (frame, dot size, etc.) are defined in visual angles (degrees). The blinking dots are randomly defined (seed of the random generator) in funtion glareInfo().

- designGlare() setup the embedded glare frame. Convert visual angles to pixels etc.

#### /psychophysics/stim/Utils/gabor
Gabor patch dimensions (size in visual angle degrees, etc.), phase, frequency in funtion gaborInfo().

#### /psychophysics/stim/Utils/lcd

#### /psychophysics/stim/Utils/luminance
luminanceToRgb() - Using max luminance from the display, get the 20 c/m2 value normalized assuming linear CLUT (linInput).

#### /psychophysics/stim/Utils/paradigm
runStim_UM - main function that displays the contrast and glare, calls the contrast update algorithm etc.

IMPORTANT NOTES (site specific):
- The stimuli is adjusted to a specific display. To this end, this function requires the original luminance measurements (particularly the maximum luminance) and the linearized gamma corrected table. In our example, the luminance measured is saved in variable 'NecsusNolightGray-rgblum11-Dec-2018.mat' and the gamma corrected table (normalized) is saved in 'InvertedCLUT.mat' - both .mat files are in the "luminance" folder.


#### /psychophysics/stim/Utils/helpers
Helper functions - misc. parameters, etc..

- designFixationCross()  -  init paramters of fixation cross (size in pixels)



### /psychophysics/stim/Answers/

### /psychophysics/stim/Results/
