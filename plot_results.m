% plot_results.m
% Extracts key signals (rpm, Pa) from logsout and saves figures into ./figures

clear; clc;

lo = [];
if evalin('base','exist(''logsout'',''var'')')
    lo = evalin('base','logsout');
else
    warning('No "logsout" in base workspace. Run run_simulation.m first.');
end

sigNames = {'rpm','Pa'};
S = struct();
for k = 1:numel(sigNames)
    try
        s = lo.get(sigNames{k});
        S.(sigNames{k}).t = s.Values.Time;
        S.(sigNames{k}).y = s.Values.Data;
    catch
        warning('Signal "%s" not found in logsout.', sigNames{k});
        S.(sigNames{k}) = [];
    end
end

outDir = fullfile(pwd,'figures');
if ~exist(outDir,'dir'), mkdir(outDir); end

if ~isempty(S.rpm)
    f1 = figure('Name','Engine Speed (rpm)');
    plot(S.rpm.t, S.rpm.y, 'LineWidth',1.5);
    xlabel('Time (s)'); ylabel('Engine Speed (rpm)'); grid on;
    title('Idle Speed Response');
    saveas(f1, fullfile(outDir,'rpm.png'));
end

if ~isempty(S.Pa)
    f2 = figure('Name','Manifold Pressure (Pa)');
    plot(S.Pa.t, S.Pa.y, 'LineWidth',1.5);
    xlabel('Time (s)'); ylabel('Manifold Pressure (Pa)'); grid on;
    title('Manifold Pressure Response');
    saveas(f2, fullfile(outDir,'Pa.png'));
end

if ~isempty(S.rpm) && ~isempty(S.Pa)
    f3 = figure('Name','RPM & MAP');
    yyaxis left;  plot(S.rpm.t, S.rpm.y, 'LineWidth',1.5); ylabel('rpm');
    yyaxis right; plot(S.Pa.t,  S.Pa.y,  '--', 'LineWidth',1.2); ylabel('Pa');
    xlabel('Time (s)'); grid on; title('Engine Speed & Manifold Pressure');
    legend('rpm','Pa','Location','best');
    saveas(f3, fullfile(outDir,'rpm_Pa_overlay.png'));
end

disp('Saved figures in ./figures');
