function [sys,x0,str,ts] = sfdcmotorin(t,x,u,flag,Ts,H)
%SFDCMOTORIN USB input from DC motor into Simulink.
%    Ts  ... sampling period in [s]
%    H ... USB port handle

%   (c) Robert Babuska, June 2007

switch flag
  case 0; [sys,x0,str,ts]=mdlInitializeSizes(Ts,H);
  case 3; sys = mdlOutputs(u,x,H);
  case 9; sys = mdlTerminate(H);
  otherwise; sys=[];
end

function [sys,x0,str,ts]=mdlInitializeSizes(Ts,H)
sizes = simsizes;
sizes.NumContStates  = 0;               % no need for states
sizes.NumDiscStates  = 0;               % no need for states
sizes.NumOutputs     = 1;               % no of sensors
sizes.NumInputs      = 0;               % no inputs
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = []; str = [];
ts = [-1 0];                            % Set sample time
if length(Ts)>0 ts(1)=Ts(1); end;
if length(Ts)>1 ts(2)=Ts(2); end;
% DCMOTOR - USB init
H.WatchdogTimeout = 1;
fugiboard('SetParams', H);
fugiboard('Write', H, 1, 1, 0, 0);      % dummy write to sync interface board
fugiboard('Write', H, 1, 1, 0, 0);      % reset position
fugiboard('Write', H, 0, 1, 0, 0);      % end reset
for i = 1 : 10,
    fugiboard('Read',H);                % dummy read sensor data
end;

function sys = mdlOutputs(u,x,H)
data = fugiboard('Read',H);             % read sensor data
sys = data(3)';

function sys = mdlTerminate(H)
fugiboard('Write', H, 0, 1, 0.0, 0.0);  % reset actuator
fugiboard('Close', H);                  % close USB port
sys = [];
