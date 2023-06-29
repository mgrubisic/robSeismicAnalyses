function [ NBS, firstPPx, firstPPy, DRIFTmaxPP, numberSolutions, PP ] = CSMnbs( ...
    ADRSspectrum, pushover, massa, deltaY, plotter, varargin )
%CSM Performs the capacity spectrum method according to ATC
%   The performance of New Building Standerd is calculated. If it is
%   greater than 100%, the CSM is carried out
%
%
%   Lo spettro deve essere fornito in [s - g - metri]
%   La massa deve essere definita in maniera coerente con la forza nella
%   pushover. e.g. Pushover in kN, massa in kN/g
%
%   Gli spettri (acc e spost) devono essere definiti fino a 10 secondi, in
%   modo tale che non ci sia il rischio di non intersecare lo spettro ADRS
%   nel calcolo di NBS (se lo spostamento ultimo � molto alto e quindi la
%   rigidezza secante � molto bassa)

%% Example

% CASE 1: NBS>100%

% ADRSspectrum= [0 0.356939000000000 0;0 0.474636000000000 0.000188707833496794;0 0.476990000000000 0.000197305354375608;0 0.479638000000000 0.000207250202706988;0 0.482287000000000 0.000217487361514447;0 0.484935000000000 0.000228019146043329;0 0.487583000000000 0.000238849186280760;0 0.490820000000000 0.000252495891044776;0 0.493762000000000 0.000265297306034601;0 0.496999000000000 0.000279819960536491;0 0.500530000000000 0.000296195889566287;0 0.504061000000000 0.000313135550388310;0 0.507886000000000 0.000332131634261809;0 0.511711000000000 0.000351807838722964;0 0.516125000000000 0.000375369253572282;0 0.520538000000000 0.000399863067162004;0 0.524952000000000 0.000425305581112906;0 0.529954000000000 0.000455304662100784;0 0.535250000000000 0.000488439968950824;0 0.540841000000000 0.000524975350849041;0 0.546726000000000 0.000565195151404757;0 0.553199000000000 0.000611564580633147;0 0.556436000000000 0.000635599985137318;0 0.559967000000000 0.000662475598276850;0 0.563498000000000 0.000690042553940875;0 0.567029000000000 0.000718308433028745;0 0.570854000000000 0.000749726981842801;0 0.574973000000000 0.000784500343125123;0 0.579093000000000 0.000820259915965028;0 0.583212000000000 0.000857014957194100;0 0.587626000000000 0.000897516412943632;0 0.592333000000000 0.000942009263002863;0 0.597041000000000 0.000987856232472527;0 0.602044000000000 0.00103807206952885;0 0.607340000000000 0.00109294995354858;0 0.612930000000000 0.00115281244030097;0 0.618521000000000 0.00121469499481279;0 0.624406000000000 0.00128204746626547;0 0.630585000000000 0.00135524808896455;0 0.637058000000000 0.00143470344543515;0 0.644120000000000 0.00152466942151269;0 0.651182000000000 0.00161812347293649;0 0.657067000000000 0.00169871010507974;0 0.662952000000000 0.00178179622463277;0 0.668837000000000 0.00186741692835183;0 0.677664000000000 0.00200067562723999;0 0.683549000000000 0.00209278628501490;0 0.692376000000000 0.00223594429063482;0 0.698261000000000 0.00233476425222237;0 0.707088000000000 0.00248815058299698;0 0.715915000000000 0.00264783180177572;0 0.724743000000000 0.00281393023606115;0 0.733570000000000 0.00298655675398161;0 0.745340000000000 0.00322709360051803;0 0.754167000000000 0.00341542169501413;0 0.765937000000000 0.00367732420679258;0 0.777706000000000 0.00395181672691765;0 0.789476000000000 0.00423918990394306;0 0.804188000000000 0.00461693791863132;0 0.815958000000000 0.00493430819830476;0 0.830670000000000 0.00535044062235630;0 0.848325000000000 0.00587901378799521;0 0.863037000000000 0.00634447338124399;0 0.873332000000000 0.00695335985993069;0 0.873332000000000 0.00742731940969782;0 0.873332000000000 0.00800002053233310;0 0.873332000000000 0.00868057783456283;0 0.873332000000000 0.00903127317907916;0 0.873332000000000 0.00938891298586315;0 0.873332000000000 0.00984572839440702;0 0.873332000000000 0.0102189932412932;0 0.873332000000000 0.0106953399499649;0 0.873332000000000 0.0111825373809297;0 0.873332000000000 0.0117814972515145;0 0.873332000000000 0.0122925662715244;0 0.873332000000000 0.0129201720489633;0 0.873332000000000 0.0135634028665044;0 0.873332000000000 0.0142222587241477;0 0.873332000000000 0.0150106722059719;0 0.873332000000000 0.0158203531034908;0 0.873332000000000 0.0167717444341588;0 0.873332000000000 0.0177509136138975;0 0.873332000000000 0.0187578606427068;0 0.873332000000000 0.0199238792603345;0 0.873332000000000 0.0211250542181921;0 0.873332000000000 0.0226409001225526;0 0.873332000000000 0.0240645148874209;0 0.873332000000000 0.0258301444189710;0 0.873332000000000 0.0276582741109299;0 0.873332000000000 0.0297092776387913;0 0.873332000000000 0.0321669662382019;0 0.873332000000000 0.0347223113382513;0 0.873332000000000 0.0377364249768574;0 0.873332000000000 0.0410645585186288;0 0.873332000000000 0.0449274156550092;0 0.873332000000000 0.0491702650860977;0 0.873332000000000 0.0542536114660177;0 0.873332000000000 0.0600426888238876;0 0.826989000000000 0.0635270351154456;0 0.781983000000000 0.0671832848857745;0 0.735690000000000 0.0714108427183093;0 0.689364000000000 0.0762095747757297;0 0.643986000000000 0.0815797030755833;0 0.597927000000000 0.0878638269291779;0 0.551988000000000 0.0951763202548472;0 0.505837000000000 0.103859835458552;0 0.459806000000000 0.114257286226744;0 0.437910000000000 0.119970020080725;0 0.414240000000000 0.126825698041336;0 0.389666000000000 0.134823562561345;0 0.367845000000000 0.142821685436619;0 0.345719000000000 0.151962279914402;0 0.321543000000000 0.163388093421329;0 0.298575000000000 0.175956029451730;0 0.275333000000000 0.190809713646313;0 0.252641000000000 0.207948541329019;0 0.229903000000000 0.228514572453488;0 0.207120000000000 0.253651396082672;0 0.183922000000000 0.285642594341353;0 0.149768000000000 0.304411017817532;0 0.110475000000000 0.304411985612325;0 0.0765650000000000 0.304410438139586;0 0.0122500000000000 0.304400498531471];
% pushover    = [0, 0; 12.54/1000, 132.5; 90/1000, 132.5]; % capacity curve [m, kN]
% massa       = 0.8 * 3278.5 / 9.81; % effective mass [Ton]
% deltaY      = pushover(2,1);
% ploter      = 'plot';
% 
% [NBS, dispDEM, accDEM] = CSMnbs( ADRSspectrum, pushover, massa, deltaY, 'plot' );

%% Optional input

% Maximum number of optional inputs
numvarargs = length(varargin);
if numvarargs > 9
    error('myfuns:somefun2Alt:TooManyInputs', ...
        'requires at most 9 optional inputs');
end

% set defaults for optional inputs
optargs = {0.565, 0.5, 0.001, 0, 'y', 0, 0, 0, 'y'};

% now put these defaults into the valuesToUse cell array,
% and overwrite with the ones specified in varargin.
optargs(1:numvarargs) = varargin;
% or ...
% [optargs{1:numvarargs}] = varargin{:};

% Place optional args in memorable variable names
[ Cevd, alpha, DeltaStep, ULSdisp, UseLastPoint, HEIGHT, Heff, DispShape, runCSM ] = optargs{:};

%% Initial stuff

% Remove redundant point from pushover
[~,id] = unique(pushover(:,1));
pushoverTemp(:,1) = pushover(id,1); 
pushoverTemp(:,2) = pushover(id,2);
pushover = pushoverTemp; 
clear pushoverTemp

% the code removes the last point of the pushover by default. If you want
% to use it, just add a fake point to the pushover
if ~strcmp(UseLastPoint,'n')
    pushover(end+1,:) = pushover(end,:);
end

%% Calculate NBS

%Cspectrum = pushover;
%Cspectrum(:,2) = pushover(:,2) / massa / 9.81; % kN / 

% interpolate pushover every 0.005m to reduce computational time (for the intersections)
% calculate the capacity spectrum
Cspectrum(:,1) = [ 0 : 0.0005 : pushover(end-2,1) , pushover(end-1,1) ]; % last point of the pushover is not considered because it is often out of scale (ruaumoko problem)
Cspectrum(2:end,2) = [ interp1(pushover(1:end-2,1), pushover(1:end-2,2), Cspectrum(2:end-1,1)) ; pushover(end-1,2)] / (massa * 9.81); % kN / g. NOTE: the first point is not considered. It is automatically zero though

if ULSdisp == 0
    ULSdisp = Cspectrum(end,1);
end
ULSforce = interp1(Cspectrum(:,1), Cspectrum(:,2), ULSdisp);

% guess the displacement demand (ULS)
Ddemand = ULSdisp;

% ductility demand
MUdemand = Ddemand / deltaY;

% equivalent viscous damping
EVD = (0.05 + max(0, Cevd*(MUdemand - 1)/(pi * MUdemand)) ) * 100; % [%]

% reduction factor
etha = ( 7 / (2+EVD) )^alpha; % alternative ( 10 / (5+EVD) )^0.5;

% reduce spectrum
INspectrum = etha * ADRSspectrum;

% displacement demand for secant-to-ultimate 
[NBSdispDEM, NBSaccDEM] = intersections([0 100*ULSdisp], [0 100*ULSforce], INspectrum(:,3)+eps, INspectrum(:,2), 0);

% two or more points with the same displacement (too-high res of the spectrum)
if numel(uniquetol(NBSdispDEM))==1 && numel(uniquetol(NBSaccDEM))==1
    NBSdispDEM = NBSdispDEM(1);
    NBSaccDEM = NBSaccDEM(1);
end

% percentage of NBS : ratio of the distance of the ultimate point from
% origin to its projection on the damped ADRS (following the line
% corresponding the secant period)
try
    NBS = ( ( ULSdisp^2 + ULSforce^2 )^0.5 ) / ( ( NBSdispDEM^2 + NBSaccDEM^2 ) ^0.5 ); % it's PITAGORA divided by PITAGORA
catch
    NBS = NaN; warning('check code for NBS')
end

%% check if CSM is needed 

if strcmp(runCSM, 'y')
    
% If the structure is not able to widstand the demand compatible with the
% last point of the capacity spectrum (max damping), no further action is required. 
%
% Oterwise, the Capacity Spectrum Method is needed to calculate the
% displacement demand related to the 100% spectrum

CSMdisp = Cspectrum(end,1);

% guess the displacement demand (Last point)
Ddemand = Cspectrum(end,1);

% ductility demand
MUdemand = Ddemand / deltaY;

% equivalent viscous damping
EVD = (0.05 + Cevd*(MUdemand - 1)/(pi * MUdemand)) * 100; % [%]

% reduction factor
etha = ( 7 / (2+EVD) )^alpha;

% reduce spectrum
INspectrum = etha * ADRSspectrum;

% displacement demand for secant-to-ultimate 
[NdispCSM] = intersections(Cspectrum(:,1), Cspectrum(:,2) , INspectrum(:,3), INspectrum(:,2), 0);

%% Run CSM or Inverse CSM

if ~isempty(NdispCSM) % CSM
    
    % guess displacement demand
    PPxOLD = ( 0 : DeltaStep : CSMdisp )';
    
    % ductility demand based on each trial performance point
    MUdemand = max(1, PPxOLD / deltaY);
    
    % equivalent viscous damping
    EVD = (0.05 + Cevd*(MUdemand - 1)./(pi * MUdemand)) * 100; % [%]
    
    % reduction factor
    etha = (7 ./ (2+EVD) ).^alpha;
    
    % the polyxpoly does not work vectorially
    PPSx = zeros(size(PPxOLD));
    PPSy = zeros(size(PPxOLD));
    for trial = 1 : numel(PPxOLD)
        
        % reduce spectrum
        INspectrum = etha(trial) * ADRSspectrum;
        
        % intersect demand and capacity
        [PPSxCURRENT, PPSyCURRENT] = intersections(INspectrum(:,3), INspectrum(:,2), Cspectrum(:,1), Cspectrum(:,2), 0);
        
        % choose the intersection which is closest to the initial guess
        if ~isempty(PPSxCURRENT)
            [~,pos] = min(abs(PPSxCURRENT-PPxOLD(trial)));
            PPSx(trial) = PPSxCURRENT(pos); PPSy(trial) = PPSyCURRENT(pos);
        else
            PPSx(trial) = NaN; PPSy(trial) = NaN;
        end
%         figure
%         hold on
%         plot(ADRSspectrum(:,3), ADRSspectrum(:,2), '--k')
%         plot(INspectrum(:,3), INspectrum(:,2), 'k')
%         plot(Cspectrum(:,1), Cspectrum(:,2), 'k')
        
    end
    
    % check convergence
    residX          = abs(PPxOLD-PPSx);
    isSolution      = islocalmin(residX) & abs(residX)<=10*DeltaStep;
    numberSolutions = sum( isSolution );

    PP(:,1)     = PPSx(isSolution);
    PP(:,2)     = interp1( Cspectrum(:,1), Cspectrum(:,2), PP(:,1) );
    
    firstPPx    = PP(1,1);
    firstPPy    = PP(1,2);
    
%     % check convergence
%     residX = abs(PPxOLD-PPSx);
%     [ ~, GoodOne ] = min(residX);
%     multipleIntersection = sum( islocalmin(residX) & abs(residX)<=10*DeltaStep );
%     
%     firstPPx = PPSx(GoodOne);
%     firstPPy = interp1( Cspectrum(:,1), Cspectrum(:,2), firstPPx );
%     
%     % reduce spectrum
%     INspectrum = etha(GoodOne) * ADRSspectrum;
    
else
    
    PP = [];
    firstPPx = inf;
    firstPPy = inf;
    numberSolutions = 0;
    
end

if Heff~=0 && ~isinf(firstPPx)
    
    if DispShape == 0
        if numel(HEIGHT) >= 3 % greater than 2 storeys
            DispShape = 4/3 * (HEIGHT./HEIGHT(end)).*(1-HEIGHT ./ (4*HEIGHT(end)));
        else
            DispShape = HEIGHT./HEIGHT(end);
        end
    end
    
    % calculate displacement shape at the effective height
    dEFF = interp1( HEIGHT, DispShape, Heff );
    
    % calculate top displacement
    Dtop = firstPPx / dEFF;
    
    % calculate maximum drift, which can be at any level (note dSHAPE(end)==1 )
    DriftShape = (DispShape(2:end)-DispShape(1:end-1)) ./ ...
        ( HEIGHT(2:end)-HEIGHT(1:end-1) )';
    DriftShapeMAX = max(DriftShape);
    
    DRIFTmaxPP = DriftShapeMAX * Dtop * 100;
    
else
    
    DRIFTmaxPP = inf;
    
end

%% Plot

if strcmpi(plotter, 'plot')
    figure('Position', [274   350   560   420])
    hold on
    plot(ADRSspectrum(:,3), ADRSspectrum(:,2), '--k', 'LineWidth', 2)
    plot(Cspectrum(:,1), Cspectrum(:,2), 'k', 'LineWidth', 2)
    
    for k = 1 : size(PP,1)
        INspectrum = etha(PPSx==PP(k,1)) * ADRSspectrum;
        plot(INspectrum(:,3), INspectrum(:,2), 'k', 'LineWidth', 2)
        plot(PP(k,1), PP(k,2), 'ok', 'MarkerFaceColor', 'k', 'MarkerSize', 10)
    end
    
    title('CSM')
    xlabel('Displacement [m]', 'FontSize', 14)
    ylabel('Acceleration [g]', 'FontSize', 14)
    set(gca, 'FontSize', 16)

    if ~isempty(NdispCSM) % CSM
        GoodOne = find( PPSx==PP(1,1) );
        
        figure('Position', [835   350   560   420])
        hold on
        plot(1 : numel(PPxOLD), residX, 'k', 'LineWidth', 2)
        plot(GoodOne, residX(GoodOne), 'ok', 'MarkerSize', 20)
        text(GoodOne*1.1, 0.1*(max(residX)), sprintf('residual = %2.5f m', residX(GoodOne)))
        title('Residual CSM')
        xlabel('step'); ylabel('Residual [m]')
        set(gca, 'FontSize', 16)
    end
end

else
    firstPPx = NaN;
    firstPPy = NaN;
    DRIFTmaxPP = NaN;
    numberSolutions = NaN;
    PP = NaN;
end

end

%% Subfunctions

