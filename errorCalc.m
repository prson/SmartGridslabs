% Error calculation before reconfiguration
vm9=(387+388+388)/3;
vm5=(409+410+411)/3;
vm10=(416.58+416.49+417.79)/3;
vm12=(427.59+427.09+427.69)/3
vm=[vm9 vm5 vm10 vm12]
vs=[387.654 412.97 417.474 428.6681];
err=((vs-vm)*100./vs)

% Error calculation after reconfiguration
vm9=(387+388+388)/3;
vm5=(409+410+411)/3;
vm10=(416.58+416.49+417.79)/3;
vm12=(427.59+427.09+427.69)/3
vm=[vm9 vm5 vm10 vm12]
vs=[393.8178 395.4197 403.8026 412.6054];
err=((vs-vm)*100./vs)