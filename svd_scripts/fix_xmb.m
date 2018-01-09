
function [xmb] = fix_xmb(xmb)

% remove bad data
xmb.cc_mt_2(1).data   =0;
xmb.cc_mt_2(4).data   =0;
xmb.cc_mt_2(12).data  =0;

% fix polarity
xmb.cc_mt_2(1).signal(:,2)  = - xmb.cc_mt_2(1).signal(:,2);
xmb.cc_mt_2(2).signal(:,2)  = + xmb.cc_mt_2(2).signal(:,2);
xmb.cc_mt_2(3).signal(:,2)  = - xmb.cc_mt_2(3).signal(:,2);
xmb.cc_mt_2(4).signal(:,2)  = - xmb.cc_mt_2(4).signal(:,2);
xmb.cc_mt_2(5).signal(:,2)  = + xmb.cc_mt_2(5).signal(:,2);
xmb.cc_mt_2(6).signal(:,2)  = - xmb.cc_mt_2(6).signal(:,2);
xmb.cc_mt_2(7).signal(:,2)  = - xmb.cc_mt_2(7).signal(:,2);
xmb.cc_mt_2(8).signal(:,2)  = - xmb.cc_mt_2(8).signal(:,2);
xmb.cc_mt_2(9).signal(:,2)  = - xmb.cc_mt_2(9).signal(:,2);
xmb.cc_mt_2(10).signal(:,2) = - xmb.cc_mt_2(10).signal(:,2);
xmb.cc_mt_2(11).signal(:,2) = - xmb.cc_mt_2(11).signal(:,2);
xmb.cc_mt_2(12).signal(:,2) = - xmb.cc_mt_2(12).signal(:,2);

return;
