function [ LDPC ] = ldpcGet( blkSize, codeRate, iterations, decType )
%LDPCGET Simple LDPC interface which returns a struct 'LDPC' for the 
% specified LDPC code. More advanced options can be specified using the 
% ldpcGetAdvanced(...) function.
% This implementation supports code rates of R=['1/3', '1/2', '2/3', 
% '3/4', '5/6'] and block sizes of N~[256, 512, 1024, 2048, 4096, 8192].

%% Find code rate block size configuration!
if strcmp(codeRate, '1/3')
        
        switch blkSize
            case 256
                ldpc_file = 'LDPC_BG1_4_1_3.mat';
            case 512
                ldpc_file = 'LDPC_BG1_8_1_3.mat';
            case 1024
                ldpc_file = 'LDPC_BG1_16_1_3.mat';
            case 2048
                ldpc_file = 'LDPC_BG1_32_1_3.mat';
            case 4096
                ldpc_file = 'LDPC_BG1_64_1_3.mat';
            case 8192
                ldpc_file = 'LDPC_BG1_128_1_3.mat';
            otherwise
                error('Error: The specified blockSize %d is not supported!', blkSize);
        end
        
elseif strcmp(codeRate, '1/2')
        
        switch blkSize
            case 256
                ldpc_file = 'LDPC_BG1_6_1_2.mat';
            case 512
                ldpc_file = 'LDPC_BG1_12_1_2.mat';
            case 1024
                ldpc_file = 'LDPC_BG1_24_1_2.mat';
            case 2048
                ldpc_file = 'LDPC_BG1_48_1_2.mat';
            case 4096
                ldpc_file = 'LDPC_BG1_96_1_2.mat';
            case 8192
                ldpc_file = 'LDPC_BG1_192_1_2.mat';
            otherwise
                error('Error: The specified blockSize %d is not supported!', blkSize);
        end
        
elseif strcmp(codeRate, '2/3')
        
        switch blkSize
            case 256
                ldpc_file = 'LDPC_BG1_8_2_3.mat';
            case 512
                ldpc_file = 'LDPC_BG1_16_2_3.mat';
            case 1024
                ldpc_file = 'LDPC_BG1_32_2_3.mat';
            case 2048
                ldpc_file = 'LDPC_BG1_64_2_3.mat';
            case 4096
                ldpc_file = 'LDPC_BG1_128_2_3.mat';
            case 8192
                ldpc_file = 'LDPC_BG1_256_2_3.mat';
            otherwise
                error('Error: The specified blockSize %d is not supported!', blkSize);
        end
        
elseif strcmp(codeRate, '3/4')
        
        switch blkSize
            case 256
                ldpc_file = 'LDPC_BG1_9_3_4.mat';
            case 512
                ldpc_file = 'LDPC_BG1_18_3_4.mat';
            case 1024
                ldpc_file = 'LDPC_BG1_36_3_4.mat';                
            case 2048
                ldpc_file = 'LDPC_BG1_72_3_4.mat';
            case 4096
                ldpc_file = 'LDPC_BG1_144_3_4.mat';
            case 8192
                ldpc_file = 'LDPC_BG1_288_3_4.mat';
            otherwise
                error('Error: The specified blockSize %d is not supported!', blkSize);
        end
        
elseif strcmp(codeRate, '5/6')
        
        switch blkSize
            case 256
                ldpc_file = 'LDPC_BG1_10_5_6.mat';
            case 512
                ldpc_file = 'LDPC_BG1_20_5_6.mat';
            case 1024
                ldpc_file = 'LDPC_BG1_40_5_6.mat';
            case 2048
                ldpc_file = 'LDPC_BG1_80_5_6.mat';
            case 4096
                ldpc_file = 'LDPC_BG1_160_5_6.mat';
            case 8192
                ldpc_file = 'LDPC_BG1_320_5_6.mat';
            otherwise
                error('Error: The specified blockSize %d is not supported!', blkSize);
        end
        
else
        error('Error: The specified code rate %f is not supported!', codeRate);
end

%% Load LDPC code
% Load code
disp(['Load file ', ldpc_file, ' ...']);
% Use addpath('./codes') in order to be able to use this
load(ldpc_file);
disp('Success!');

%% Specify iterations and decoding algorithm (optional)
if exist('iterations')
    LDPC.iterations = iterations;
end
if exist('decType')
    LDPC.decType = decType;
end

end

