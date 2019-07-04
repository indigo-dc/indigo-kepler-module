#! /bin/bash
branch=${1:-master}
maindir=$(readlink -f $(dirname $0))

gitdir=$(mktemp --directory)
git clone\
    --branch "${branch}"\
    --single-branch\
    https://github.com/indigo-dc/indigo-parent "${gitdir}/indigo-parent"
cd "${gitdir}/indigo-parent"
git submodule update --init

tmpdir=$(mktemp --directory)
cd "${tmpdir}"
mkdir module-info
mkdir resources
mkdir src

rsync --archive\
    "${gitdir}/indigo-parent/indigoclient/src/main/resources/"\
    "${gitdir}/indigo-parent/indigokepler/src/main/resources/"\
    resources/
rsync --archive\
    "${gitdir}/indigo-parent/indigoclient/src/main/java/"\
    "${gitdir}/indigo-parent/indigokepler/src/main/java/"\
    src/

cat << EOF > module-info/pom.xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>pl.psnc.indigo</groupId>
    <artifactId>indigo-fg-actors</artifactId>
    <version>${branch#v}</version>
    <packaging>jar</packaging>

    <properties>
      <batik.version>1.7</batik.version> <!-- required by Kepler -->
      <jackson.version>2.9.9</jackson.version>
      <powermock.version>1.7.4</powermock.version>
      <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
      <testcase.groups>pl.psnc.indigo.fg.api.restful.category.UnitTests</testcase.groups>
      <xml-apis.version>1.3.04</xml-apis.version>
    </properties>

    <dependencies>
$("${maindir}/pom-parser.py" "${gitdir}/indigo-parent/pom.xml")
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-dependency-plugin</artifactId>
                <version>3.0.0</version>
                <configuration>
                    <outputDirectory>\${basedir}/../lib/jar/</outputDirectory>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOF

find "${gitdir}" -delete
echo "${tmpdir}"
