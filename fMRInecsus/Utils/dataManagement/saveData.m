% Function thas prompts for saving 'logdata'
function saveData(participant, stimuliPrt,logdata, pName)

% Asks for filename and folder to save 'logdata'
[filename, pathname]=uiputfile({'*.mat','mat-File';},...
    'Save Participant',...
    strcat('Output/',...
        num2str(participant.ID),...
        '/',...
        num2str(participant.ID),...
        '_LOG_',...
        pName,...
        '_',...
        datestr(now,'HHMM_ddmmyy')));

if ( ischar(pathname) || ischar(filename) )
    completepath = strcat(pathname,filename);
    save(completepath,'participant','stimuliPrt','logdata')
   
else
    % if the user does not choose a valid filename or folder it warns
    % him/her and asks if the user really wants to exit without saving the
    % data
    exitEvents = questdlg('You did not save the data. Do you want to save it before exit?','Attention','Yes','No','No');
    switch exitEvents
        case 'Yes'
            % Ask for saving data again
            saveData(participant,stimuliPrt,logdata,pName)

        case 'No'
            % Exit the EVENTS experiment without saving 'logdata'
            errordlg('You did not save the data!','Error','modal');
            return
    end
end

end