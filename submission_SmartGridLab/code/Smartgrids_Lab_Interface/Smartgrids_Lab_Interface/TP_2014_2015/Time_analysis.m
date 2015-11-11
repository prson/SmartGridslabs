function varargout = Time_analysis(varargin)
% TIME_ANALYSIS MATLAB code for Time_analysis.fig
%      TIME_ANALYSIS, by itself, creates a new TIME_ANALYSIS or raises the existing
%      singleton*.
%
%      H = TIME_ANALYSIS returns the handle to a new TIME_ANALYSIS or the handle to
%      the existing singleton*.
%
%      TIME_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIME_ANALYSIS.M with the given input arguments.
%
%      TIME_ANALYSIS('Property','Value',...) creates a new TIME_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Time_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Time_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Time_analysis

% Last Modified by GUIDE v2.5 23-Apr-2015 14:47:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Time_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @Time_analysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Time_analysis is made visible.
function Time_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Time_analysis (see VARARGIN)

% Choose default command line output for Time_analysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Time_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axis(handles.axes1,'off')
axis(handles.axes2,'off')
axis(handles.axes3,'off')
axis(handles.axes4,'off')


% --- Outputs from this function are returned to the command line.
function varargout = Time_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Loadflow_with_OLTC.
function Loadflow_with_OLTC_Callback(hObject, eventdata, handles)
% hObject    handle to Loadflow_with_OLTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Exécution du loadflow
cla(handles.axes4)


if isfield(handles,'NO')==0,
    NO = [];
    disp('Attention, le réseau n''est pas radial')
elseif length(handles.NO)~= 5
    NO = [];
    disp('Attention, le réseau n''est pas radial')
else     
    NO = handles.NO;
    Line = handles.Line;
    Bus = handles.Bus;
    Imax = handles.Imax;
    Param = handles.Parametres;
    Noeuds_source = [2;3;11];    
    Sbase = Param(2); % MVA
    Tableau_conso_indus = get(handles.Consumption_industrial, 'Data')/Sbase;
    Tableau_conso_res = get(handles.Consumption_residential, 'Data')/Sbase;
    Connection_node = get(handles.Node_choice, 'Data');
    Tableau_prod = get(handles.Production, 'Data')/Sbase;
    %% LF
    contents_prod = get(handles.Choix_prod,'Value');
    switch contents_prod
        case 1
            Profil_prod = handles.Profil_prod_eol;
        case 2
            Profil_prod = handles.Profil_prod_PV;
        otherwise
    end

    h = waitbar(0,'Please wait...'); 
    

    for i_tps = 1:length(handles.Profil_conso),
        waitbar(i_tps/length(handles.Profil_conso))
        Tableau_conso_t = [Tableau_conso_indus;Tableau_conso_res*handles.Profil_conso(i_tps,2)/100];
        Tableau_prod_t = Tableau_prod*Profil_prod(i_tps,2)/100;
        [Tension(:,i_tps),Courant(:,i_tps), Pertes(i_tps,1),Consigne_regleur(:,i_tps)] = Execution_loadflow_OLTC(Bus, Line, NO, Imax, Param, Noeuds_source, Tableau_conso_t,Connection_node,Tableau_prod_t);
    end
    save('Regleur.mat','Consigne_regleur')

    close(h)
    
    
    %% Sauvegarde des résultats
    handles.Voltage = Tension;
    handles.Current = Courant;
    handles.Losses = Pertes;
    
    %% Visualisation

    Max_current = max(Courant);
    Min_voltage = min(Tension);
    Max_voltage = max(Tension);

    handles.MV = Max_voltage;
    handles.mV = Min_voltage;
    handles.MC = Max_current;

    Over_voltage = find(Max_voltage' > 1.05);
    Under_voltage = find(Min_voltage' < 0.95);
    Over_current = find(Max_current' > 100);
    
    Indice = [Over_voltage;Under_voltage;Over_current];
    Indice = unique(Indice);
    save('Resultats.mat','Tension','Courant','Max_voltage','Min_voltage','Max_current','Indice')

    
     handles.contraintes = Indice;
    
    if isempty (Over_voltage),
        n_overV = 0;
    else
        n_overV = length(Over_voltage);
    end
    
    if isempty (Under_voltage),
        n_underV = 0;
    else
        n_underV = length(Under_voltage);
    end
    if isempty (Over_current),
        n_overC = 0;
    else
        n_overC = length(Over_current);
    end
    
    handles.nbres_OV = n_overV;
    handles.nbres_UV = n_underV;
    handles.nbres_OC = n_overC;

    axes(handles.axes4)
    axis(handles.axes4,'on')

    contents_vis = get(handles.Visu,'Value');
    switch contents_vis
        case 1    
        axis([0 length(Indice)+1 min(Min_voltage)-0.03 max(Max_voltage)+0.03])
        hold on
        plot(Max_voltage(Indice),'.k')
        hold on
        plot(Min_voltage(Indice),'.k')
        hold on
        plot(0.95*ones(length(Indice),1),'LineStyle','--','color','red')
        hold on
        plot(1.05*ones(length(Indice),1),'LineStyle','--','color','red')
        title ([num2str(n_overV) ' overvoltages ',num2str(n_underV) ' undervoltages during the year'])
        case 2 
            hold on
            plot(Max_current(Indice)/100,'.b')
            hold on
            plot(1*ones(length(Indice),1),'LineStyle','--','color','blue')
            title ([num2str(n_overC) ' overcurrents during the year'])
        otherwise
    end
end

guidata(hObject,handles)


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Consumption_industrial, 'Data', zeros(3,2));
set(handles.Consumption_residential, 'Data', zeros(6,2));
set(handles.Production, 'Data', zeros(5,2));
set(handles.Node_choice, 'Data', zeros(1,2));
set(handles.Config, 'Data', zeros(1,5));
set(handles.Config, 'Data', zeros(1,5));

cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
cla(handles.axes4)



% --- Executes on button press in Load_Data.
function Load_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fileName = uigetfile('*.xls');
fileName = handles.fileName;
handles.Line = xlsread(fileName,'Line');
handles.Bus = xlsread(fileName,'Bus');
handles.Imax = xlsread(fileName,'I_max');
handles.Parametres = xlsread(fileName,'Parametres');
handles.Profil_conso = xlsread(fileName,'Profil_2014_Conso');
handles.Profil_prod_eol = xlsread(fileName,'Profil_2014_vent');
handles.Profil_prod_PV = xlsread(fileName,'Profil_2014_PV');

handles.Coordonnees = xlsread('Coordonnees.xls');

axes(handles.axes1)

hold on
handles.coord_int = [0;1;2;0;3;4;5;6;7;8;9;10;11;12];
for i=1:size(handles.Line,1)
    if handles.Line(i,1) ~=1 && handles.Line(i,2) ~=1,
        if ~isempty(intersect(handles.Config,i)),
            % Alors la ligne est ouverte
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'--','color','red')
        else
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'color','black')
        end
    end
end
plot(handles.Coordonnees([1;2;9],2),handles.Coordonnees([1;2;10],3),'sq','color','red','MarkerFaceColor','red','Markersize',20)
plot(handles.Coordonnees(setdiff([1:1:12],[1;2;9]),2),handles.Coordonnees(setdiff([1:1:12],[1;2;9]),3),'o','color','black','MarkerFaceColor','black','Markersize',10)
taille1 = 0.5;
taille2 = 0.5;
text(handles.Coordonnees(:,2)+taille1,handles.Coordonnees(:,3)+taille1,num2str(handles.Coordonnees(:,1)))
axis equal



axes(handles.axes2)
plot(handles.Profil_conso(:,1),handles.Profil_conso(:,2),'.')
plot(handles.Profil_conso(:,1),handles.Profil_conso(:,2))
axis([0 handles.Profil_conso(end,1)+0.5 0 max(handles.Profil_conso(:,2))+1])
title('Profil de consommation de la synchrone ERDF en 2014 en %')
xlabel('Temps (h)')
ylabel('Puissance active (en % de P_m_a_x)')

contents_prod = get(handles.Choix_prod,'Value');
axes(handles.axes3)

switch contents_prod
    case 1 
        plot(handles.Profil_prod_eol(:,1),handles.Profil_prod_eol(:,2),'.')
        plot(handles.Profil_prod_eol(:,1),handles.Profil_prod_eol(:,2))
        axis([0 handles.Profil_prod_eol(end,1)+0.5 0 max(handles.Profil_prod_eol(:,2))+1])
        title('Profil de production eolienne (RTE) en 2014 en %')
        xlabel('Temps (h)')
        ylabel('Puissance active (en % de P_m_a_x)')
    case 2
        plot(handles.Profil_prod_PV(:,1),handles.Profil_prod_PV(:,2),'.')
        plot(handles.Profil_prod_PV(:,1),handles.Profil_prod_PV(:,2))
        axis([0 handles.Profil_prod_PV(end,1)+0.5 0 max(handles.Profil_prod_PV(:,2))+1])
        title('Profil de production PV en 2014 en %')
        xlabel('Temps (h)')
        ylabel('Puissance active (en % de P_m_a_x)')
    otherwise
end


guidata(hObject,handles)

% --- Executes on button press in Apply.
function Apply_Callback(hObject, eventdata, handles)
% hObject    handle to Apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.NO = nonzeros(get(handles.Config, 'Data'));
axes(handles.axes1)

for i=1:size(handles.Line,1)
    if handles.Line(i,1) ~=1 && handles.Line(i,2) ~=1,
        if ~isempty(intersect(get(handles.Config, 'Data'),i)),
            % Alors la ligne est ouverte
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'-','color','white')
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'--','color','red')
            X1 = handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2);
            X2 = handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2);
            Y1 = handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3);
            Y2 = handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3);
            text((X1+X2)/2,(Y1+Y2)/2,['L ',num2str(i)])
        else
            % Alors la ligne est fermée
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'-','color','white')
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'-','color','black')
        end
    end
end

axis equal
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function Config_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(1,5));
set(hObject, 'RowName', {'Configuration'}, 'ColumnName', {'SW1', 'SW2', 'SW3', 'SW4', 'SW5'});


% --- Executes during object creation, after setting all properties.
function Consumption_industrial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Consumption_industrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(3,2));
set(hObject, 'RowName', {'Load 1 (N9)','Load 2 (5)','Load 3(N11)' }, 'ColumnName', {'P_L (MW)','Q_L (MVAr)'});

% --- Executes during object creation, after setting all properties.
function Production_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Production (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(5,2));
set(hObject, 'RowName', {'Gen 1 (N14)','Gen 2 (N7)','Gen 3 (N10 ou 12)','Gen 4 (N9 ou 13)','Gen 5 (N5)'}, 'ColumnName', {'P_DG (MW)','Q_DG (MVAr)'});


% --- Executes during object creation, after setting all properties.
function Node_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Node_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(1,2));
set(hObject, 'RowName', {'Connection node'}, 'ColumnName', {'Gen 3','Gen 4'});


% --- Executes during object creation, after setting all properties.
function Consumption_residential_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Consumption_residential (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(6,2));
set(hObject, 'RowName', {'Load 5 (N13)','Load 6 (N6)','Load 7 (N12)','Load 8 (N2)','Load 9 (7)','Load 10 (N8)' }, 'ColumnName', {'P_L (MW)','Q_L (MVAr)'});


% --- Executes on selection change in Visu.
function Visu_Callback(hObject, eventdata, handles)
% hObject    handle to Visu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Visu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Visu
contents_vis = get(handles.Visu,'Value');

axes(handles.axes4)
axis(handles.axes4,'on')

switch contents_vis
    case 1   
        cla(handles.axes4)
        axis([0 length(handles.contraintes)+1 min(handles.mV)-0.03 max(handles.MV)+0.03])
        hold on
        plot(handles.MV(handles.contraintes),'.k')
        hold on
        plot(handles.mV(handles.contraintes),'.k')
        hold on
        plot(0.95*ones(length(handles.contraintes),1),'LineStyle','--','color','red')
        hold on
        plot(1.05*ones(length(handles.contraintes),1),'LineStyle','--','color','red')
        title ([num2str(handles.nbres_OV) ' overvoltages ',num2str(handles.nbres_UV) ' undervoltages during the year'])
    case 2 
        cla(handles.axes4)
        axis([0 length(handles.contraintes)+1 0 1])
        hold on
        plot(handles.MC(handles.contraintes)/100,'.b')
        hold on
        plot(1*ones(length(handles.contraintes),1),'LineStyle','--','color','blue')
        title ([num2str(handles.nbres_OC) ' overcurrents during the year'])
    otherwise
end


% --- Executes during object creation, after setting all properties.
function Visu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Visu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Choix_prod.
function Choix_prod_Callback(hObject, eventdata, handles)
% hObject    handle to Choix_prod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Choix_prod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Choix_prod
contents_prod = get(handles.Choix_prod,'Value');


switch contents_prod
    case 1
        axes(handles.axes3)
        plot(handles.Profil_prod_eol(:,1),handles.Profil_prod_eol(:,2),'.')
        plot(handles.Profil_prod_eol(:,1),handles.Profil_prod_eol(:,2))
        axis([0 handles.Profil_prod_eol(end,1)+0.5 0 max(handles.Profil_prod_eol(:,2))+1])
        title('Profil de production eolienne (RTE) en 2014 en %')
        xlabel('Temps (h)')
        ylabel('Puissance active (en % de P_m_a_x)')
    case 2 
        axes(handles.axes3)
        plot(handles.Profil_prod_PV(:,1),handles.Profil_prod_PV(:,2),'.')
        plot(handles.Profil_prod_PV(:,1),handles.Profil_prod_PV(:,2))
        axis([0 handles.Profil_prod_PV(end,1)+0.5 0 max(handles.Profil_prod_PV(:,2))+1])
        title('Profil de production PV en 2014 en %')
        xlabel('Temps (h)')
        ylabel('Puissance active (en % de P_m_a_x)')
    otherwise
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function Choix_prod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Choix_prod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reconfig_OLTC.
function Reconfig_OLTC_Callback(hObject, eventdata, handles)
% hObject    handle to Reconfig_OLTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes4)


if isfield(handles,'NO')==0,
    NO = [];
    disp('Attention, le réseau n''est pas radial')
elseif length(handles.NO)~= 5
    NO = [];
    disp('Attention, le réseau n''est pas radial')
else     
    NO = handles.NO;
    Line = handles.Line;
    Bus = handles.Bus;
    Imax = handles.Imax;
    Param = handles.Parametres;
    Noeuds_source = [2;3;11];    
    Sbase = Param(2); % MVA
    Tableau_conso_indus = get(handles.Consumption_industrial, 'Data')/Sbase;
    Tableau_conso_res = get(handles.Consumption_residential, 'Data')/Sbase;
    Connection_node = get(handles.Node_choice, 'Data');
    Tableau_prod = get(handles.Production, 'Data')/Sbase;
    %% LF
    contents_prod = get(handles.Choix_prod,'Value');
    switch contents_prod
        case 1
            Profil_prod = handles.Profil_prod_eol;
        case 2
            Profil_prod = handles.Profil_prod_PV;
        otherwise
    end

    h = waitbar(0,'Please wait...'); 
    

    for i_tps = 1:length(handles.contraintes),
        waitbar(i_tps/length(handles.contraintes))
        Tableau_conso_t = [Tableau_conso_indus;Tableau_conso_res*handles.Profil_conso(handles.contraintes(i_tps),2)/100];
        Tableau_prod_t = Tableau_prod*Profil_prod(handles.contraintes(i_tps),2)/100;
        [Config_trouvee(i_tps,:)] = Execution_SOB(Line, Bus,Param,Imax,Tableau_conso_t,Tableau_prod_t,Connection_node);

        [Tension(:,i_tps),Courant(:,i_tps), Pertes(i_tps,1),Consigne_regleur(:,i_tps)] = Execution_loadflow_OLTC(Bus, Line, Config_trouvee(i_tps,:), Imax, Param, Noeuds_source,Tableau_conso_t,Connection_node,Tableau_prod_t);
    end

    close(h)
    for i=1:size(Config_trouvee,1)
        Config_trouvee(i,:) = sort(Config_trouvee(i,:));
    end
    save('Configuration_opt.mat','Config_trouvee')

    
    %% Sauvegarde des résultats
    handles.Voltage = Tension;
    handles.Current = Courant;
    handles.Losses = Pertes;
    
    %% Visualisation

    Max_current = max(Courant);
    Min_voltage = min(Tension);
    Max_voltage = max(Tension);
    save('Resultats_reconfig.mat','Tension','Courant','Max_voltage','Min_voltage','Max_current')

    handles.MV = Max_voltage;
    handles.mV = Min_voltage;
    handles.MC = Max_current;

    Over_voltage = find(Max_voltage' > 1.05);
    Under_voltage = find(Min_voltage' < 0.95);
    Over_current = find(Max_current' > 100);
    
    Indice = [Over_voltage;Under_voltage;Over_current];
    Indice = unique(Indice);
    
     handles.contraintes = Indice;
    
    if isempty (Over_voltage),
        n_overV = 0;
    else
        n_overV = length(Over_voltage);
    end
    
    if isempty (Under_voltage),
        n_underV = 0;
    else
        n_underV = length(Under_voltage);
    end
    if isempty (Over_current),
        n_overC = 0;
    else
        n_overC = length(Over_current);
    end
    
    handles.nbres_OV = n_overV;
    handles.nbres_UV = n_underV;
    handles.nbres_OC = n_overC;

    axes(handles.axes4)
    axis(handles.axes4,'on')

    contents_vis = get(handles.Visu,'Value');
    switch contents_vis
        case 1    
        axis([0 length(Indice)+1 min(Min_voltage)-0.03 max(Max_voltage)+0.03])
        hold on
        plot(Max_voltage(Indice),'.k')
        hold on
        plot(Min_voltage(Indice),'.k')
        hold on
        plot(0.95*ones(length(Indice),1),'LineStyle','--','color','red')
        hold on
        plot(1.05*ones(length(Indice),1),'LineStyle','--','color','red')
        title ([num2str(n_overV) ' overvoltages ',num2str(n_underV) ' undervoltages during the year'])
        case 2 
            hold on
            plot(Max_current(Indice)/100,'.b')
            hold on
            plot(1*ones(length(Indice),1),'LineStyle','--','color','blue')
            title ([num2str(n_overC) ' overcurrents during the year'])
        otherwise
    end
end

guidata(hObject,handles)

% --- Executes on button press in VVC_OLTC.
function VVC_OLTC_Callback(hObject, eventdata, handles)
% hObject    handle to VVC_OLTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes4)


if isfield(handles,'NO')==0,
    NO = [];
    disp('Attention, le réseau n''est pas radial')
elseif length(handles.NO)~= 5
    NO = [];
    disp('Attention, le réseau n''est pas radial')
else     
    NO = handles.NO;
    Line = handles.Line;
    Bus = handles.Bus;
    Imax = handles.Imax;
    Param = handles.Parametres;
    Noeuds_source = [2;3;11];    
    Sbase = Param(2); % MVA
    Tableau_conso_indus = get(handles.Consumption_industrial, 'Data')/Sbase;
    Tableau_conso_res = get(handles.Consumption_residential, 'Data')/Sbase;
    Connection_node = get(handles.Node_choice, 'Data');
    Tableau_prod = get(handles.Production, 'Data')/Sbase;
    %% LF
    contents_prod = get(handles.Choix_prod,'Value');
    switch contents_prod
        case 1
            Profil_prod = handles.Profil_prod_eol;
        case 2
            Profil_prod = handles.Profil_prod_PV;
        otherwise
    end

    h = waitbar(0,'Please wait...'); 
    
    load Regleur.mat
    for i_tps = 1:length(handles.contraintes),
        waitbar(i_tps/length(handles.contraintes))
        Tableau_conso_t = [Tableau_conso_indus;Tableau_conso_res*handles.Profil_conso(handles.contraintes(i_tps),2)/100];
        Tableau_prod_t = Tableau_prod*Profil_prod(handles.contraintes(i_tps),2)/100;
        [Drapeau(i_tps,1),Tension(:,i_tps),Pertes(i_tps,1),x_solution(:,i_tps),Courant(:,i_tps)] = VVC_algorithm(Bus, Line, NO, Imax, Param, Noeuds_source,Tableau_conso_t,Connection_node,Tableau_prod_t,nonzeros(Connection_node)');
%         Tableau_prod_t1 = Tableau_prod_t;   
%         if (min(Tension(:,i_tps)) < 0.95) || (max(Tension(:,i_tps))>1.05) || (min(Tension(:,i_tps)) < 0.95 && max(Tension(:,i_tps))>1.05)
%             Tableau_prod_t1(find(Tableau_prod_t(:,1)~= 0),2) = x_solution(:,i_tps);
%             [Tension(:,i_tps),Courant(:,i_tps), Pertes(i_tps,1),Consigne_regleur(:,i_tps)] = Execution_loadflow_OLTC(Bus, Line, NO, Imax, Param, Noeuds_source,Tableau_conso_t,Connection_node,Tableau_prod_t1);
%         end
        save('VVC.mat','Drapeau','x_solution','Tension','Consigne_regleur')
    end

    close(h)
    

    
    %% Sauvegarde des résultats
    handles.Voltage = Tension;
    handles.Current = Courant;
    handles.Losses = Pertes;
    
    %% Visualisation

    Max_current = max(Courant);
    Min_voltage = min(Tension);
    Max_voltage = max(Tension);

    handles.MV = Max_voltage;
    handles.mV = Min_voltage;
    handles.MC = Max_current;

    Over_voltage = find(Max_voltage' > 1.05);
    Under_voltage = find(Min_voltage' < 0.95);
    Over_current = find(Max_current' > 100);
    
    Indice = [Over_voltage;Under_voltage;Over_current];
    Indice = unique(Indice);
    
     handles.contraintes = Indice;
    
    if isempty (Over_voltage),
        n_overV = 0;
    else
        n_overV = length(Over_voltage);
    end
    
    if isempty (Under_voltage),
        n_underV = 0;
    else
        n_underV = length(Under_voltage);
    end
    if isempty (Over_current),
        n_overC = 0;
    else
        n_overC = length(Over_current);
    end
    
    handles.nbres_OV = n_overV;
    handles.nbres_UV = n_underV;
    handles.nbres_OC = n_overC;

    axes(handles.axes4)
    axis(handles.axes4,'on')

    contents_vis = get(handles.Visu,'Value');
    switch contents_vis
        case 1    
        axis([0 length(Indice)+1 min(Min_voltage)-0.03 max(Max_voltage)+0.03])
        hold on
        plot(Max_voltage(Indice),'.k')
        hold on
        plot(Min_voltage(Indice),'.k')
        hold on
        plot(0.95*ones(length(Indice),1),'LineStyle','--','color','red')
        hold on
        plot(1.05*ones(length(Indice),1),'LineStyle','--','color','red')
        title ([num2str(n_overV) ' overvoltages ',num2str(n_underV) ' undervoltages during the year'])
        case 2 
            hold on
            plot(Max_current(Indice)/100,'.b')
            hold on
            plot(1*ones(length(Indice),1),'LineStyle','--','color','blue')
            title ([num2str(n_overC) ' overcurrents during the year'])
        otherwise
    end
end

guidata(hObject,handles)
