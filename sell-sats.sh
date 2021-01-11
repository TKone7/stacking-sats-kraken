#/bin/sh
set -e
export NODE_OPTIONS="--no-deprecation"

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR
if [ $TEST = 1 ]; then
	result=$(npm run test:sell-sats 2>&1)
else
	result=$(npm run sell-sats 2>&1)
fi
echo $result
