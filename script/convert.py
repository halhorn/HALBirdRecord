#!/usr/bin/python
# -*- coding: utf-8 -*-

import re
import urllib
import os, sys

dataFile = "WikiRawData.txt"
outFile = "../HALBirdRecord/Data/BirdKind.plist"
imgDir = "../resource/photo/"
groupPattern = re.compile(r'<h3>.*>([^<>]*科)')
foreignPattern = re.compile(r'<h2>.*(外来種)')
birdPattern = re.compile(r'<li><a[^<>]*href="([^"]*)"[^<>]*>([^<>]*)</a>.*</li>')
birdImagePattern = re.compile(r'<a[^<>]href="([^"]+)"[^<>]+>\s*<img[^<>]* src="([^"]+\.(jpg|jpeg|JPG|JPEC))"')
licensePatterns = [
    re.compile(r'このファイルは(.+)の(もと|下)に?利用を許諾されています。'),
    re.compile(r'(パブリック.?ドメイン)'),
    re.compile(r'(public.domain)'),
    re.compile(r'(GNU Free Documentation License</a></b> に示されるバージョン[^<>]+(またはそれ以降)?)のライセンスの下提供されています'),
    re.compile(r'>(Creative.?Commons</a>\s?<a[^<>]+>[^<>]+</a>\s?License)'),
    re.compile(r'>\s*([^<>]+)License'),
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
            if url and not url.startswith("http"):
                url = "http://ja.wikipedia.org" + url
            license = "";
            if int(birdID) >= imgFetchStart:
                license = getImage(url, birdID)
            bird.append({"BirdID":birdID, "Name":birdMatch.group(2), "Url":url, "DataCopyRight":license})
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
    if license:
        return license + " - " + licensePageUrl
    else:
        return licensePageUrl

def getImageLicense(url):
    imgPage = urllib.urlopen(url)
    html = imgPage.read()
    html = html.replace('&#160;', ' ')
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
				<key>Url</key>
				<string>%s</string>
				<key>Comment</key>
				<string></string>
				<key>DataCopyRight</key>
				<string>%s</string>
			</dict>
""" % (bird["BirdID"], bird["Name"], bird["Url"], bird["DataCopyRight"])
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
