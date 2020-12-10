---
title: 'Rdataretriever: R Interface to the Data Retriever'
tags:
  - data retrieval, data processing, R, data, data science, datasets
authors:
 - name: Henry Senyondo
   orcid: 0000-0001-7105-5808
   affiliation: 1
 - name: Daniel J. McGlinn
   orcid: 0000-0003-2359-3526
   affiliation: 2
 - name: Pranita Sharma
   affiliation: 3
   orcid: 0000-0002-5871-380X
 - name: David J. Harris
   affiliation: 1
   orcid: 0000-0003-3332-9307
 - name: Hao Ye
   affiliation: 4
   orcid: 0000-0002-8630-1458
 - name: Shawn D. Taylor
   affiliation: "1, 5"
   orcid: 0000-0002-6178-6903
 - name: Jeroen Ooms
   affiliation: 6
   orcid: 0000-0002-4035-0289
 - name: Francisco Rodríguez-Sánchez
   affiliation: 7
   orcid: 0000-0002-7981-1599
 - name: Karthik Ram
   affiliation: 6
   orcid: 0000-0002-0233-1757
 - name: Apoorva Pandey
   affiliation: 8
   orcid: 0000-0001-9834-4415
 - name: Harshit Bansal
   affiliation: 9
   orcid: 0000-0002-3285-812X
 - name: Max Pohlman
   affiliation: 10
 - name: Ethan P. White
   affiliation: "1, 11, 12"
   orcid: 0000-0001-6728-7745


affiliations:
 - name: Department of Wildlife Ecology and Conservation, University of Florida
   index: 1
 - name: Department of Biology, College of Charleston
   index: 2
 - name: North Carolina State University, Department of Computer Science
   index: 3
- name: Health Science Center Libraries, University of Florida
   index: 4
 - name: USDA-ARS Jornada Experimental Range
   index: 5
 - name: Berkeley Institute for Data Science, University of California, Berkeley
   index: 6
 - name: Department of Agricultural Economics, Sociology, and Education, Penn State University
   index: 7
 - name: Department of Electronics and Communication, Indian Institute of Technology, Roorkee
   index: 8
 - name: Ajay Kumar Garg Engineering College, Ghaziabad
   index: 9
 - name: Departamento de Biología Vegetal y Ecología, Universidad de Sevilla. 
   index: 10
 - name: Informatics Institute, University of Florida
   index: 11
 - name: Biodiversity Institute, University of Florida
   index: 12

date: 16 September 2020 
bibliography: paper.bib
---

# rdataretriever: An R package for downloading, cleaning, and installing publicly available datasets

## Summary

The rdataretriever provides an R interface to the Python-based Data Retriever software. The Data Retriever automates the multiple steps of data analysis including downloading, cleaning, standardizing, and importing datasets into a variety of relational databases and flat file formats. It also supports provenance tracking for these steps of the analysis workflow by allowing datasets to be committed at the time of installation and allowing them to be reinstalled with the same data and processing steps in the future. Finally, it supports the installation of spatial datasets into relational databases with spatial support. The rdataretriever provides an R interface to this functionality and also supports importing of datasets directly into R for immediate analysis. The system also supports the use of custom data processing routines to support complex datasets that require custom data manipulation steps. The Data Retriever and rdataretriever are focused on scientific data applications including a number of widely used, but difficult to work with, datasets in ecology and the environmental sciences.

## Statement of Need

Finding, cleaning, standardizing, and importing data into efficient data structures for modeling and visualization represents a major component of most research workflows. This is a time-consuming process for researchers even when working with relatively simple datasets. For more complex datasets, these steps can be so complex as to prevent domain experts from engaging with the dataset at all. Systems that operate like package managers for scientific data can overcome these barriers, allowing researchers to move quickly to the final steps in the data analysis workflow (visualization and modeling) and allowing domain experts to leverage the most complex data appropriate to their research questions. The rdataretriever allows R users to automatically conduct these early steps of the analysis workflow for over 200 datasets including a number of the most widely used and difficult to work with datasets in the environmental sciences including the North American Breeding Bird Survey and the Forest Inventory and Analysis datasets. This actively facilitates research on important ecological and environmental questions that would otherwise be limited.

## Implementation

The main Data Retriever software is written in Python [@Morris2013], [@Senyondo2017]. The rdataretriever allows R users to access this data processing workflow through a combination of the reticulate package [@reticulate] and custom features developed for working in R [@R]. Because many R users, including the domain researchers most strongly supported by this package, are not familiar with Python and its package management systems, a strong emphasis has been placed on simplifying the installation process for this package so that it can be done entirely from R. Installation requires no direct use of Python or the command line. Detailed documentation has been developed to support users in both installation and use of the software. A Docker-based testing system and associated test suite has also been implemented to ensure that the interoperability of the R package and Python package are maintained, which is challenging due to frequent changes in reticulate and complexities in supporting cross-language functionality across multiple operating systems (Windows, Mac OS, Linux) and R programming environments (terminal-based R and RStudio).

For tabular datasets requiring relatively simple workflows the software uses the JSON based Frictionless Data tabular data metadata package standard [@frictionlessdata_specs]. For more complex data processing workflows, custom Python code is used to process the data into cleaned and standardized formats. Spatial data support is available for PostgreSQL using PostGIS. The information required for handling these datasets is based on a customized version of the Frictionless Data Geo Data schema [@frictionlessdata_specs] that also supports raster datasets.

## Acknowledgements

Development of this software was funded by the Gordon and Betty Moore Foundation's Data-Driven Discovery Initiative through Grant GBMF4563 to Ethan White and the National Science Foundation CAREER Award 0953694 to Ethan White.

## References

