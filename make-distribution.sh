#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

usage ()
{
    echo "Usage: $0 [-h|--help]"
    echo ""
    echo "  -h|--help    Show usage"
}

JAVA_PROPS=()

for i in "$@"
do
case $i in
    -h|--help)
    usage
    shift
    exit
    ;;
    -D*)
    JAVA_PROPS+=("$i")
    shift
    ;;
    *)
    usage
    exit 1
    ;;
esac
done

FWDIR="$(cd `dirname $0`; pwd)"
DISTDIR="${FWDIR}/dist"

VERSION=$(grep ^version ${FWDIR}/build.sbt | grep ThisBuild | grep -o '".*"' | sed 's/"//g')

echo "Building binary distribution for PredictionIO $VERSION..."

sbt/sbt printBuildInfo

cd ${FWDIR}
sbt/sbt "$JAVA_PROPS" publishLocal assembly

cd ${FWDIR}
rm -rf ${DISTDIR}
mkdir -p ${DISTDIR}/bin
mkdir -p ${DISTDIR}/conf
mkdir -p ${DISTDIR}/lib
mkdir -p ${DISTDIR}/lib/spark
mkdir -p ${DISTDIR}/project

mkdir -p ${DISTDIR}/sbt

cp ${FWDIR}/bin/* ${DISTDIR}/bin || :
cp ${FWDIR}/conf/* ${DISTDIR}/conf
cp ${FWDIR}/project/build.properties ${DISTDIR}/project
cp ${FWDIR}/sbt/sbt ${DISTDIR}/sbt
cp ${FWDIR}/assembly/*assembly*jar ${DISTDIR}/lib
cp ${FWDIR}/assembly/spark/*jar ${DISTDIR}/lib/spark

rm -f ${DISTDIR}/lib/*javadoc.jar
rm -f ${DISTDIR}/lib/*sources.jar
rm -f ${DISTDIR}/conf/pio-env.sh
mv ${DISTDIR}/conf/pio-env.sh.template ${DISTDIR}/conf/pio-env.sh

touch ${DISTDIR}/RELEASE

TARNAME="PredictionIO-$VERSION.tar.gz"
TARDIR="PredictionIO-$VERSION"
cp -r ${DISTDIR} ${TARDIR}

tar zcvf ${TARNAME} ${TARDIR}
rm -rf ${TARDIR}

echo -e "\033[0;32mPredictionIO binary distribution created at $TARNAME\033[0m"
