function [result] = fun_plot(filename, Arg_arr)
fid = fopen(filename);
i = 0;
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
len = i;
len_arr = length(Arg_arr);
result = cell(len_arr, 2);
j = 1; % index for the result matrix.

for k = 1:len_arr
    if Arg_arr(k) == "Cp" 
        %%%============ Plot Cp/R. Cp/R=a1+a2x+a3x^2+a4x^3+a5x^4 ============%%% 
        for i=1:len
            x1=T(i,1):10:T(i,2);
            Cp_1=LT(i,1:5)*[ones(1,length(x1));x1;x1.^2;x1.^3;x1.^4];
            x2=T(i,2):10:T(i,3);
            Cp_2=HT(i,1:5)*[ones(1,length(x2));x2;x2.^2;x2.^3;x2.^4];
            x=[x1 x2];
            Cp=[Cp_1 Cp_2];
            Cp_t{i}=[x.' Cp.'];
        end
        figure(1);
        set(gca,'color','none');
        hold on
        for i=1:len
            plot(Cp_t{i}(:,1), Cp_t{i}(:,2),'linewidth',2);
        end
        set(gca,'FontSize',12);
        legend(legend_name,'FontSize',12);
        box on;
        xlim([300 5000]); % xlim([max(T(:,1)) min(T(:,3))]); 
        % ylim([2 6]);
        xlabel('Temperature /K','FontSize',14)
        ylabel('Cp/R','FontSize',14)
        title('Cp/R data','FontSize',16)
        hold off

        % Annotate the relative difference between different thermo files
        x_var = (max(T(:,1)):10: min(T(:,3))).';
        [y_var, y_diff, peak] = fun_annotate(x_var,Cp_t);
        
        % Write into the result matrix.
        result{j,1} = [x_var y_var y_diff];
        result{j,2} = peak;
        j = j+1;
    elseif Arg_arr(k) == "H"
        %%============ Plot H/RT. H/RT=a1+a2/2x+a3/3x^2+a4/4x^3+a5/5x^4+a6/x ============%%% 
        for i=1:len
            x1=T(i,1):10:T(i,2);
            H_1=LT(i,1:6)*[ones(1,length(x1));x1/2;x1.^2/3;x1.^3/4;x1.^4/5;1./x1];
            x2=T(i,2):10:T(i,3);
            H_2=HT(i,1:6)*[ones(1,length(x2));x2/2;x2.^2/3;x2.^3/4;x2.^4/5;1./x2];
            x=[x1 x2];
            H=[H_1 H_2];
            H_t{i}=[x.' H.'];
        end

        figure(2);
        hold on
        for i=1:len
        plot(H_t{i}(:,1), H_t{i}(:,2),'linewidth',2);
        end
        set(gca,'FontSize',12);
        Lgnd = legend(legend_name,'FontSize',12);
        box on;
        xlim([300 5000]);
        xlabel('Temperature /K','FontSize',14);
        ylabel('H/RT ','FontSize',14);
        title('H/RT data','FontSize',16);
        hold off
        % Annotate the relative difference between different thermo files
        [y_var, y_diff, peak] = fun_annotate(x_var,H_t);
        
        % Write into the result matrix.
        result{j,1} = [x_var y_var y_diff];
        result{j,2} = peak;
        j = j+1;
        
    elseif Arg_arr(k) == "S"
        %%%============ Plot S/R. S/R=a1lnx+a2x+a3/2x^2+a4/3x^3+a5/4x^4+a7 ============%%% 
        for i=1:len
            x1=T(i,1):10:T(i,2);
            S_1=LT(i,[7 1:5])*[ones(1,length(x1));log(x1);x1;x1.^2/2;x1.^3/3;x1.^4/4];
            x2=T(i,2):10:T(i,3);
            S_2=HT(i,[7 1:5])*[ones(1,length(x2));log(x2);x2;x2.^2/2;x2.^3/3;x2.^4/4];
            x=[x1 x2];
            S=[S_1 S_2];
            S_t{i}=[x.' S.'];
        end

        figure(3);
        hold on
        for i=1:len
        plot(S_t{i}(:,1), S_t{i}(:,2),'linewidth',2);
        end
        set(gca,'FontSize',12);
        legend(legend_name,'FontSize',12);
        box on;
        % % xlim([300 5000]);
        % xlim([max(T(:,1)) min(T(:,3))]); 
        % ylim([40 80]);
        xlabel('Temperature /K','FontSize',14)
        ylabel('S/R ','FontSize',14)
        title('S/R data','FontSize',16)
        hold off
        % Annotate the relative difference between different thermo files
        [y_var, y_diff, peak] = fun_annotate(x_var,S_t);
        
        % Write into the result matrix.
        result{j,1} = [x_var y_var y_diff];
        result{j,2} = peak;
    end
end




