# indigo-kepler-module
A module for Kepler scientific workflow system supporting INDIGO-DataCloud (https://kepler-project.org/)

# Usage
* Prepare Kepler Build System (https://kepler-project.org/developers/teams/build/documentation/build-system-instructions)
* Edit Kepler's file `build-area/modules.txt` and add on top an entry `indigo-kepler-module.git`
* Edit Kepler's file `build-area/module-location-registry.txt` and add the following entry:
  ```
  indigo-kepler-module.git https://github.com/indigo-dc
  ```
* Download the module:
```sh
$ cd build-area/
$ ant get -Dmodule=indigo-kepler-module.git
```
* Run Kepler
```sh
$ ant run
```
