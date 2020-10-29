#!/bin/bash

SOURCE_WD=${2:-/opt/working_dir}

cp -R ${SOURCE_WD}/* $1
