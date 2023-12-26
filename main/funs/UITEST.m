function result = UITEST()
    % 创建一个 GUI 窗口
    fig = uifigure('Name', '缺人按钮示例');
    
    % 创建一个按钮并设置其初始状态为隐藏
    button = uibutton(fig, 'Text', '缺人按钮', 'Position', [100 100 100 50], 'Visible', 'on');
    
    % 创建一个结果变量，初始值为假
    result = false;
    
    % 按钮的回调函数
    function buttonCallback(~, ~)
        result = true; % 设置结果变量为真
    end
    
    % 在 GUI 窗口中添加按钮的点击回调
    button.ButtonPushedFcn = @buttonCallback;
    
    % 等待 GUI 窗口关闭
    waitfor(fig);
end