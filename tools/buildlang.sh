#!/bin/bash

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

# This marker is needed for infra publishing
MARKER_TEXT="Project: $ZUUL_PROJECT Ref: $ZUUL_REFNAME Build: $ZUUL_UUID"

# upstream-training contains the HTML and slides contents

# build upstream-training slides
sphinx-build -j $NUMBER_OF_CORES -b gettext ${DIRECTORY}/source/slides \
    ${DIRECTORY}/source/locale/
# build upstream landing page index.html
sphinx-build -j $NUMBER_OF_CORES -b gettext ${DIRECTORY}/source/website \
    ${DIRECTORY}/source/locale/

# check all language translation resource
for locale in `find ${DIRECTORY}/source/locale/ -maxdepth 1 -type d` ; do
    # skip if it is not a valid language translation resource.
    if [ ! -e ${locale}/LC_MESSAGES/${DOCNAME}.po ]; then
        continue
    fi
    language=$(basename $locale)

    echo "Building $language translation"

    # prepare all translation resources
    for pot in ${DIRECTORY}/source/locale/*.pot ; do
        # get filename
        potname=$(basename $pot)
        resname=${potname%.pot}
        echo $resname
        # merge all translation resources
        msgmerge --silent -o \
            ${DIRECTORY}/source/locale/${language}/LC_MESSAGES/${resname}.po \
            ${DIRECTORY}/source/locale/${language}/LC_MESSAGES/${DOCNAME}.po \
            ${DIRECTORY}/source/locale/${potname}
        # compile all translation resources
        msgfmt -o \
            ${DIRECTORY}/source/locale/${language}/LC_MESSAGES/${resname}.mo \
            ${DIRECTORY}/source/locale/${language}/LC_MESSAGES/${resname}.po
    done

    # build translated guide
    # build upstream-training slides
    sphinx-build -j $NUMBER_OF_CORES -b slides -D language=${language} \
        -d "${DIRECTORY}/build/slides.doctrees" \
        ${DIRECTORY}/source/slides ${DIRECTORY}/build/slides/
    # build upstream landing page index.html
    sphinx-build -j $NUMBER_OF_CORES -b html -D language=${language} \
        -d "${DIRECTORY}/build/slides.doctrees" \
        ${DIRECTORY}/source/website ${DIRECTORY}/build/slides/

    # move built guide to publish directory
    mkdir -p publish-docs/${language}/${DOCNAME}/
    rsync -a ${DIRECTORY}/build/slides/ publish-docs/${language}/${DOCNAME}/
    echo $MARKER_TEXT > publish-docs/${language}/${DOCNAME}/.root-marker

    # remove newly created files
    git clean -f -q ${DIRECTORY}/source/locale/${language}/LC_MESSAGES/*.po
    git clean -f -x -q ${DIRECTORY}/source/locale/${language}/LC_MESSAGES/*.mo
    # revert changes to po file
    git reset -q ${DIRECTORY}/source/locale/${language}/LC_MESSAGES/${DOCNAME}.po
    git checkout -- ${DIRECTORY}/source/locale/${language}/LC_MESSAGES/${DOCNAME}.po
done

# remove newly created pot files
rm -f ${DIRECTORY}/source/locale/*.pot
