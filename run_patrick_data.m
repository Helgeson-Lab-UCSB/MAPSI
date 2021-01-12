parpool(20)

%% Specify experimental parameters for scattering from a rod

% Rod radius
R = 33; % A
% Rod length
L = 9200; % A
%Scattering intensity weighting factor
volfrac=1.0127E-04;
dsld=(6.33E-6)-(3.03E-6);
c = (10.^8).*pi.*R.^2.*L.*volfrac.*(dsld).^2; % cm ^ -1
%c = ;

% Background scattering intensity
b = 0.00689699; % cm ^ -1

files = dir('patrick_data/*.txt');

for filenum = 1:length(files)
filename = [files(filenum).folder '/' files(filenum).name];

%% Load experimental data

formatSpec = '%16f%16f%16f%16f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID);
raw = [dataArray{1:end-1}];
clearvars filename formatSpec fileID dataArray ans;

% Filter out data without standard deviation measurements
ind = find( raw( :, 5 ) ~= 0 );
raw = raw( ind, : );

% Filter out data with non-positive intensities
ind = find( raw( :, 4 ) > 0 );
raw = raw( ind, : );

% Wave vectors [ Qx Qy Qz ] A^-1
Q = [ raw( :, 1 ) raw( :, 2 ) raw(:,3)];
% Scattering intensity cm^-1
I = raw( :, 4 );
% Standard deviation cm^-1
sigma = raw( :, 5 ); 


%% Specify MApSI options

% Number of vertices on the unit sphere 4 (N+1)^2 + 1
N = 20;
% Range of regularization parameters
lambdas = logspace(-5,1,20);
% Number of folds during cross-validation
folds = 20;
% Number of subdivisions of triangles to do the integration
n_sub = 4;

% Generate MApSI options
opts = mapsi_options( 'N', N, 'lambdas', lambdas, 'folds', folds, 'n_sub', n_sub );

% Generate MApSI data structures
data = mapsi_data(Q, I, sigma, repmat( c, length(I), 1 ), repmat( b, length(I), 1 ), @(in,out)cylinderformfactor(R,L,in,out) ); 


%% Run MApSI
[ w, wse, in_verts, simp, lambdas, scores, minlambda, minlambdase, A, wcovse ] = mapsi( data, opts );

opts.mctrials = 1e6;
[mom_samples, mom_at_mode] = mapsi_moments_mcmc( A, wse, minlambdase, data, opts);

clear A

moments=transpose(mom_at_mode);
stdmoments = std(transpose(mom_samples(:,:)));

save([files(filenum).name '.mat'])
end
