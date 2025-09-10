# Class7_hw_9-9-25
1. Opened up SecutiryGroup, naming the security group.
2. Afterwards I add the inbound group for HTTP for port 80, also adding anywhere Ipv4. Also I add port 22 for ssh into my machine if I need to.
3. From there I skip the outbound rules, since I won't need to do anything with that.
4. I add tags to identify the security group.
5. Then I head to the Instance tab and click on create instances.
6. I would head to MookieWAF and click on bmc4, and copy ec2scipt.
7. I fill out the name and information for the Instance, then I add the AMI and also select the t2 or t3 micro.
8. I click create access keys so I can ssh into my instance.
9. I then head to advance details drop down and paste the script
10. Then I review everything to make sure everything is correct.
11. Once the instance is launched I would then click on instance and head to the instance summary
12. Then I would click on the dns link to copy the address and then test it out on http:// and paste the link you copied.
    
