# Lift-Off

Lift-Off Aerodynamics Software for Windows

## Getting Started

After two decades of development and maintainance we finally decided to open-source Liftoff and release it for free. We do this because we think is way more people will use software and we never had the intension to make a lot of money. We think its best also for Liftoff to spread it out widely. This way the community can participate and even enhance the software so it gets better for all of us.

### Users
To get started with Lift-Off as a user simply [download](http://idev.ch) and install the software using its Windows Installer. Then check out the [user-manuels](https://github.com/mduu/liftoff/tree/master/doc) for the basics.

### Translators

If yout like to translate Lift-Off into a new language or update existing translations you can install Lift-Off as described. For new translations copy an existing translations ``.lng``file and translate each line (only the right part after the ``=``) using a texteditor. Updating existing translations works the same way but instead copy the file change the existing file. When done eighter directly place a pull-request or contact me so I can integrate it.

### Airfoil maintainers

Lift-Off features a huge airfoil [database](https://github.com/mduu/liftoff/tree/master/src/airfoils) with currently more then 2200 airfoils. May commonly used airfoils are already available but we miss lack of newer airfoils. Help on integrating missing airfoils is very welcome and doesn't require programming skils.

Basically each ``.airfoil``file contains the airfoils coordinates and its RE series calculated by a electronic wind tunnel software. For the coordinates one can use software like *Profili*. For the electronic wind tunnel one can pass the coordinates into a software called *Xfoil*. We are working on a dochmentation on how to create new ``.airfoil``files.

### Developers

If you like to contribute source-code to Lift-Off you need to set up the development environment first. See below for further instructions. Lift-Off is enirely written in Delphi (Pascal). You need to know Delphi/Pascal to code for Lift-Off.

### Prerequisites

To write code for Lift-Off you need to set up your development environment first. THis requires:

* Delphi 7
* Developer Express Bars 5 VCL

### Installing

If you have installed the prerequirements you should be able to compile LIft-Off using the ``src/liftoff.dpr`` project or the project-group found in ``src/liftoff.bpg``.

If you like to have desinger support for forms and data-modules you need to install the design-time packages for the libraries. One of them is our own iDev library in ``src/lib/idev.dpk``. The others are in ``externals/*``.

To get multilanguage support while debugging copy the ``.lng`` files you need to the ``src/bin`` directory. This is optional for development. If no translation files are in the bin-folder german will be used out of the box.

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/mduu/liftoff/tags). 

## Authors

* **Marc Dürst** - *Developer and Project Lead* - [mduu](https://github.com/mduu) | [@marcduerst](https://twitter.com/marcduerst)
* **Hans Dürst** - *Domain Expert and Consultant*

See also the list of [contributors](https://github.com/mduu/liftoff/contributors) who participated in this project.

## License

This project is licensed under the GPL v3 - see the [LICENSE.txt](LICENSE.txt) file for details

## Acknowledgments

* H.-W. Bender for his early work with AEROCALC which was the origin.
* Ludwig Wiechers for his work with AERODESIGN. His algorythms where the starting point for Lift-Off decades ago.
* Hans Dürst for his endless time helping with testing and debugging Lift-Off as well as maintain the airfoil database
* Christian Baron for contributing the POC of the spar calculations
