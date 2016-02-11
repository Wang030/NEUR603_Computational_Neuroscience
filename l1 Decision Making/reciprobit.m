function h=reciprobit(varargin)
% RECIPROBIT  Plots a reciprobit plot of the given latencies
%
% reciprobit(rts, rts, rts, ...)
%
% rts:   An array of reaction times from a given simulation. Note: You can
%        provide up to 4 arrays which will be plotted with different colors.

colors = 'brgkbrgkbrgk';

for n=1:nargin
   lats = varargin{n};
   lats = lats(find(lats>0));

   x = [50:2:2000];
   xticks = [50,100,200,400,1000];
   yticks = [0.001,0.01,0.10,0.30,0.50,0.70,0.90,0.99,0.999];

   yy1 = cumsum(hist(lats,x)) / length(lats);
   yy = invcumgaus(yy1,0.5,1);
   is = find(~isnan(yy) & yy & ~isinf(yy));
   xx = -( 1./(x(is)) );
   yy = yy(is);
   h=plot(xx,yy,[colors(n),'.-']);
   set(gca,'XTick',-( 1./(xticks) ));
   set(gca,'XTickLabel',xticks);
   xlabel('Reaction time (ms)');
   set(gca,'YTick',invcumgaus(yticks,0.5,1),'YTickLabel',yticks*100);
   ylabel('Cumulative fraction of trials');
   axis([-( 1./([45,20000]) ), invcumgaus(yticks([1,end]),0.5,1)]);
   hold on;
end
