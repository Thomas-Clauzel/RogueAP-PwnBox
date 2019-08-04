# RogueAP PwnBox

The project goal is to build a Rogue AP who can intercept credentials like HTTP authentification, FTP, SMTP ...
The version 1 of the script setup an open access point named "WIFI GRATUIT". In the background a sniffer intercept all traffic and send you an email when the program get credentials.
![alt text](https://raw.githubusercontent.com/username/projectname/branch/path/to/img.png)
### Prerequisites
Please before install the RogueAP make a proper install of Raspbian
To enable all functionnality like email alert you need to edit the script : 
```
210 - gmailsrc=src@gmail.com
211 - gmaildest=dest@gmail.com
212 - gmailpwd=PASSWORD
```
To install this RogueAP you just need the following stuff :
```
A Raspberry PI 3
An alfa network AWUS036NH
Raspbian Jessie or Stretch
```
### Installing

1 - Download the script

```
wget https://raw.githubusercontent.com/Thomas-Clauzel/RogueAP-PwnBox/master/RogueAP.sh
```

2 - Make it executable

```
sudo chmod+x RogueAP.sh
```
3- Run the script as root
```
sudo ./RogueAP.sh
```
4 - Reboot the raspberry PI
```
reboot
```
## Built With

* [net-creds](https://github.com/DanMcInerney/net-creds) - The sniffer

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

Thomas CLAUZEL

Thanks to : ------

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

