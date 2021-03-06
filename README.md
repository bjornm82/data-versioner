# Data versioner

## Data versioning

This project allows to couple data, models and code in a central place. By having
this functionality it's possible to reproduce the exact state of steps based on
explicit versions.

| Entity        | Variant | Variant | Variant |
| ------------- | :-----: | :-----: | :-----: |
| Code          | v1      | v2      | v1      |
| Data          | v1      | v1      | v2      |
| Model         | v1      | v2      | v3      |

The model output will be tracked in order to have the ability to validate and debug
the outcome of a model in combination with the code and data so the will follow
the next notion `Code + Data = Model`, whereas the code is always leading.

### The goal
As this project fully depends on the notion of event sourcing system of Git and
external storage of S3 (or MinIO). Abilities and under the hood.

**Write**

Metadata will be stored in the `data-version-repo` with extended the `branch` and
`git commit hash --short` of the repository the data is being produced e.g.

Structure of `data-version-repo`:
```
.
├── README.md
└── rtlnl
    ├── project_a
    │   ├── master-47b8305
    │   │   ├── Dvcfile
    │   │   ├── preprocessed_data.xml.dvc
    │   │   └── model.h5.dvc
    │   └── develop-8c9b659
    │       ├── Dvcfile
    │       ├── data.xml.dvc
    │       └── model.h5.dvc
    └── project_b
        └── master-554c276
            ├── Dvcfile
            ├── preprocessed_data.xml.dvc
            └── model.h5.dvc
```
Structure of data on S3:
```
{s3-bucket}/rtlnl/project_a/master/47b8305/preprocessed_data.xml
{s3-bucket}/rtlnl/project_a/master/47b8305/model.h5
{s3-bucket}/rtlnl/project_a/develop/8c9b659/data.xml
{s3-bucket}/rtlnl/project_a/develop/8c9b659/model.h5
{s3-bucket}/rtlnl/project_b/master/554c276/preprocessed_data.xml
{s3-bucket}/rtlnl/project_b/master/554c276/model.h5
```

* Input data mounted to /tmp folder
* Arguments provided for the repository which is correlated project
* git rev-parse to obtain the complete git commit hash from short hash
* Check if the repo directory

**Read**

## Getting started

### Concept

The data versioner depends on two types of tooling, [DVC](https://dvc.org/) and
[Git](https://git-scm.com/). By passing data to the data versioner, it would
version the data by committing metadata to a Git Repository and stores the data
to a remote storage (e.g. s3 or MinIO bucket. All data stored should be tightly
coupled around the code written and followed by the data being used either as input (deps) or output (outs).

### Usage

1. The image
Within your CI pipeline while storing the docker image, it's preferred to register
the docker image itself within the data versioner. The docker image can be stored
via the docker command `$ docker save {account}/{repo} > ./{name}.tar`.
Depending on the size of the image this could take a couple of minutes. Within
the repository of choice (after SSH key has been added), the data versioning
service will automatically store the data to the S3 location which is based of
the git commit of the code and created a structure as following:

E.G. the versioning repository {account}/{repo}:master would have a folder structure
based on the code of the model written (e.g. model-a is the repository).
```
.
├── .dvc
├── .git
├── .gitignore
├── model-a
│   ├── .dvc
│   ├── .git
│   ├── .gitignore
│   ├── Dvcfile
│   └── data
│       └── data.xml.dvc
└── model-b
    ├── .dvc
    ├── .git
    ├── .gitignore
    ├── Dvcfile
    └── model
         └── model.xml.dvc
```

2. The data and model
Both data and the model are treated the same. Each step of the pipeline you could
add physical data to the data versioner together with the git commit of the code
running. Data could be either an input and output for a specific step in the
pipeline. In between and at both beginning and ending of each step of the pipeline
there should be a moment which allows to let the data versioner controlling the
data versions.

### Getting started

Build the docker image
`$ make build`

Push the docker image to the
`$ make push`

Run the service which will expose port 2020 in order to communicate
`$ make run -p 2020:2020 {account}/data-versioner:latest`
