%% Plotting pretty brains

% The vast majority of this script is taken from the example included in
% the original repository at
% https://github.com/StuartJO/BrainSurfaceAnimation.

% I've included a few adaptations to use brain aging FDG PET data, but as
% noted in the repo this is an incomplete illustration and should be taken
% as a nice visualization more than an accurate map in this format!

%% Import PET data
% This section is commented out because the actual files are not included
% in the repo (due to being distributed by ADNI and not publicly
% available). The code at the end that is uncommented uses the imported and
% rescaled maps that are provided.
% data = niftiread('ADNI_127_S_6433_PT_AV1451_Coreg,_Avg,_Standardized_Image_and_Voxel_Size_Br_20180905151031427_18_S723920_I1045302.nii');
% x = [1e5, -1];
% y = [1e5, -1];
% z = [1e5, -1];
% for i = 1:size(data, 1)
%     for j = 1:size(data, 2)
%         for k = 1:size(data, 3)
%             if data(i, j, k) >= 1
%                 if i < x(1); x(1) = i; end
%                 if i > x(2); x(2) = i; end
%                 if j < y(1); y(1) = j; end
%                 if j > y(2); y(2) = j; end
%                 if k < z(1); z(1) = k; end
%                 if k > z(2); z(2) = k; end
%             end
%         end
%     end
% end
% 
% rescaledVerts(:, 1) = round(rescale(rescaledVerts(:, 1), x(1), x(2)));
% rescaledVerts(:, 2) = round(rescale(rescaledVerts(:, 2), y(1), y(2)));
% rescaledVerts(:, 3) = round(rescale(rescaledVerts(:, 3), z(1), z(2)));
% 
% parc_color_old = [];
% for i = 1:length(rescaledVerts(:, 1))
%     parc_color_old(i, 1) = data(rescaledVerts(i, 1), rescaledVerts(i, 2), rescaledVerts(i, 3));
% end
% 
% parc_color_old = round(rescale(parc_color_old, 1, 100));
% 
% %%
% data = niftiread('ADNI_016_S_6773_PT_AV1451_Coreg,_Avg,_Standardized_Image_and_Voxel_Size_Br_20191204081626274_85_S901134_I1261997.nii');
% x = [1e5, -1];
% y = [1e5, -1];
% z = [1e5, -1];
% for i = 1:size(data, 1)
%     for j = 1:size(data, 2)
%         for k = 1:size(data, 3)
%             if data(i, j, k) >= 1
%                 if i < x(1); x(1) = i; end
%                 if i > x(2); x(2) = i; end
%                 if j < y(1); y(1) = j; end
%                 if j > y(2); y(2) = j; end
%                 if k < z(1); z(1) = k; end
%                 if k > z(2); z(2) = k; end
%             end
%         end
%     end
% end
% 
% rescaledVerts(:, 1) = round(rescale(rescaledVerts(:, 1), x(1), x(2)));
% rescaledVerts(:, 2) = round(rescale(rescaledVerts(:, 2), y(1), y(2)));
% rescaledVerts(:, 3) = round(rescale(rescaledVerts(:, 3), z(1), z(2)));
% 
% parc_color_young = [];
% for i = 1:length(rescaledVerts(:, 1))
%     parc_color_young(i, 1) = data(rescaledVerts(i, 1), rescaledVerts(i, 2), rescaledVerts(i, 3));
% end
% 
% parc_color_young = round(rescale(parc_color_young, 1, 100));

load('parcellation_data.mat');

%% Modified from the original script from https://github.com/StuartJO/BrainSurfaceAnimation
% This shows an example of how to use this script

addpath ./export_fig
addpath ./plotSurfaceROIBoundary

% Read in dHCP surface data
load('./data/example_fetal_data.mat')

% Create a parcellation with N parcels
N = 100;

% Parcellate the sphere using k-means clustering
parc_orig = parcellate_surface(fetal36_sphere_verts, N);

% Make the parcellation pretty
% Order ROI IDs by their dorsal-ventral position.
parc_z = zeros(N,1);

for i = 1:N
    parc_z(i) = min(fetal36_sphere_verts(parc_orig==i,3));
end
newparcval = 1:N;
[~,ordered_parc] = sort(parc_z);
parc = parc_orig;
for k = 1:numel(ordered_parc)
    parc(parc_orig == ordered_parc(k)) = newparcval(k);
end
%%
% The commented code below will do exactly the same as above, however it
% uses the plotSurfaceROIBoundary code to assign values to each parcel
% rather than directly specifying each vertex
%SurfMorphAnimation(fetal_verts,fetal_faces,'frames',10,'vertParc',parc,'vertData',1:N)

% Plot the brain with the colours of the parcellation and no border

% Changed this command to plot the two colormaps shown on the oldest brain
% parcellation - AGC
figure
SurfMorphAnimation({fetal_verts{16}, fetal_verts{16}},fetal_faces,'NInterpPoints',75,'vertParc',parc,'vertData',{parc_color_young, parc_color_old},'plotBoundary',false,'outgif','./outputs/voila.gif')
