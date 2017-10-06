#! /bin/bash
branch=${1:-master}
maindir=$(readlink -f $(dirname $0))

tmpdir=$(mktemp --directory)
gitdir=$(mktemp --directory)

cd "${tmpdir}"
mkdir module-info
mkdir resources
mkdir src

git clone\
    --branch "${branch}"\
    --single-branch\
    https://github.com/indigo-dc/indigoclient "${gitdir}/indigoclient"
git clone\
    --branch "${branch}"\
    --single-branch\
    https://github.com/indigo-dc/indigokepler "${gitdir}/indigokepler"

rsync --archive\
    "${gitdir}/indigoclient/src/main/resources/"\
    "${gitdir}/indigokepler/src/main/resources/"\
    resources/
rsync --archive\
    "${gitdir}/indigoclient/src/main/java/"\
    "${gitdir}/indigokepler/src/main/java/"\
    src/

cat << EOF > module-info/pom.xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>pl.psnc.indigo</groupId>
    <artifactId>indigo-fg-actors</artifactId>
    <version>${branch#v}</version>
    <packaging>jar</packaging>

    <prerequisites>
        <maven>3.0</maven>
    </prerequisites>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <batik.version>1.7</batik.version> <!-- 1.7 is required by Kepler -->
        <jackson.version>2.8.6</jackson.version>
    </properties>

    <dependencies>
$("${maindir}/pom-parser.py" "${gitdir}/indigoclient/pom.xml")
$("${maindir}/pom-parser.py" "${gitdir}/indigokepler/pom.xml")
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
