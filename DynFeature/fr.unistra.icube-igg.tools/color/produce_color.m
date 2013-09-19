function [ colorPerVal ] = produce_color( val  )
    val=reshape(val,numel(val),1);
    vMin=min(val);
    vMax=max(val);
    % Small value -> blue, High value -> red
    H=(ones(size(val))-val./vMax)*2/3;
    S=ones(size(val));
    V=ones(size(val));
    colorPerVal = 255 * hsv2rgb([H,S,V]);
end % function