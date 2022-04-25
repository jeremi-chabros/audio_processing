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
r = 10;
s = rescale(sorted');
f = 3;
plot(s(length(iwant)-(f*1000):length(iwant)+(f*1000)));
hold on
j=1;
for i = 1:n-1
    if j<=n
        
        current_bin = s(:,j);
        v = linspace(.3,-.3,length(current_bin(end-r:end)))';
        w = gausswin(30);
        k = rescale(-filter(w,1,v));
        krev = rescale(-k);
        current_bin(end-r:end) = current_bin(end-r:end).*k;
        next_bin = s(:,j+1);
        next_bin(end-r:end) = next_bin(end-r:end).*krev;
        en = current_bin(end-r:end);
        st = next_bin(1:r);
        padding = [st;en];
        w=gausswin(200);
        bin = filter(w,1,padding);
        
        v = linspace(0.5,-0.5,length(bin))';
        w = gausswin(20);
        k = rescale(-filter(w,1,v));
        bin = rescale(bin.*k,0.501,0.502);
       
        
%         S = vertcat(S, current_bin(1:end-r-1),bin,next_bin(r:end));
        S = vertcat(S,current_bin, next_bin);
        j=j+2;
    end
end
s = S(:); 
% s(s==0)=[];
% s=rescale(s);
plot(s(10000:20000));
%%
sound(s(fs*20:end),fs);   
pause(5);  
clear sound;

%%

fid=fopen('avril14.raw','w');
fwrite(fid,rescale(s, -20,20),'float32');
fclose(fid);