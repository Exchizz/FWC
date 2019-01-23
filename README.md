# FWC
This tiny FireWall Compiler consists of a small suite of bash and python scripts to ease the process of maintaining an iptables firewall.

This firewall compiler is utilizing an Iptables designb developmed by John Hallam at SDU. The design split iptables rules into policies and protocols.

* proto.sh defines protcols such as http, https, ntp etc.
ex.
    ```
    # SECURE SHELL PROTOCOL
    $iptables -N ssh-c2s
    $iptables -N ssh-s2c

         # ssh connection client to server
         $iptables -A ssh-c2s -p tcp --dport ssh --sport $UNPRIV -m state --state NEW,ESTABLISHED -j ACCEPT
         $iptables -A ssh-c2s -p tcp --dport ssh --sport $HIPRIV -m state --state NEW,ESTABLISHED -j ACCEPT
         # ssh responses server to client
         $iptables -A ssh-s2c -p tcp --sport ssh -m state --state ESTABLISHED -j ACCEPT
    ```
     c2s = client to server
     s2c = server to client
     
     
* policy.sh defines policies meaning what trafik is allowed.
ex. 
```
    # Allow ssh-c2s from "Labnet" to "local"
    $iptables -A LabnetToLocal -j ssh-c2s
    
    # Allow ssh-s2c from "local" to "labnet"
    $iptables -A LocalToLabnet -j ssh-s2c
```
