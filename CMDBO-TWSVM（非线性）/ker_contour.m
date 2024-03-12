function [ ] = ker_contour(ker,X,v)
% 绘制contour
xaxis = 1;
yaxis = 2;
aspect = 0;
mag = 0.1;
input = zeros(1,size(X,2));% 一行两列，元素全为0
[m,n]=size(v);
m=max(m,n);
alpha=v(1:m-1);
bias=v(m);
d=floor(m/2);
xmin = min(X(:,xaxis)); xmax = max(X(:,xaxis)); 
    ymin = min(X(:,yaxis));ymax = max(X(:,yaxis)); 
    xa = (xmax - xmin); ya = (ymax - ymin);
    if (~aspect)
       if (0.75*abs(xa) < abs(ya)) 
          offadd = 0.5*(ya*4/3 - xa);
          xmin = xmin - offadd - mag*0.5*ya; xmax = xmax + offadd + mag*0.5*ya;
          ymin = ymin - mag*0.5*ya; ymax = ymax + mag*0.5*ya;
       else
          offadd = 0.5*(xa*3/4 - ya);
          xmin = xmin - mag*0.5*xa; xmax = xmax + mag*0.5*xa;
          ymin = ymin - offadd - mag*0.5*xa; ymax = ymax + offadd + mag*0.5*xa;
       end
    else
       xmin = xmin - mag*0.5*xa; xmax = xmax + mag*0.5*xa;
       ymin = ymin - mag*0.5*ya;ymax = ymax + mag*0.5*ya;
    end
    
    set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax]);  
    X=X';
    %  绘制函数值
    [x,y] = meshgrid(xmin:(xmax-xmin)/d:xmax,ymin:(ymax-ymin)/d:ymax); 
    z = bias*ones(size(x));
    for x1 = 1 : size(x,1)
      for y1 = 1 : size(x,2)
        input(xaxis) = x(x1,y1); input(yaxis) = y(x1,y1);
        z(x1,y1) = z(x1,y1)+ker_Gaussian(input,X,ker)*alpha;       
      end
    end
   
      shading interp
    %  绘制康托图的边界
%     contour(x,y,z,[0,0],'k');     % 绘制值为零的等高线 
%     hold on
    contour(x,y,z,[-1 -1],'k:')   % 绘制值为-1的等高线
    hold on
    contour(x,y,z,[1 1],'k:')     % 绘制值为1的等高线

end

