% run_simulation.m
% Runs the Idle Speed Control model and prepares logs for plotting.
% Works with: Test_Ralenti_BO_End_New.mdl and data.mat in the same folder.

clear; clc;

modelName = 'Test_Ralenti_BO_End_New';  % top-level model name
stopTime  = '80';                        % or leave as model default

if exist('data.mat','file')
    load('data.mat');  
    fprintf('[run_simulation] Loaded data.mat\n');
else
    warning('[run_simulation] data.mat not found (continuing without it).');
end

if bdIsLoaded(modelName)
    open_system(modelName);
else
    if exist([modelName,'.slx'],'file') || exist([modelName,'.mdl'],'file')
        open_system(modelName);
    else
        error('Model file %s.[slx|mdl] not found.', modelName);
    end
end

set_param(modelName,'SignalLogging','on');
set_param(modelName,'SignalLoggingName','logsout');
set_param(modelName,'StopTime',stopTime);

fprintf('[run_simulation] Starting simulation...\n');
simOut = sim(modelName, 'CaptureErrors','on');

if ~isempty(simOut.ErrorMessage)
    error('[run_simulation] Simulation error:\n%s', simOut.ErrorMessage);
end

if evalin('base','exist(''logsout'',''var'')')
    lo = evalin('base','logsout');
elseif isprop(simOut,'logsout') && ~isempty(simOut.logsout)
    lo = simOut.logsout;
    assignin('base','logsout',lo);
else
    warning('[run_simulation] No "logsout" found. Enable signal logging.');
end

try
    Simulink.sdi.view;
catch
end

fprintf('[run_simulation] Done. Run plot_results.m to generate figures.\n');
