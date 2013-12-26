#!/usr/bin/python
# -*- coding: utf-8 -*-

import re
import urllib
import os, sys

dataFile = "WikiRawData.txt"
outFile = "../HALBirdRecord/Data/BirdKind.plist"
imgDir = "./photo/"
groupPattern = re.compile(r'<h3>.*>([^<>]*科)')
foreignPattern = re.compile(r'<h2>.*(外来種)')
birdPattern = re.compile(r'<li><a[^<>]*href="([^"]*)"[^<>]*>([^<>]*)</a>.*</li>')
birdImagePattern = re.compile(r'<a[^<>]href="([^"]+)"[^<>]+>\s*<img[^<>]* src="([^"]+\.(jpg|jpeg|JPG|JPEC))"')
licensePatterns = [
    re.compile(r'このファイルは(.+)の(もと|下)に?利用を許諾されています。'),
    re.compile(r'(パブリックドメイン)</a></b>とされました。'),
    re.compile(r'(GNU Free Documentation License</a></b> に示されるバージョン[^<>]+(またはそれ以降)?)のライセンスの下提供されています'),
    re.compile(r'この作品の権利を放棄し<b><a [^<>]+>(パブリックドメイン)</a></b>とします。'),
    re.compile(r'(?:the image|such work) is in the <b><a [^<>]+>(public domain)</a></b>')
]

def convert(imgFetchStart):
    data = read(imgFetchStart)
    output(data)
    print "Done."

def read(imgFetchStart):
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
            if int(birdID) >= imgFetchStart:
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
    licensePageUrl = 'http://ja.wikipedia.org' + imgMatch.group(1)
    license = getImageLicense(licensePageUrl)
    if not license:
        print "No license at %s" % licensePageUrl
        return
    print license
    path = imgMatch.group(2)
    url = 'http:' + path
    saveFilePath = "%s%03d.jpg" % (imgDir, birdID)
    urllib.urlretrieve(url, saveFilePath)

def getImageLicense(url):
    imgPage = urllib.urlopen(url)
    html = imgPage.read()
    license = ''
    for pattern in licensePatterns:
        licenseMatch = pattern.search(html)
        if licenseMatch:
            license = re.sub(r'<[^<>]*>', '', licenseMatch.group(1))
            break
    return license

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
    convert(int(sys.argv[1]))
