This blog describes a quick and simple BASH script I wrote when I started doing penetration testing with Synack's Red Team. I wanted to write an easy and straightforward script before starting to scan targets.

Once a project is selected, a VPN configuration is generated and used to VPN into the Launchpoint, which acts as a gateway for all traffic destined for the target's network. The VPN is stable and has not failed me yet, but what if it did? The VPN configuration pushes all Internet-bound traffic through the VPN, as along as it is up.  If you kicked off a scan to run overnight and all of the sudden the VPN connection drops, that traffic will start leaving your home or office's network and head straight to the target network.  I did not want to risk explaining myself to my ISP, the FBI, or the target organization.

To prevent this, I developed a quick BASH script, called srt_fw.sh, to run before starting a Synack Red Team project.  It does three things:

1. Prompts for any domains to block and does a DNS lookup on the IPs
2. Prompts for any IP addresses to block
3. Uses ufw or iptables (your choice) to loop through the IPs and create firewall rules to prevent direct communication with them on my primary Kali network interface `eth0`.

The domains and IP addresses are provided in the project details and can be copy/pasted. It also has optional commands to allow SSH and [dnmap](http://sourceforge.net/projects/dnmap/) if you VPN into the Launchpoint from distributed servers. Another useful byproduct is the target_ips.txt file which can be used to feed into other tools, like nmap:

    nmap -iL target_ips.txt

The code can be found here https://github.com/opsdisk/srt_fw. I plan on improving it in time and want to develop a simple batch script for the Windows OS as well.

Comments, suggestions, and improvements are always welcome.  Be sure to follow [@opsdisk](https://twitter.com/opsdisk) on Twitter for the latest updates.
