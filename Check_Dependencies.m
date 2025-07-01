fprintf('\n Below is the list of dependent packages for HigherOrderPLSPM_Prime.') 

dependencies = {...
    'PLSPM.Basic_Prime', 'https://github.com/PsycheMatrica/PLSPM.Basic_Prime'};
fprintf('\n     - %s',dependencies{1,1})
addonsFolder = fullfile(getenv('APPDATA'), 'MathWorks', 'MATLAB Add-Ons', 'Collections');
% Create the Collections folder if it doesn't exist
if ~exist(addonsFolder, 'dir')
    mkdir(addonsFolder);
end
% Loop through the dependencies and check for their installation
for i = 1:size(dependencies, 1)
    packageName = dependencies{i, 1};
    packageURL = dependencies{i, 2};
    packageFolder = fullfile(addonsFolder, packageName);

    % Check if the package is installed (e.g., by looking for a key function)
    if 0==exist(packageName, 'dir')  % Adjust the check according to your structure
        fprintf('\nInstalling %s...\n', packageName);
        
        % Download and install the package from GitHub
        zipFileName = [packageName, '.zip'];
        websave(zipFileName, [packageURL, '/archive/refs/heads/main.zip']);
        tempUnzipFolder = tempname;  % Create a temporary folder for unzipping
        unzip(zipFileName, tempUnzipFolder);
        
        % Move the contents of the unzipped folder to the desired packageFolder
        unzippedContent = dir(tempUnzipFolder);
        unzippedContent = unzippedContent([unzippedContent.isdir]);  % Get the directories
        unzippedFolder = fullfile(tempUnzipFolder, unzippedContent(3).name);  % Get the folder without '.' and '..'
        
        % Move files from unzipped folder to package folder
        movefile(fullfile(unzippedFolder, '*'), packageFolder);
        
        % Clean up by removing the temporary folder
        rmdir(tempUnzipFolder, 's');
        delete(zipFileName);  % Clean up the downloaded zip file
        addpath(packageFolder);
    else
        fprintf('\n%s is already installed.\n', packageName);
    end
end

% Save the MATLAB path to persist across sessions
%savepath;

fprintf('\nAll packages installed in Add-Ons Collections folder.\n');

%{
dependencies = {...
    'BasicPLSPM_Prime', '174095'};
% Check installed add-ons
installedAddons = matlab.addons.installedAddons();

for i = 1:size(dependencies, 1)
    packageName = dependencies{i, 1};
    packageID = dependencies{i, 2};

    % Check if the package is already installed
    if ~any(strcmp(installedAddons.Name, packageName))
        fprintf('Installing %s from MATLAB File Exchange...\n', packageName);
        
        % Install the package from MATLAB File Exchange using the ID
        matlab.addons.install(['https://www.mathworks.com/matlabcentral/fileexchange/', packageID]);
        
    else
        fprintf('%s is already installed.\n', packageName);
    end
end
%}