function [ decVec ] = ldpcDecode( llrVec, LDPC )
%LDPCDECODE LDPC decoder using a serial C (check node) schedule and 
% message-passing as introduced in [E. Sharon, 
% S. Litsyn and J. Goldberger, "An efficient message-passing schedule for 
% LDPC decoding," 2004 23rd IEEE Convention of Electrical and Electronics 
% Engineers in Israel, 2004, pp. 223-226].

%% Preprocessing

% Add zero bits for the first 2*Z punctured bits
llrVec = [zeros(1,2*LDPC.Z), llrVec];

% Find number of non-zero entries in H
numEntries = nnz(LDPC.H);

%% Initialization

% Store smallest possible double value
minVal = realmin('double');

% For similar notation as reference
Qv = llrVec;

% Allocate sparse message passing matrix
Rcv = spalloc(LDPC.numParBits, LDPC.numTotBits + 2*LDPC.Z, numEntries);

%% LDPC decoding

% Choose decoder
switch LDPC.decType
    case 'SPA' % Sum-Product Algorithm
        
        % Loop max number of algorithm iterations
        for ldpcCurIter = 1:LDPC.iterations
            
            % Loop over all check nodes
            for checkIdx = 1:LDPC.numParBits
                
                % Find all neighbouring variable nodes of current check
                % node
                nbVarNodes = find(LDPC.H(checkIdx,:)==1);
                
                % Tmp update llr
                tmpLlr = Qv(nbVarNodes) - full(Rcv(checkIdx,nbVarNodes));
                
                % Compute S = (Smag, Ssign)
                Smag = sum(-log(minVal+tanh(abs(tmpLlr)/2)));
                
                % Count number of negative elements 
                if mod(sum(tmpLlr<0),2) == 0
                    Ssign = +1;
                else
                    Ssign = -1;
                end
                
                % Loop all neighbouring variable nodes
                for varIter = 1:length(nbVarNodes)
                    
                    varIdx = nbVarNodes(varIter);
                    Qtmp = Qv(varIdx) - Rcv(checkIdx, varIdx);
                    QtmpMag = -log(minVal+tanh(abs(Qtmp)/2));
                    % Note: +minVal in order to deal with llr=0;
                    % implementation can be improved
                    QtmpSign = sign(Qtmp+minVal);
                    
                    % Update message passing matrix
                    % From reference: Rcv = phi^-1(S-phi(Qtmp))
                    Rcv(checkIdx, varIdx) = Ssign*QtmpSign * (-log(minVal+tanh(abs(Smag-QtmpMag)/2)));
                    
                    % Update Qv. From reference: Qv = Qtmp + Rcv
                    Qv(varIdx)  = Qtmp + Rcv(checkIdx, varIdx);
                    
                end
                
            end
            
        end
        
        % Convert Qv to decoded bits
        decVec = zeros(1,LDPC.numInfBits);
        decVec(Qv(1:LDPC.numInfBits)<0) = 1;
        
    otherwise
        error('Error: Unknown decoding algorithm LDPC.decType=%s.', LDPC.decType)

end

