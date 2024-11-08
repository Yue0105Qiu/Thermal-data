function [result] = fun_plot(filename, Arg_arr)
% This function is used to plot the Cp, H, and S vs T profiles from
% CHEMKIN-formatted data files.
% The source data input file is from "thermo_test.dat"
% In Arg_arr, you can choose either "H", "Cp", "S".
% The results are stored in a struct named "result", which has 3 fields: 
% 1. Arg: name of the argument  "H"/"Cp"/"S"
% 2. Value: [x y y_diff]. Note y_diff is the relative difference against
% the first species dataset.
% 3. Diff: the annotation of the relative differences. the T point and its
% relative difference in %.
fid = fopen(filename);
i = 0;

% read the lines from "thermo_test.dat"
while ~feof(fid)
    i=i+1;
    tline=fgetl(fid); %1st line
    temp=regexp(tline,'\s+','split');
    len=length(temp);
    legend_name{i}=char(temp(1));
    T(i,1)=str2num(char(temp(len-3)));
    T(i,2)=str2num(char(temp(len-1)));
    T(i,3)=str2num(char(temp(len-2)));
    tline=fgetl(fid); %2nd line
    HT(i,1)=str2num(strtrim(tline(1:15)));
    HT(i,2)=str2num(strtrim(tline(16:30)));
    HT(i,3)=str2num(strtrim(tline(31:45)));
    HT(i,4)=str2num(strtrim(tline(46:60)));
    HT(i,5)=str2num(strtrim(tline(61:75)));
    tline=fgetl(fid); %3rd line
    HT(i,6)=str2num(strtrim(tline(1:15)));
    HT(i,7)=str2num(strtrim(tline(16:30)));
    LT(i,1)=str2num(strtrim(tline(31:45)));
    LT(i,2)=str2num(strtrim(tline(46:60)));
    LT(i,3)=str2num(strtrim(tline(61:75)));    
    tline=fgetl(fid); %4th line
    LT(i,4)=str2num(strtrim(tline(1:15)));
    LT(i,5)=str2num(strtrim(tline(16:30)));
    LT(i,6)=str2num(strtrim(tline(31:45)));
    LT(i,7)=str2num(strtrim(tline(46:60)));
end
fclose(fid);
% number of species to calculate their thermodynamic properties.
len = i; 

% number of the arguments from input, can be H, Cp, S.
len_arg = length(Arg_arr); 

% a struct to store the results
result = struct('Arg', {}, 'Value', {}, 'Diff',{});

% set a temperature interval to plot
deltaT = 10; 
for k = 1:len_arg
    % Determine x array based on the Temperature points from the 1st line
    % of each species data set
    x = T(i,1) : deltaT : T(i,3); % 1 x n array
    x1 = x(x <= T(i,2)); % 1 x n1 array
    x2 = x(x > T(i,2));  % 1 x n2 array
    
    % Uniform setting for figure plot either in Cp/R, H/RT, S/R
    figure(k);
    set(gca,'color','none');
    set(gca,'FontSize',12);
    box on;
    hold on
    
    %%%============ Plot Cp/R. Cp/R=a1+a2x+a3x^2+a4x^3+a5x^4 ============%%% 
    if Arg_arr(k) == "Cp"    
        for i=1:len
            Cp_1=LT(i,1:5)*[ones(1, length(x1)) ;x1 ;x1.^2 ;x1.^3 ;x1.^4]; % 1 x n1 array
            Cp_2=HT(i,1:5)*[ones(1, length(x2)) ;x2 ;x2.^2 ;x2.^3 ;x2.^4]; % 1 x n2 array
            Cp=[Cp_1 Cp_2]; % 1 x n array
            Cp_t{i}=[x.' Cp.'];
        end
        for i=1:len
            plot(Cp_t{i}(:,1), Cp_t{i}(:,2),'linewidth',2);
        end
        xlim([300 5000]); 
        % xlim([max(T(:,1)) min(T(:,3))]); 
        % ylim([2 6]);
        ylabel('Cp/R','FontSize',14)
        title('Cp/R data','FontSize',16)
        % Annotate the relative difference between different thermo files
        [y_var, y_diff, peak] = fun_annotate(x,Cp_t);
        
        
        %%============ Plot H/RT. H/RT=a1+a2/2x+a3/3x^2+a4/4x^3+a5/5x^4+a6/x ============%%%
    elseif Arg_arr(k) == "H"
        for i=1:len
            H_1=LT(i,1:6)*[ones(1,length(x1));x1/2;x1.^2/3;x1.^3/4;x1.^4/5;1./x1];
            H_2=HT(i,1:6)*[ones(1,length(x2));x2/2;x2.^2/3;x2.^3/4;x2.^4/5;1./x2];
            H=[H_1 H_2];
            H_t{i}=[x.' H.'];
        end
        for i=1:len
        plot(H_t{i}(:,1), H_t{i}(:,2),'linewidth',2);
        end
        xlim([300 5000]);
        ylabel('H/RT ','FontSize',14);
        title('H/RT data','FontSize',16);
        
        % Annotate the relative difference between different thermo files
        [y_var, y_diff, peak] = fun_annotate(x.',H_t);
     
        
        %%%============ Plot S/R. S/R=a1lnx+a2x+a3/2x^2+a4/3x^3+a5/4x^4+a7 ============%%% 
    elseif Arg_arr(k) == "S"
        for i=1:len
            S_1=LT(i,[7 1:5])*[ones(1,length(x1));log(x1);x1;x1.^2/2;x1.^3/3;x1.^4/4];
            S_2=HT(i,[7 1:5])*[ones(1,length(x2));log(x2);x2;x2.^2/2;x2.^3/3;x2.^4/4];
            S=[S_1 S_2];
            S_t{i}=[x.' S.'];
        end
        for i=1:len
        plot(S_t{i}(:,1), S_t{i}(:,2),'linewidth',2);
        end
        xlim([300 5000]);
        % xlim([max(T(:,1)) min(T(:,3))]); 
        % ylim([40 80]);
        ylabel('S/R ','FontSize',14)
        title('S/R data','FontSize',16)
        
        % Annotate the relative difference between different thermo files
        [y_var, y_diff, peak] = fun_annotate(x.',S_t);
        
    end
   % Write into the result matrix
    result(k).Arg = Arg_arr(k);
    result(k).Value = [x.' y_var y_diff];
    result(k).Diff = peak;
    
    % Uniform setting for figure plot either in Cp/R, H/RT, S/R
    legend(legend_name,'FontSize',12);
    xlabel('Temperature /K','FontSize',14);
    hold off
    
end
