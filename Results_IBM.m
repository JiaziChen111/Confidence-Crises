function Results_IBM(fig_output,simtype,Results,CB_TOTallotment,T_sim,shocktime,FRFAtime,...
    results_IBM_format,includebounds,outputlabel)

if strcmp(simtype,'baseline')
    fig_output_IBM = strcat(fig_output,'Results/baseline/IBM/');
elseif  strcmp(simtype,'crisis')
    fig_output_IBM = strcat(fig_output,'Results/crisis/IBM/');
end

%Results_agg = Results(:,:,4);

if strcmp(results_IBM_format,'agg_')
    Results_plot =  Results(:,:,4,:);
elseif strcmp(results_IBM_format,'av_')
    Results_plot    = Results(:,:,1,:); % Plot average values
    Results_plot_LB = Results(:,:,2,:); % Plot max and min around average
    Results_plot_UB = Results(:,:,3,:);
end
%-----------------------------------------------------
% Phase 1 Volumes
%-----------------------------------------------------

% Plotting requests and loans separately

figure
subplot(1,2,1) % Interbank loan requests vs actual loans
    if strcmp(results_IBM_format,'agg_')
        plot(Results_plot(8,:),'Color','r','LineWidth',1.1) % Total Loan requests
        hold on
        plot(Results_plot(10,:),'Color','b','LineWidth',1.1) % Total Loans
        title('Interbank loan volumes')
        hold off
    elseif strcmp(results_IBM_format,'av_')
        if strcmp(includebounds,'BOn')
            boundedline(1:T_sim,Results_plot(8,:),[Results_plot_LB(8,:);Results_plot_UB(8,:)]','alpha')
            hold on
            boundedline(1:T_sim,Results_plot(10,:),[Results_plot_LB(10,:);Results_plot_UB(10,:)]','alpha');
        elseif strcmp(includebounds,'BOff')
            if strcmp(simtype,'crisis')
                rectangle('Position',[shocktime(1),0,shocktime(end)-shocktime(1),1.2],'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
                hold on;
                %plot([FRFAtime(1), FRFAtime(1)],get(gca,'ylim'),'--k','LineWidth',2);
                %hold on;
            end
            h1 = plot(Results_plot(8,:,1),'Color','r','LineWidth',1.1);
            hold on
            h2 = plot(Results_plot(10,:,1),'Color','b','LineWidth',1.1);
            xlim([0 T_sim]);
        end
    end
    grid on;
    if strcmp(simtype,'baseline')
        title({'(a) Loan volumes','CB refinancing OFF'},'Interpreter','latex')
    elseif strcmp(simtype,'crisis')
        title({'(b) Loan volumes','FRFA OFF'},'Interpreter','latex')
    end
    legend([h1 h2],{'Requests','Loans'},'Location','best','FontSize',6,'Interpreter','latex')
%----------------------------------------------------------------------------------------------------------
subplot(1,2,2) % Interbank loan requests vs actual loans
    if strcmp(results_IBM_format,'agg_')
        plot(Results_plot(8,:,2),'Color','b','LineWidth',1.1) % Total Loan requests
        hold on
        plot(Results_plot(10,:,2),'Color','r','LineWidth',1.1) % Total Loans
        title('Interbank loan volumes')
        hold off
    elseif strcmp(results_IBM_format,'av_')
        if strcmp(includebounds,'BOn')
            boundedline(1:T_sim,Results_plot(8,:),[Results_plot_LB(8,:);Results_plot_UB(8,:)]','alpha')
            hold on
            boundedline(1:T_sim,Results_plot(10,:),[Results_plot_LB(10,:);Results_plot_UB(10,:)]','alpha');
        elseif strcmp(includebounds,'BOff')
            if strcmp(simtype,'crisis')
                rectangle('Position',[shocktime(1),0,shocktime(end)-shocktime(1),1.2],...
                    'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
                hold on;
                plot([FRFAtime(1), FRFAtime(1)],get(gca,'ylim'),'--k','LineWidth',2);
                hold on;
            end
            h1 = plot(Results_plot(8,:,2),'Color','r','LineWidth',1.1);
            hold on
            h2 = plot(Results_plot(10,:,2),'Color','b','LineWidth',1.1);
            xlim([0 T_sim]);
        end
    end
    grid on;
    if strcmp(simtype,'baseline')
        title({'(a) Loan volumes','CB refinancing ON'},'Interpreter','latex')
    elseif strcmp(simtype,'crisis')
        title({'(b) Loan volumes','FRFA ON'},'Interpreter','latex')
    end
    %legend([h1 h2],{'Requests','Loans'},'Location','best','FontSize',8,'Interpreter','latex') 
grid on;
xlabel('Iteration step','Interpreter','latex')
set(gcf,'renderer','painters');
%set(gcf,'Units','Inches');
%pos = get(gcf,'Position');
%set(gcf,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3),pos(4)])
set(gcf,'Units', 'Centimeters', 'Position', [0, 0, 16, 8],'PaperUnits','Centimeters','PaperSize',[16,8])
print(gcf,'-dpdf',strcat(fig_output_IBM,'IBM_phase1_vol_',outputlabel,'.pdf'));
    
% Plotting difference between requests and loans in one line  
    
figure
if strcmp(results_IBM_format,'agg_')
    plot(Results_plot(9,:),'Color','b','LineWidth',1.1) % Total Loan requests
    title('Lender hoarding')
elseif strcmp(results_IBM_format,'av_')
    if strcmp(includebounds,'BOn')
        boundedline(1:T_sim,Results_plot(9,:),[Results_plot_LB(9,:);Results_plot_UB(9,:)]','alpha');
    elseif strcmp(includebounds,'BOff')
        if strcmp(simtype,'crisis')
            rectangle('Position',[shocktime(1),0,shocktime(end)-shocktime(1),0.2],...
                'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
            hold on;
            plot([FRFAtime(1), FRFAtime(1)],get(gca,'ylim'),'--k','LineWidth',2);
            hold on;
        end
        h1 = plot(Results_plot(9,:,1),'Color','r','LineWidth',1.1);
        hold on
        h2 = plot(Results_plot(9,:,2),'Color','b','LineWidth',1.1);
        xlim([0 T_sim]);
    end
end
title('(c) Lender hoarding','Interpreter','latex')
if strcmp(simtype,'baseline')
    legend([h1 h2],{'CB refinancing OFF','CB refinancing ON'},...
        'Location','best','FontSize',6,'Interpreter','latex')
elseif strcmp(simtype,'crisis')
    legend([h1 h2],{'FRFA OFF','FRFA ON'},...
        'Location','best','FontSize',6,'Interpreter','latex')
end
grid on;
xlabel('Iteration step','Interpreter','latex')
set(gcf,'renderer','painters');
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(gcf,'-dpdf',strcat(fig_output_IBM,'IBM_phase1_diff_',outputlabel,'.pdf'));

%-----------------------------------------------------
% Phase 2 Volumes
%-----------------------------------------------------

% Plotting expected and final loan repayment separately
figure
subplot(1,2,1) % Expected vs. actual interbank loan repayment
    if strcmp(results_IBM_format,'agg_')
        plot(Results_plot(11,:),'Color','b','LineWidth',1.1) % Total expected repayment
        hold on
        plot(Results_plot(12,:),'Color','k','LineWidth',1.1) % Total Loans
        title('Interbank loan volumes')
        hold off
    elseif strcmp(results_IBM_format,'av_')
        if strcmp(includebounds,'BOn')
            boundedline(1:T_sim,Results_plot(8,:),[Results_plot_LB(8,:);Results_plot_UB(8,:)]','alpha')
            hold on
            boundedline(1:T_sim,Results_plot(10,:),[Results_plot_LB(10,:);Results_plot_UB(10,:)]','alpha');
        elseif strcmp(includebounds,'BOff')
            if strcmp(simtype,'crisis')
                rectangle('Position',[shocktime(1),0,shocktime(end)-shocktime(1),1.2],...
                    'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
                hold on;
                %plot([FRFAtime(1), FRFAtime(1)],get(gca,'ylim'),'--k','LineWidth',2);
                %hold on;
            end
            h1 = plot(Results_plot(11,:,1),'Color','r','LineWidth',1.1);
            hold on
            h2 = plot(Results_plot(12,:,1),'Color','b','LineWidth',1.1);
            xlim([0 T_sim]);
        end
    end
    grid on;
    if strcmp(simtype,'baseline')
        title({'(a) Repayment volumes','CB refinancing OFF'},'Interpreter','latex')
    elseif strcmp(simtype,'crisis')
        title({'(b) Repayment volumes','FRFA OFF'},'Interpreter','latex')
    end
    legend([h1 h2],{'Expected repayment','Final repayment'},...
        'Location','best','FontSize',6,'Interpreter','latex')
%----------------------------------------------------------------------------------------------------------
subplot(1,2,2) % Interbank loan requests vs actual loans
    if strcmp(results_IBM_format,'agg_')
        plot(Results_plot(11,:,2),'Color','r','LineWidth',1.1) % Total Loan requests
        hold on
        plot(Results_plot(12,:,2),'Color','b','LineWidth',1.1) % Total Loans
        title('Interbank repayment volumes')
        hold off
    elseif strcmp(results_IBM_format,'av_')
        if strcmp(includebounds,'BOn')
            boundedline(1:T_sim,Results_plot(8,:),[Results_plot_LB(8,:);Results_plot_UB(8,:)]','alpha')
            hold on
            boundedline(1:T_sim,Results_plot(10,:),[Results_plot_LB(10,:);Results_plot_UB(10,:)]','alpha');
        elseif strcmp(includebounds,'BOff')
            if strcmp(simtype,'crisis')
                rectangle('Position',[shocktime(1),0,shocktime(end)-shocktime(1),1.2],'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
                hold on;
                plot([FRFAtime(1), FRFAtime(1)],get(gca,'ylim'),'--k','LineWidth',2);
                hold on;
            end
            h1 = plot(Results_plot(11,:,2),'Color','r','LineWidth',1.1);
            hold on
            h2 = plot(Results_plot(12,:,2),'Color','b','LineWidth',1.1);
            xlim([0 T_sim]);
        end
    end
    grid on;
    if strcmp(simtype,'baseline')
        title({'(a) Repayment volumes','CB refinancing ON'},'Interpreter','latex')
    elseif strcmp(simtype,'crisis')
        title({'(b) Repayment volumes','FRFA ON'},'Interpreter','latex')
    end
    %legend([h1 h2],{'Requests','Loans'},'Location','best','FontSize',8,'Interpreter','latex')  
 grid on;
xlabel('Iteration step','Interpreter','latex')
set(gcf,'renderer','painters');
%set(gcf,'Units','Inches');
%pos = get(gcf,'Position');
%set(gcf,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3),pos(4)])
set(gcf,'Units', 'Centimeters', 'Position', [0, 0, 16, 8],'PaperUnits','Centimeters','PaperSize',[16,8])
print(gcf,'-dpdf',strcat(fig_output_IBM,'IBM_phase2_vol_',outputlabel,'.pdf'));  
    
% Plotting difference between expected and final repayment in one line
figure
if strcmp(results_IBM_format,'agg_')
    plot(Results_plot(9,:),'Color','b','LineWidth',1.1) % Total Loan requests
    title('Lender hoarding')
elseif strcmp(results_IBM_format,'av_')
    if strcmp(includebounds,'BOn')
        boundedline(1:T_sim,Results_plot(9,:),[Results_plot_LB(9,:);Results_plot_UB(9,:)]','alpha');
    elseif strcmp(includebounds,'BOff')
        if strcmp(simtype,'crisis')
            rectangle('Position',[shocktime(1),0,shocktime(end)-shocktime(1),0.2],...
            'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
             hold on;
             plot([FRFAtime(1), FRFAtime(1)],get(gca,'ylim'),'--k','LineWidth',2);
             hold on;
             xlim([0 T_sim]);
        end
        h1 = plot(Results_plot(11,:,1)-Results_plot(12,:,1),'Color','r','LineWidth',1.1);
        hold on
        h2 = plot(Results_plot(11,:,2)-Results_plot(12,:,2),'Color','b','LineWidth',1.1);
     end
end
%title('(c) Borrower defaults','Interpreter','latex')
if strcmp(simtype,'baseline')
    legend([h1 h2],{'CB refinancing OFF','CB refinancing ON'},'Location','best','FontSize',8,'Interpreter','latex')
elseif strcmp(simtype,'crisis')
    legend([h1 h2],{'FRFA OFF','FRFA ON'},'Location','best','FontSize',8,'Interpreter','latex')
end
grid on;
xlabel('Iteration step','Interpreter','latex')
set(gcf,'renderer','painters');
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(gcf,'-dpdf',strcat(fig_output_IBM,'IBM_phase2_diff_',outputlabel,'.pdf'));


%-----------------------------------------------------
% Interbank Rate
%-----------------------------------------------------

figure
if strcmp(includebounds,'BOn')
    confplot(1:T_sim,Results_plo(15,:),Results_min(15,:),Results_max(15,:))
elseif strcmp(includebounds,'BOff')
    if strcmp(simtype,'crisis')
        rectangle('Position',[shocktime(1),1,shocktime(end)-shocktime(1),0.05],...
            'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
        hold on;
        plot([FRFAtime(1), FRFAtime(1)],get(gca,'ylim'),'--k','LineWidth',2);
        hold on;
    end
    h1 = plot(Results_plot(15,:,1),'Color','r','LineWidth',1.1);
    hold on
    h2 = plot(Results_plot(15,:,2),'Color','b','LineWidth',1.1);
    xlim([0 T_sim]);   
end
xlabel('Iteration step','Interpreter','latex')
grid on;
if strcmp(simtype,'baseline')
    legend([h1 h2],{'CB refinancing OFF','CB refinancing ON'},...
        'Location','best','FontSize',6,'Interpreter','latex')
elseif strcmp(simtype,'crisis')
    legend([h1 h2],{'FRFA OFF','FRFA ON'},...
        'Location','best','FontSize',6,'Interpreter','latex')
end
set(gcf,'renderer','painters');
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(gcf,'-dpdf',strcat(fig_output_IBM,'IBrates_',outputlabel,'.pdf'));

%--------------------------------------------------
% Central bank liquidity provision
%--------------------------------------------------

figure
if strcmp(includebounds,'BOn')
    confplot(1:T_sim,CB_TOTallotment(1,:),CB_TOTallotment(2,:),CB_TOTallotment(3,:))
elseif strcmp(includebounds,'BOff')
    if strcmp(simtype,'crisis')
        rectangle('Position',[shocktime(1),0,shocktime(end)-shocktime(1),5],...
            'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
        hold on;
        plot([FRFAtime(1), FRFAtime(1)],get(gca,'ylim'),'--k','LineWidth',2);
        hold on;
    end
    h1 = plot(CB_TOTallotment(1,:,2));
    hold on
    h2 = plot(CB_TOTallotment(2,:,2));
    if strcmp(simtype,'crisis')
        h3 =plot(CB_TOTallotment(3,:,2));
    end
    xlim([0 T_sim]);
end
grid on;
if strcmp(simtype,'baseline')
    legend([h1 h2],{'Borrower refinancing','Lender refinancing'},...
        'Location','best','FontSize',6,'Interpreter','latex');
elseif strcmp(simtype,'crisis')
     legend([h1 h2 h3],{'Borrower refinancing','Lender refinancing','FRFA refinancing'},...
        'Location','best','FontSize',6,'Interpreter','latex');
end
xlabel('Iteration step','Interpreter','latex')
set(gcf,'renderer','painters');
set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(gcf,'-dpdf',strcat(fig_output_IBM,'CBliquidity_',outputlabel,'.pdf'));


end