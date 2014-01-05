#!/usr/bin/python
# -*- coding: utf-8 -*-

import os, sys
max_num = 900;
size = 88
source_dir = "../resource/photo/"
output_dir = "../resource/resized_photo/"

def resize():
    resize_command = "convert -resize '%dx' -resize 'x%d<' -resize '50%%' -gravity center -crop '%dx%d+0+0'" % (size * 2, size * 2, size, size)
    for i in range(0, max_num):
        if os.path.isfile("%s%03d.jpg" % (source_dir, i)):
            sys.stdout.write("\r%03d" % i)
            sys.stdout.flush()
            command_str = "%s %s%03d.jpg %s%03d.png" % (resize_command, source_dir, i, output_dir, i)
            os.system(command_str)
    print "\ndone"
if __name__ == "__main__":
    resize()
