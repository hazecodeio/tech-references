#!/bin/bash

#find ~/dev/api-calls-sandbox -type f -regex '.*.properties'| xargs cat
eval export `find ~/dev/api-calls-sandbox -type f -regex '.*.properties' | xargs cat`