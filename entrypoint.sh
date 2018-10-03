#!/bin/sh

if [ -z "${DATA_FILE}" ]; then
    mkdir -p /data
    DATA_FILE="/data/data.json"
fi 

# Parameters are preferred over ENVVAR
if [ $# -eq 2 ] || [ $# -eq 3 ]; then
    DATA_FILE=$1
    BOT_TOKEN=$2
    CHECK_INTERVAL=$3
elif [ $# -eq 1 ]; then
    BOT_TOKEN=$1
elif [ -z "${BOT_TOKEN}" ]; then
    echo "Error: BOT_TOKEN should be provided, by environment variables or parameters."
    echo ""
    echo "Usage sample:"
    echo "  General via ENVVAR:"
    echo "# docker run -d -e BOT_TOKEN=<BOT_TOKEN> [-e DATA_FILE=<DATA_FILE>] [-e CHECK_INTERVAL=<CHECK_INTERVAL>] tgimgrssbot"
    echo "  General via parameters:"
    echo "# docker run -d tgimgrssbot <BOT_TOKEN>"
    echo "  Interactive (for testing):"
    echo "# docker run -it --rm tgimgrssbot <BOT_TOKEN>"
    echo "  To expose(map) data file:"
    echo "# docker run -v $(pwd):/data -d tgimgrssbot /data/data.json <BOT_TOKEN> [<CHECK_INTERVAL>]"
    exit 1
fi

echo "DATA_FILE=${DATA_FILE}"
echo "BOT_TOKEN=${BOT_TOKEN}"
echo "CHECK_INTERVAL=${CHECK_INTERVAL}"

echo "Starting Bot (it is fine to see no output anymore)..."
exec rssbot "${DATA_FILE}" "${BOT_TOKEN}" "${CHECK_INTERVAL}"