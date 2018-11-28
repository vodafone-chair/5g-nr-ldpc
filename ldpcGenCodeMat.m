function [ LDPC ] = ldpcGenCodeMat( rateIn, liftingFactor, bgType )
%LDPCGENCODEMAT This function generates the specified code matrices.

%% Init 1
if ~isdeployed
    addpath('./prototypes');
end

% Workaround for nice code rate specifications
maxCodeRateDeviation = 0.015;

% Store and sanity check
if bgType == 1
    % Check if code rate is in valid range
    if rateIn > 5/6 || rateIn < 1/3
        error('Error: The specified code rate %f is not supported! For BG1 the code rate should be in the range [1/3,5/6]', rateIn);
    end
else
    % Note: BG2 is not yet supported!
    error('Error: bgType must be 1 or 2!');
end
LDPC.rate = rateIn;
LDPC.Z = liftingFactor;

iLsVec = [2,3,5,7,9,11,13,15];
iLsMat = NaN .* ones(8);    % Init with NaN
for i = 1:8
    for j = 1:8
        if j == 1
            iLsMat(i,j) = iLsVec(i);
        else
            tmp = iLsMat(i,j-1)*2;
            if tmp <=384 % Max lifting factor is 384
                iLsMat(i,j) = tmp;
            end
        end
    end
end

%% Find and load base graph

% Find i_LS which corresponds to lifting factor Z
[i,~] = find(iLsMat==LDPC.Z);
if isempty(i)
    error('Error: The lifting factor LDPC.Z=%d is not supported!', LDPC.Z);
else
    iLs = i-1;
end

% Load base graph prototype
tmpBG = load(['prototypes\BG1_ILS', num2str(iLs), '.mat']);

%% Modify base graph to desired code rate

% Find N to shorten BG accordingly
for N = 0:42
    if LDPC.rate - maxCodeRateDeviation < 22/(68-N-2) && 22/(68-N-2) < LDPC.rate + maxCodeRateDeviation
        break;
    elseif N == 42
        error('Error: Specified code rate of %f is not supported!', LDPC.rate);
    end
end

% Update actual code rate
LDPC.rate = 22/(68-N-2);

% Shorten 
LDPC.BG = tmpBG.BG(1:end-N,1:end-N);

%% Init 2
[numRows, numCols] = size(LDPC.BG);

LDPC.numParBits = numRows*LDPC.Z;
LDPC.numTotBits = (numCols-2)*LDPC.Z; % Because of systematic puncturing
LDPC.numInfBits = LDPC.numTotBits + 2*LDPC.Z - LDPC.numParBits;

LDPC.H = zeros(LDPC.numParBits, LDPC.numTotBits + 2*LDPC.Z);

%% Generate name string
if LDPC.rate < 1/3 + maxCodeRateDeviation
    rateStr = '1_3';
elseif LDPC.rate < 1/2 + maxCodeRateDeviation
    rateStr = '1_2';
elseif LDPC.rate < 2/3 + maxCodeRateDeviation
    rateStr = '2_3';
elseif LDPC.rate < 3/4 + maxCodeRateDeviation
    rateStr = '3_4';
elseif LDPC.rate < 5/6 + maxCodeRateDeviation
    rateStr = '5_6';
else
    error('Error: Unknown code rate of %f. Something went wrong!', LDPC.rate);
end
LDPC.name = ['LDPC_BG1_', num2str(LDPC.Z), '_', rateStr, '.mat'];

%% Generate LDPC matrix H
for curRow = 1:numRows
    for curCol = 1:numCols
        bgEntry = char(LDPC.BG(curRow, curCol));
        if bgEntry ~= '-' % Fill non-zero elements with circ-shifted identity matrices
            LDPC.H(1+(curRow-1)*LDPC.Z:curRow*LDPC.Z,1+(curCol-1)*LDPC.Z:curCol*LDPC.Z) = circshift(eye(LDPC.Z),-mod(str2num(bgEntry),LDPC.Z));
        end
    end
end

%% Generate parity check matrix P
Hgf = gf(LDPC.H);
H1 = Hgf(:,1:LDPC.numInfBits);
H2 = Hgf(:,LDPC.numInfBits+1:end);
Pgf = (H2\(-H1))';  % This takes a seriously long time for large matrices!
LDPC.P = double(Pgf.x);

%% Generate generator matrix G
LDPC.G = [eye(LDPC.numInfBits), LDPC.P];

%% Init iterations and decoding algorithm with standard
LDPC.iterations = 20;
LDPC.decType = 'SPA';

%% Save
save(['.\codes\', LDPC.name], 'LDPC');

end

