function x=genLabelData(f1,nVerts,nepochs,jitter,time,noiseLevel,varAcrossFreq,flagSignal)

% noiseLevel between

if ~exist('flagSignal','var')
    flagSignal=1;
end


t1=find(time>0.2,1,'first');
t2=find(time>0.4,1,'first');

ntime=length(time);

x=noiseLevel.*randn(nVerts,nepochs,ntime);

if flagSignal==1
    for j=1:nVerts
        for k=1:nepochs
            for i=1:length(f1)
                randnum=rand(1);
                if randnum <0.1;randnum =0;end;
                x(j,k,t1:t2)=squeeze(x(j,k,t1:t2))+randnum.*varAcrossFreq(i).*hann(length(time(t1:t2))).*sin(2.*pi*f1(i)*time(t1:t2))';
            end
        end
    end
    
    x=x./length(f1);
end

if flagSignal==1 || flagSignal==0
    
    for i=1:nVerts
        for j=1:nepochs
            t=jitter(j)+round(rand(1)*3);
            surrogate_move=[t(1):ntime 1:t(1)-1];
            x(i,j,:)=x(i,j,surrogate_move);
        end
    end
    
    
    
    x=permute(x,[1 3 2]);
    
end

if flagSignal==2
    
    t1=find(time>0.2,1,'first');
    t2=find(time>0.4,1,'first');
    ntime=length(time);
    
    x=zeros(nVerts,nepochs,ntime);
    
    for j=1:nVerts
        for k=1:nepochs
            for i=1:length(f1)
                
                x(j,k,t1:t2)=hann(length(time(t1:t2))).*sin(2.*pi*f1(i)*time(t1:t2))';
            end
        end
    end
    
    x=x./length(f1);
    
    x=permute(x,[1 3 2]);
    
end


end