#!/bin/bash

#find ~/dev/api-calls-sandbox -type f -regex '.*.properties'| xargs cat
eval export `find ../ -type f -regextype posix-extended -regex "^(../|./|/).*(_env-)*.properties$" | xargs cat`