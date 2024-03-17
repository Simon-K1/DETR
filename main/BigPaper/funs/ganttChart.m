% 
% function ganttHdl=ganttChart(sT,dT,id,varargin)
% % sT | 任务开始时间
% % dT | 任务持续时间
% % id | 任务所属类型
% 
% % @author : slandarer
% % 公众号  : slandarer随笔
% ax=gca;hold on;
% ax.YTick=1:max(id);
% ax.YLim=[0,max(id)+1];
% sT=sT(:);dT=dT(:);id=id(:);
% 
% % 基本配色表
% this.colorList=[118 160 173;89 124 139;212 185 130;
%     217 189 195;165 108 127;188 176 210]./255;
% this.colorList=[this.colorList;rand(max(id),3).*.6+.4];
% 
% % 获取其他属性
% this.String='';
% arginList={'String','ColorList'};
% for i=(length(varargin)-1):-2:1
%     tid=ismember(arginList,varargin{i});
%     if any(tid)
%         this.(arginList{tid})=varargin{i+1};
%         varargin(i:i+1)=[];
%     end
% end
% 
% 
% % 循环绘图
% for i=unique(id)'
%     t_sT=sT(id==i);
%     t_dT=dT(id==i);
%     [t_sT,t_ind]=sort(t_sT);
%     t_dT=t_dT(t_ind);
%     if ~isempty(this.String)
%         t_Str=this.String(id==i);
%         t_Str=t_Str(t_ind);
%     end
%     for j=1:length(t_sT)
%         ganttHdl.(['p',num2str(i)])(j)=rectangle('Position',[t_sT(j),i-.4,t_dT(j),.8],...
%             'LineWidth',.8,'EdgeColor',[.2,.2,.2],...
%             'FaceColor',this.colorList(i,:),'AlignVertexCenters','on',varargin{:});
%     end
%     for j=1:length(t_sT)
%         if ~isempty(this.String)
%             ganttHdl.(['t',num2str(i)])(j)=text(t_sT(j),i,t_Str{j});
%         else
%             ganttHdl.(['t',num2str(i)])(j)=text(t_sT(j),i,'');
%         end
%     end
% end
% end
function ganttHdl = ganttChart(sT, dT, id, varargin)
% sT | 任务开始时间
% dT | 任务持续时间
% id | 任务所属类型

% 作者: slandarer
% 公众号: slandarer随笔
ax = gca;
hold on;
ax.YTick = 1:max(id);
ax.YLim = [0, max(id) + 1];
sT = sT(:);
dT = dT(:);
id = id(:);

% 明亮配色表
this.colorList = [255, 102, 102; 255, 178, 102; 255, 255, 102;
    178, 255, 102; 102, 255, 178; 102, 178, 255]./255;
this.colorList = [this.colorList; rand(max(id), 3) .* 0.6 + 0.4];

% 获取其他属性
this.String = '';
arginList = {'String', 'ColorList'};
for i = (length(varargin) - 1):-2:1
    tid = ismember(arginList, varargin{i});
    if any(tid)
        this.(arginList{tid}) = varargin{i + 1};
        varargin(i:i + 1) = [];
    end
end

% 循环绘图
ganttHdl = struct();
for i = unique(id)'
    t_sT = sT(id == i);
    t_dT = dT(id == i);
    [t_sT, t_ind] = sort(t_sT);
    t_dT = t_dT(t_ind);
    if ~isempty(this.String)
        t_Str = this.String(id == i);
        t_Str = t_Str(t_ind);
    end
    for j = 1:length(t_sT)
        ganttHdl.(['p', num2str(i)])(j) = rectangle('Position', [t_sT(j), i - 0.4, t_dT(j), 0.8], ...
            'LineWidth', 0.8, 'EdgeColor', [0.2, 0.2, 0.2], ...
            'FaceColor', this.colorList(i, :), 'AlignVertexCenters', 'on', varargin{:});
    end
    for j = 1:length(t_sT)
        if ~isempty(this.String)
            ganttHdl.(['t', num2str(i)])(j) = text(t_sT(j), i, t_Str{j});
        else
            ganttHdl.(['t', num2str(i)])(j) = text(t_sT(j), i, '');
        end
        set(ganttHdl.(['t', num2str(i)])(j), 'Color', [0.2, 0.2, 0.2]);
    end
end
end