clc
clear all
close all
% -----------------------------------------
epsl=1;
refindex=sqrt(epsl);
lambda=3e8/(430e12*refindex);
a=0.01;
kp=2*pi/lambda;
z=0*lambda;
d=360e-9;
% -----------------------------------------


AMPLITUDE='amp.txt';
at=importdata(AMPLITUDE);
am=at.data(1:1:11870,4);

PHASE='pha.txt';
pt=importdata(PHASE);
ph=pt.data(1:1:11870,4);

lenght=at.data(1:1:11870,3);
aa=at.data(1:1:11870,1);
bb=at.data(1:1:11870,2);
[m,n]=size(lenght);
k=1;
for i=1:m
    if lenght(i)==0
        phasee(k,1)=aa(i);
        phasee(k,2)=bb(i);
        phasee(k,3)=ph(i);
        ampp(k,1)=aa(i);
        ampp(k,2)=bb(i);
        ampp(k,3)=am(i);
        k=k+1;
    end 
end
alphamatrix=reshape(phasee(:,1),68,81); %81 phi*68 ri
rimatrix=reshape(phasee(:,2),68,81);
phaseMatrix=reshape(phasee(:,3),68,81);
ampn=ampp(:,3);
ampMatrix=reshape(ampn,68,81); 
%-------------------------------------
alpha_ri_amp_ph=zeros(68,81,4);
alpha_ri_amp_ph(:,:,1)=alphamatrix;
alpha_ri_amp_ph(:,:,2)=rimatrix;
alpha_ri_amp_ph(:,:,3)=ampMatrix;
alpha_ri_amp_ph(:,:,4)=phaseMatrix;
maxamp=max(max(alpha_ri_amp_ph(:,:,3)));
%-------------------------------
a1=0;b1=0;a2=0;b2=0;a3=0;b3=0;a4=0;b4=0;a5=0;b5=0;a6=0;b6=0;b7=0;b8=0;b9=0;b10=0;
for i=1:68
    for j=1:81
                b1=b1+1;
                alphafinal(b1,1)=alpha_ri_amp_ph(i,j,1);
                rifinal(b1,1)=alpha_ri_amp_ph(i,j,2);
                alpharifinal=[alphafinal rifinal];
                ampfinal(b1,1)=alpha_ri_amp_ph(i,j,3)./maxamp;
                phasefinal(b1,1)=alpha_ri_amp_ph(i,j,4);
                
       end
end

 %-----------------------AFA
k3=1;
amplitude_limit=0;
phase_limit=0;
asize=zeros(150,1);
bsize=zeros(150,1);
for m=1:150
xl1=.35e-5; %%xl example is 0.35e-5
xl2=0.35e-5;
nu1=1;
nu2=1;
x01=1.e-6; %%x0=120e-8;
x02=2.e-6;
ki1=z./(k*x01.^2);
ki2=z./(k*x02.^2);
X(m)=(m-150/2)*d;
s1(m)=(X(m)+xl1)/x01; 
s2(m)=-(X(m)-xl2)/x02;

ph1(m)=airy(s1(m)-(ki1./2).^2+1i.*a.*ki1-nu1.*ki1).*exp(a.*s1(m)-(a.*ki1.^2./2)-a.*ki1.*nu1).*exp(1i*((-ki1.^3/12)+(a.^2-nu1.^2+s1(m)).*ki1./2+nu1.*s1(m)-nu1.*ki1.^2/2));
ph2(m)=airy(s2(m)-(ki2./2).^2+1i.*a.*ki2-nu2.*ki2).*exp(a.*s2(m)-(a.*ki2.^2./2)-a.*ki2.*nu2).*exp(1i*((-ki2.^3/12)+(a.^2-nu2.^2+s2(m)).*ki2./2+nu2.*s2(m)-nu2.*ki2.^2/2));
wave(m)=ph1(m)+ph2(m);
wavef(m)=wave(m);
phiaf(m)=angle(wavef(m))*180/pi;
ampaf(m)=abs(wavef(m))/0.5293;% 0.5279=max(ampaf) 
       
        
        for l1=1:b1            
            amp_difaf(l1,m)=abs(ampfinal(l1)-ampaf(m));
            phid_difaf(l1,m)=abs(phasefinal(l1)-phiaf(m));
            
        end
        
        for i3=1:b1
                if  (phid_difaf(i3,m)<=phase_limit+0)    && (amp_difaf(i3,m)<=amplitude_limit+0.01)
                    alphasizeaf(m,1)=alphafinal(i3,1);
                    risizeaf(m,1)=rifinal(i3,1);
                    phisaf(m,1)=phasefinal(i3,1);
                    ampsaf(m,1)= ampfinal(i3,1);
                elseif (phid_difaf(i3,m)<=phase_limit+5)    && (amp_difaf(i3,m)<=amplitude_limit+0.03)
                    alphasizeaf(m,1)=alphafinal(i3,1);
                    risizeaf(m,1)=rifinal(i3,1);
                    phisaf(m,1)=phasefinal(i3,1);
                    ampsaf(m,1)= ampfinal(i3,1);
                elseif (phid_difaf(i3,m)<=phase_limit+10.5)    && (amp_difaf(i3,m)<=amplitude_limit+.047)
                    alphasizeaf(m,1)=alphafinal(i3,1);
                    risizeaf(m,1)=rifinal(i3,1);
                    phisaf(m,1)=phasefinal(i3,1);
                    ampsaf(m,1)= ampfinal(i3,1);
                
                end
        end
        end
for k4=1:150
    if alphasizeaf(k4)==0 %|| alphasizea(k4)==0
        w=w+1;
    end
end
%%%%%%%%%%%%%%%%%% Just for Plot
 for mm=1:600
 xp(mm)=(mm-4*150/2)*d/4;
    s1p(mm)=(xp(mm)+xl1)/x01; 
    s2p(mm)=-(xp(mm)-xl2)/x02;

    ph1p(mm)=airy(s1p(mm)-(ki1./2).^2+1i.*a.*ki1-nu1.*ki1).*exp(a.*s1p(mm)-(a.*ki1.^2./2)-a.*ki1.*nu1).*exp(1i*((-ki1.^3/12)+(a.^2-nu1.^2+s1p(mm)).*ki1./2+nu1.*s1p(mm)-nu1.*ki1.^2/2));
    ph2p(mm)=airy(s2p(mm)-(ki2./2).^2+1i.*a.*ki2-nu2.*ki2).*exp(a.*s2p(mm)-(a.*ki2.^2./2)-a.*ki2.*nu2).*exp(1i*((-ki2.^3/12)+(a.^2-nu2.^2+s2p(mm)).*ki2./2+nu2.*s2p(mm)-nu2.*ki2.^2/2));
    wavep(mm)=ph1p(mm)+ph2p(mm);
    wavefp(mm)=wavep(mm);
    phiafp(mm)=angle(wavefp(mm))*180/pi;
    ampafp(mm)=abs(wavefp(mm))/max(abs(wavef));
 
 end
%plot(xp*1e6,amppp/max(amppp))
plot(xp*1e6,phiafp,':m')
 %plot(xp*1e6,phiap,':m')
% plot(xp*1e6, amppp,':m',xp*1e6, ampnew,'--g')
% plot(xp*1e6, ampapp)
 hold on

 
%%%%%%%%%%%%%%%%%%%%%%%
zzabsize=[alphasizeaf risizeaf];
%phisa=reshape(phisa,150,1);
phisaf=reshape(phisaf,150,1);
 
for counter=1:150
xpp(counter)=(counter-150/2)*d*1e6;
%plot(xpp(counter),ampsa(counter)/0.5551,'*r')
%plot(xpp(counter),ampsaf(counter),'*r')
% plot(counter,ampa(counter)/max(ampa),'or',counter,abs(ampsaf(counter)),'*k')
% plot(counter,phia(counter),'or',counter,abs(phif(counter)-phisaf(counter)),'*k')
plot(xpp(counter),phisaf(counter),'*k')
% plot(xpp(counter),phiaf(counter),'or')
% plot(xpp(counter),ampsaf(counter),'or')
   hold on
end

fid = fopen('D:\off-axis\x01,1,x02,2,xl1,xl2,3.5,nu1,nu2,1\alphas.txt','wt');
 for ii = 1:size(alphasizeaf,1)
     fprintf(fid,'%g\t',alphasizeaf(ii,:));
     fprintf(fid,'\n');
 end
fclose(fid);
 fid = fopen('D:\off-axis\x01,1,x02,2,xl1,xl2,3.5,nu1,nu2,1\ris.txt','wt');
 for ii = 1:size(risizeaf,1)
     fprintf(fid,'%g\t',risizeaf(ii,:));
     fprintf(fid,'\n');
 end
fclose(fid)
    


dataout1=(risizeaf);
dataout2=(alphasizeaf);
% 
% save('ri.txt','dataout1','-ascii');
% save('alpha.txt','dataout2','-ascii');


