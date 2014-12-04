#!/usr/bin/env bash

which landslide
LANDSLIDE_MISSING=$?

if [[ ${LANDSLIDE_MISSING} -ne 0 ]]; then
    echo "landslide isn't on your path.  Do you need to activate a virtual environment?"
    exit 1
fi

for presentation in *.rst; do
    presentation_name=$(basename "${presentation}" .rst)
    landslide -i -d "${presentation_name}.html" "${presentation}"
done
