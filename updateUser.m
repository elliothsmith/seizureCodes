function [] = updateUser(loopVariable,period,NloopVariables,operationMessage)
% UPDATEUSER displays progress through a for loop in the command window.
%
%   [updateMessage] = updateUser(loopVariable,period,NloopVariables,operationMessage)
%
% loopVariable: the loop variable
% period: number of loop variables after which to update the user
% NloopVariables: max number of loop variables
% operationMessage: a message about what kind of operation is being
%   performed (e.g. calculating spectrograms) 

% author EHS20170609

if mod(loopVariable,period)
    display(sprintf('%s %d out of %d',operationMessage,loopVariable,NloopVariables))
end

