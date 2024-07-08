function FigHandle = figure3(varargin)
MP = get(0, 'MonitorPositions');
if size(MP, 1) == 1  % Single monitor
  FigH = figure(varargin{:});
else                 % Multiple monitors
  % Catch creation of figure with disabled visibility: 
  indexVisible = find(strncmpi(varargin(1:2:end), 'Vis', 3));
  if ~isempty(indexVisible)
    paramVisible = varargin(indexVisible(end) + 1);
  else
    paramVisible = get(0, 'DefaultFigureVisible');
  end
  %
  Shift    = MP(2, 1:2);
  FigH     = figure(varargin{:}, 'Visible', 'off');
  drawnow;
  set(FigH, 'Units', 'pixels');
  pos      = get(FigH, 'Position');
  pause(0.02);  % See Stefan Glasauer's comment
  set(FigH, 'Position', [pos(3:4)/6 + Shift, pos(3:4).*0.75], ...
            'Visible', paramVisible,'Color',[0,0,0]);
end
if nargout ~= 0
  FigHandle = FigH;  
end
axis off
hFig = gcf;
hAx  = gca;
set(hFig,'menubar','none')
% to hide the title
set(hFig,'NumberTitle','off');
