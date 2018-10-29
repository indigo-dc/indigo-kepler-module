#! /usr/bin/env python2
import sys
import xml.etree.ElementTree as ET

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Usage: pom-parser pom.xml')
        exit(1)

    ET.register_namespace('', 'http://maven.apache.org/POM/4.0.0')
    tree = ET.parse(sys.argv[1])
    root = tree.getroot()
    management = root.find('{http://maven.apache.org/POM/4.0.0}dependencyManagement')
    dependencies = management.find('{http://maven.apache.org/POM/4.0.0}dependencies')

    for dependency in dependencies.findall('{http://maven.apache.org/POM/4.0.0}dependency'):
        groupId = dependency.find('{http://maven.apache.org/POM/4.0.0}groupId')
        artifactId = dependency.find('{http://maven.apache.org/POM/4.0.0}artifactId')
        version = dependency.find('{http://maven.apache.org/POM/4.0.0}version')
        scope = dependency.find('{http://maven.apache.org/POM/4.0.0}scope')

        if scope is not None and scope.text == 'test':
            continue
        if artifactId.text == 'ptolemy' or artifactId.text == 'indigo-fg-api':
            continue

        print('        <dependency>')
        print('            <groupId>{}</groupId>'.format(groupId.text))
        print('            <artifactId>{}</artifactId>'.format(artifactId.text))
        print('            <version>{}</version>'.format(version.text))
        if scope is not None:
            print('            <scope>{}</scope>'.format(scope.text))
        print('        </dependency>')
        print('')
