# NECSUS_UC-UM
NECSUS code - collaboration between Maastricht and Coimbra

This repo contains the code for the psychophysics stimulus of the NECSUS project.

## /psychophysics/stim
contrast detection stimulus with glare frame (distractor) embedded.

Dependencies:
- PTB3 (http://psychtoolbox.org/)

### /psychophysics/stim/mainContrastStim_UM
Script that calls the stim and sets the required variables. It identifies the participant (names/IDs according to the NECSUS naming procedures - see SOP_Data_Acquisition).
Each section represents the definition of specific properties of the paradigm: Stim presets (run, participant, study, display, gabor, frame).
IMPORTANT NOTES (site specific):
. The stimulus is defined based on visual angles that depend on: *VIEWINGDISTANCE*
. The stimulus is presented on a specific display - confirm variable *ptb.screenNumber*
. contrast detection should be determined on a screen with gamma function correction that varies for each display- our gamma function is located here *pathToGreyData*


#### /psychophysics/stim/Utils/

#### /psychophysics/stim/Utils/glare

#### /psychophysics/stim/Utils/gabor

#### /psychophysics/stim/Utils/lcd

### /psychophysics/stim/Answers/

### /psychophysics/stim/Results/
