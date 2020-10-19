#!/bin/sh


build/ARM/gem5.opt --debug-flags=FI configs/example/se.py -c /home/zl/work/gem5-19.0.0.0/tests/test-progs/hello/src/hello-arm-s
result=$?
echo $result
