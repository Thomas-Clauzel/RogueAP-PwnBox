# RogueAP PwnBox

The project goal is to build a Rogue AP who can intercept credentials like HTTP authentification, FTP, SMTP ...
The version 1 of the script setup an open access point named "WIFI GRATUIT". In the background a sniffer intercept all traffic and send you an email when the program get credentials.
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
## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc

