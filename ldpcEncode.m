function [ encVec ] = ldpcEncode( bitVec, LDPC )
%LDPCENCODE Encode the input bit vector using the LDPC code specified in
% struct 'LDPC'.

% Check if input has correct size
assert(size(bitVec,2)==LDPC.numInfBits, 'Error: The given input vector has length %d, correct input length is %d!', length(bitVec), LDPC.numInfBits)

% Encode 
encVec = mod(bitVec * LDPC.G, 2); % Note: This is very inefficient.

% Puncturing of 2*Z first systematic bits
encVec = encVec(:,2*LDPC.Z+1:end);

end

