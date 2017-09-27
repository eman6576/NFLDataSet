# NFLDataSet

A scraper that scrapes data from NFL.com for generating a dataset

![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![DUB](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/eman6576/NFLDataSet/blob/master/LICENSE)
[![platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)]()

## Overview
NFLDataSet is a Swift package that scrapes NFL.com for football game stats for generating a dataset. When a dataset is generated, the file is in `csv` format that is saved to your desktop. With this dataset, it can then be used for data analysis, machine learning, etc. The dataset supports regular season games from 2009 to 2016. These are the fields retrieved for each game:

* Season
* Week
* Home Team Name
* Home Team Final Score
* Home Team Score For First Quarter
* Home Team Score For Second Quarter
* Home Team Score For Third Quarter
* Home Team Score For Fourth Quarter
* Home Team Total Wins
* Home Team Total Losses
* Home Team Total Ties
* Away Team Name
* Away Team Final Score
* Away Team Score For First Quarter
* Away Team Score For Second Quarter
* Away Team Score For Third Quarter
* Away Team Score For Fourth Quarter
* Away Team Total Wins
* Away Team Total Losses
* Away Team Total Ties
* Winner For The Game

Overtime, more different types of football stats for a game will be used to increase the dataset for accuracy. If you are interested in contributing, please check out the contributing section bellow.

## Requirements For Installing Locally

* Xcode 9.0.*
* Swift 4.0.*
* Swift Packagae Manager

## Installation

### libxml2
You will need the system libraries for parsing XML or HTML install on your machine or you will receive an error when compling.

1. Using Homebrew, install libxml2 with `$ brew install libxml2`.
1. Then run `$ brew link --force libxml2`.

### Setup

With the system level dependecies installed, we can begin setting up the project.

1. In a terminal, do `$ git clone git@github.com:eman6576/NFLDataSet.git`.
1. Then change the directory to NFLDataSet by doing `$ cd NFLDataSet`.
1. Build the project to install and complie dependencies by doing `$ swift build`.
1. To run the project, do `$ .build/debug/NFLDataSet`.

## Contributing

If you would like to contribute, please consult the [contributing guidelines](https://github.com/eman6576/NFLDataSet/blob/master/CONTRIBUTING.md) for details. Also check out the GitHub issues for major milestones/enhancements needed.

## License

NFLDataSet is released under the MIT license. [See LICENSE](https://github.com/eman6576/NFLDataSet/blob/master/LICENSE) for details.