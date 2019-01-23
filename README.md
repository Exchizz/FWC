# FWC
This tiny FireWall Compiler consists of a small suite of bash and python scripts to ease the process of maintaining an iptables firewall.


# How to install
1. Copy or link fwc* to /usr/local/sbin/
2. copy content of repo to /etc/firewall/


# Usage
1. Define zones in **fwc_zones**
2. Add policies to **fwc_policies**
3. Run **fwc** as root
4. Run sudo bash /etc/firewall/up.bash
5. If you wanna create the rules as the host boots, run /etc/firewall/up.bash during startup.


# Description
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
The policy specified above will allow ssh connections originating from "Labnet" and ending at "Local". Furthermore, the reply originating from "Local" ending at "Labnet" is allowed meaning an ssh connection can be established from "Labnet" to "Local", but not the other way around. In order for this to work, another policy should be added.

Instead of creating chains and adding policies, this is generated by python scrips located in the **FWC** dir. 
The FWC consists of three scripts:

* fwc_policy- This script generates the policies. The input is specified in the beginning of the script. An example of the chain specified about is given below:
    ```
    # Fromzone, Tozone, protocol
    policies.append(["labnet", "local", "ssh"])
    ```
 This will generate the same policy as in previous example.
 
* fwc_zones - This script generates zones such as. "LabnetToLocal", "LocalToLanet" etc. Which interface "Labnet" is associated with is defined in var.sh
* fwc - This scripts run fwc_policy.py and fwc_zones.py and redirects their output to bash scripts in /etc/firewall/generated/



