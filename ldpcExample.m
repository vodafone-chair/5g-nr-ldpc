%% Clean up
clear all;
clc;

%% Init
if ~isdeployed
    addpath('./codes');
end

% Constellation size
M = 4;

% LDPC config
blkSize = 256;
codeRate = '5/6';

% Get LDPC struct
LDPC = ldpcGet(blkSize, codeRate);

% Simulation parameters
ebno = 8;
numIter = 1e2;
numErr = 0;

% Convert E_b/N_0 to some SNR
snr = ebno + 10*log10(log2(M)) + 10*log10(str2num(codeRate));

%% Simulate
for i = 1:numIter
    
    % Generate random data
    data = randi([0 1], 1, LDPC.numInfBits);

    % Encode
    dataEnc = ldpcEncode(data, LDPC);

    % QAM mapping
    dataMod = qammod(dataEnc(:), M, 'InputType', 'bit', 'UnitAveragePower', true);

    % AWGN
    dataRx = awgn(dataMod, snr);

    % LLR demapping
    dataLlr = qamdemod(dataRx, M, 'OutputType', 'llr', 'UnitAveragePower', true);

    % Decode
    dataHat = ldpcDecode(dataLlr', LDPC);

    % Count number of bit errors
    numErr = numErr + sum(abs(dataHat - data));
    
end

%% BER
ber = numErr / (numIter * LDPC.numInfBits)