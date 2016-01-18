function wait_lidar()  % Wait 4 seconds for lidar wake up
    wt = waitbar(0,'Waiting Lidar Start...');
    for p=1:4
        pause(1);
        waitbar(p/4,wt,'Waiting Lidar Start......');
    end
    close(wt);
end