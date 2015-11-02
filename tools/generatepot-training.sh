#!/bin/bash -xe

#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

DOCNAME=upstream-training
DIRECTORY=doc/${DOCNAME}

if [ -x "$(command -v getconf)" ]; then
    NUMBER_OF_CORES=$(getconf _NPROCESSORS_ONLN)
else
    NUMBER_OF_CORES=2
fi

# First remove the old pot file, otherwise the new file will contain
# old references

rm -f ${DIRECTORY}/source/locale/$DOCNAME.pot

# upstream-training contains the HTML and slides contents

sphinx-build -j $NUMBER_OF_CORES -b html -b gettext ${DIRECTORY}/ \
    ${DIRECTORY}/source/locale/
sphinx-build -j $NUMBER_OF_CORES -b slides -b gettext ${DIRECTORY}/source/ \
    ${DIRECTORY}/source/locale/

# Take care of deleting all temporary files so that
# "git add ${DIRECTORY}/source/locale" will only add the
# single pot file.
# Remove UUIDs, those are not necessary and change too often
msgcat --use-first --sort-by-file ${DIRECTORY}/source/locale/*.pot | \
    awk '$0 !~ /^\# [a-z0-9]+$/' > ${DIRECTORY}/source/$DOCNAME.pot
rm  ${DIRECTORY}/source/locale/*.pot
rm -rf ${DIRECTORY}/source/locale/.doctrees/
mv ${DIRECTORY}/source/$DOCNAME.pot ${DIRECTORY}/source/locale/$DOCNAME.pot
