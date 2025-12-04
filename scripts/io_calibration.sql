SET SERVEROUTPUT ON
DECLARE
  l_latency  PLS_INTEGER;
  l_iops     PLS_INTEGER;
  l_mbps     PLS_INTEGER;
BEGIN
   DBMS_RESOURCE_MANAGER.calibrate_io (num_physical_disks => 1, 
                                       max_latency        => 20,
                                       max_iops           => l_iops,
                                       max_mbps           => l_mbps,
                                       actual_latency     => l_latency);
 
  DBMS_OUTPUT.put_line('Max IOPS = ' || l_iops);
  DBMS_OUTPUT.put_line('Max MBPS = ' || l_mbps);
  DBMS_OUTPUT.put_line('Latency  = ' || l_latency);
END;
/