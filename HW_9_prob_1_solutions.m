

clear; clc; close all;
fid_alpha = fopen ('alpha_tat_density.txt','a');

B = imread('cyto.tif');
imshow(B, [], 'InitialMagnification','fit')


for blots = 1 : 11
    
    xf=[];
    yf=[];
    P=[];
    [xf,yf,P]=impixel();
    avgy= round((yf(2,1)+yf(1,1))/2);
    box_top = 10;
    box_cntr = 0;
    sumColorValsG  = 0;
    ctr=0;
    y_pos = avgy; 
    figure;
    imshow(B, [], 'InitialMagnification', 'fit');
    hold on
    
    plot([xf(1,1) xf(2,1)],[y_pos-box_top y_pos-box_top], 'w');
    plot([xf(1,1) xf(2,1)], [y_pos+box_top y_pos+box_top], 'w');
    plot([xf(1,1) xf(1,1)], [y_pos-box_top y_pos+box_top], 'w');
    plot([xf(2,1) xf(2,1)], [y_pos-box_top y_pos+box_top], 'w');
    
    hold off
    
    
    
    for a=xf(1,1):1:xf(2,1)
        
        ctr=ctr+1;
        colorValsG(ctr) = 0;
       
        
        for b= avgy-box_top:avgy+box_top
            
            [xt,yt,P]= impixel(B,a,b);
            colorValsG(ctr) = colorValsG(ctr) + P(2);
            
        end
        
     
        
        sumColorValsG = sumColorValsG + colorValsG(ctr);
         
        
        
    end  %end of individual blot
    
    
    fprintf (fid_alpha,'%d ',sumColorValsG);
    
    
    
end  %end of western blots (6)


fprintf (fid_alpha, '\r\n');
fclose(fid_alpha) 

