clearvars; clc;
[y,fs]=audioread('avril.mp3');
y = y(fs*30:end,:);
bpm=120;
beat = fs/bpm;

A = y(:,1) ;  % you data
a = length(A);
% n = 200;
n = 200;
b = a + (n - rem(a,n))   ; % Get number divisible by 32
B = zeros(1,b) ;
B(1:a) =  A ;  % This pad extra zeros
iwant = reshape(B,b/n,[]);

tic
sorted = clusterSort(iwant(1:end,:)');
toc
%%
S = [];
j = 1;
s = rescale(sorted');
win = 500;

ll=length(iwant);
% plot(s(ll-1000:ll+1000));
% xline(1000);
smoothed =zeros(2*win,1);
for i = 1:n-1
    if j<=n
        
        now = s(:,j);
        next = s(:,j+1);
        bin = vertcat(now(end-win+1:end), next(1:win));
 
        % fade-in/fade-out
%         v = linspace(-mean(now),mean(now),win);
        v = linspace(-1,1,win);
        gw = gausswin(2*win);
        v = rescale(filter(gw,1,v));
%         v_rev = linspace(mean(now),-mean(now),win);
        v_rev = linspace(1,-1,win);
        v_rev = rescale(filter(gw,1,v_rev));
        
       
%         now(end-win+1:end) = now(end-win+1:end).*v';
%         next(1:win) = next(1:win).*v_rev';
        
        smoothed(1:win) = bin(1:win)-2*v_rev';
        smoothed(win+1:end) = bin(1:win)-2*v';
        
        gw = gausswin(20);
        smoothed = rescale(filter(gw,1, smoothed),min(now)*0.5, max(now)*0.5);
        
%         S = vertcat(S, now(1:end-win),bin, next(win+1:end));
        S = vertcat(S,now,next);
    end
    j = j+2;
end
s = S(:);
%%
sound(s(fs*20:end),fs);
pause(5);
clear sound; 
%%
fid=fopen('avril14.raw','w');
fwrite(fid,rescale(s, -20,20),'float32');
fclose(fid);