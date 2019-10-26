# MPs activity

## Setup

Getting the data was done using Javascript. Analysis done in R.

### Javascript

Packages used are in `package.json`. To install them run `npm install` in the root of this repository.

Make sure to have `node` installed (13.0.1).

### R

R version used is . All analysis is done using tidyverse packages. To install these packages run the following in the R console:

```
install.packages("tidyverse")
```

`tidyverse` version `1.2.1` is used. I'm aware it would be better to use a package manager like [packrat](https://rstudio.github.io/packrat/) just as `npm` is used in Javascript or `pip` in Python. However I didn't find the time to read up on it yet.

## Run

commission-meetings.csv:

```
node save-commission-meetings
```

commission-members.csv:

```
node save-commission-members
````

## Folder structure

Big fan of everyting in one folder till it's clear what structure is appropriate. As long as it doesn't become a hindrance I keep it like that.

## TO DO

Remove header code in `write-to-csv.js` since it's not used anyway in writing. A header line will not be written to the file if true is given [for append](https://www.npmjs.com/package/csv-writer).