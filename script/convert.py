#!/usr/bin/python
# -*- coding: utf-8 -*-

import re
import urllib
import os

dataFile = "WikiRawData.txt"
outFile = "../HALBirdRecord/Data/BirdKind.plist"
imgDir = "./photo/"
groupPattern = re.compile(r'<h3>.*>([^<>]*科)')
foreignPattern = re.compile(r'<h2>.*(外来種)')
birdPattern = re.compile(r'<li><a[^<>]*href="([^"]*)"[^<>]*>([^<>]*)</a>.*</li>')
birdImagePattern = re.compile(r'<img[^<>]* src="([^"]+\.(jpg|jpeg|JPG|JPEC))"');

def convert():
    data = read()
    output(data)
    print "Done."

def read():
    data = []
    bird = []
    groupID = 1;
    birdID = 1;
    for line in open(dataFile):
        line = line.rstrip()
        groupMatch = groupPattern.search(line) or foreignPattern.search(line)
        birdMatch = birdPattern.search(line)
        # グループ
        if groupMatch:
            bird = []
            data.append({"GroupID":groupID, "GroupName":groupMatch.group(1), "BirdList":bird})
            print "%d: %s" % (groupID, groupMatch.group(1))
            groupID += 1
        # 鳥の種類
        if birdMatch:
            url = birdMatch.group(1)
            getImage('http://ja.wikipedia.org' + url, birdID)
            bird.append({"BirdID":birdID, "Name":birdMatch.group(2), "DataCopyRight":"wikipedia"})
            print "  %d: %s" % (birdID, birdMatch.group(2))
            birdID += 1
    return data

def getImage(url, birdID):
    birdPage = urllib.urlopen(url)
    html = birdPage.read()
    imgMatch = birdImagePattern.search(html)
    if not imgMatch:
        print "No Image"
        return
    path = imgMatch.group(1)
    url = 'http:' + path
    saveFilePath = "%s%03d.jpg" % (imgDir, birdID)
    urllib.urlretrieve(url, saveFilePath)
    print saveFilePath

def output(data):
    tmp = ""
    for group in data:
        tmp += """	<dict>
		<key>GroupID</key>
		<integer>%d</integer>
		<key>GroupName</key>
		<string>%s</string>
		<key>BirdList</key>
		<array>
""" % (group["GroupID"], group["GroupName"])
        for bird in group["BirdList"]:
            tmp += """			<dict>
				<key>BirdID</key>
				<integer>%d</integer>
				<key>Name</key>
				<string>%s</string>
				<key>Image</key>
				<string></string>
				<key>Comment</key>
				<string></string>
				<key>DataCopyRight</key>
				<string>%s</string>
			</dict>
""" % (bird["BirdID"], bird["Name"], bird["DataCopyRight"])
        tmp += """		</array>
	</dict>
"""
    out = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
%s
</array>
</plist>
""" % tmp
    f = open(outFile, "w")
    f.write(out)

if __name__ == "__main__":
    convert()
