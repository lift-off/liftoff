# Lift-Off

Lift-Off Aerodynamics Software for Windows

## Getting Started

### Users
To get started with Lift-Off as a user download and install the software using its Windows Installer. Then check out the [user-manuels](https://github.com/mduu/liftoff/tree/master/doc) for the basics.

### Translators

If yout like to translate Lift-Off into a new language or update existing translations you can install Lift-Off as described. For new translations copy an existing translations ``.lng``file and translate each line (only the right part after the ``=``) using a texteditor. Updating existing translations works the same way but instead copy the file change the existing file. When done eighter directly place a pull-request or contact me so I can integrate it.

### Airfoil maintainers

Lift-Off features a huge airfoil [database](https://github.com/mduu/liftoff/tree/master/src/airfoils) with currently more then 2200 airfoils. May commonly used airfoils are already available but we miss lack of newer airfoils. Help on integrating missing airfoils is very welcome and doesn't require programming skils.

Basically each ``.airfoil``file contains the airfoils coordinates and its RE series calculated by a electronic wind tunnel software. For the coordinates one can use software like *Profili*. For the electronic wind tunnel one can pass the coordinates into a software called *Xfoil*. We are working on a dochmentation on how to create new ``.airfoil``files.

### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

### Installing

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

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

* Hat tip to anyone who's code was used
* Inspiration
* etc
