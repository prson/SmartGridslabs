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

% Error calculation after reconfiguration and with OLTC
vm9=(390+391+392)/3;
vm5=(393+394+394)/3;
vm10=(403.79+403.79+402.79)/3;
vm13=(417.29+418.19+418.99)/3
vm=[vm9 vm5 vm10 vm13]
vs=[393.7974 395.4535 403.8026 416.6461];
err=((vs-vm)*100./vs)

% Error calculation after reconfiguration and with OLTC
vm9=(388+388+389)/3;
vm5=(410+410+411)/3;
vm10=(417.39+416.69+417.49)/3;
vm13=(418.59+417.99+418.79)/3
vm=[vm9 vm5 vm10 vm13]
vs=[387.1713 412.7734 417.2732 419.7746];
err=((vs-vm)*100./vs)