% Computation encapsulation with the objective of mantaining main.m clean
% and clear

ag_HEMS = r_HEMS.r.air_gap;
cu_HEMS = r_HEMS.r.current;
f_HEMS  = r_HEMS.r.force;

ag_EMS = r_EMS.r.air_gap;
cu_EMS = r_EMS.r.current;
f_EMS  = r_EMS.r.force;

cu_map        = 1:4:33;
f_HEMS_map    = f_HEMS(:,cu_map);
f_EMS_map     = f_EMS(:,cu_map);

f_HEMS_minus_40 = f_HEMS_map(:,1);
f_HEMS_minus_30 = f_HEMS_map(:,2);
f_HEMS_minus_20 = f_HEMS_map(:,3);
f_HEMS_minus_10 = f_HEMS_map(:,4);
f_HEMS_0        = f_HEMS_map(:,5);
f_HEMS_10       = f_HEMS_map(:,6);
f_HEMS_20       = f_HEMS_map(:,7);
f_HEMS_30       = f_HEMS_map(:,8);
f_HEMS_40       = f_HEMS_map(:,9);

f_EMS_minus_40  = f_EMS_map(:,1);
f_EMS_minus_30  = f_EMS_map(:,2);
f_EMS_minus_20  = f_EMS_map(:,3);
f_EMS_minus_10  = f_EMS_map(:,4);
f_EMS_0         = f_EMS_map(:,5);
f_EMS_10        = f_EMS_map(:,6);
f_EMS_20        = f_EMS_map(:,7);
f_EMS_30        = f_EMS_map(:,8);
f_EMS_40        = f_EMS_map(:,9);