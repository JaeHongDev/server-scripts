#!/bin/bash


./gradlew clean build -x test

# kill process
pgrep -f java | xargs kill -9




