#!/bin/bash

KIBANA="http://lsys-kibana:5601"
RETRY_COUNT=0

while [ $RETRY_COUNT -lt 30 ]; do
    LEVEL=$(curl -s "$KIBANA/api/status" |grep -o '"level":"[^"]*"' |cut -d '"' -f4 |head -1)
    if [ "$LEVEL" = "available" ]; then
        echo "kibana running"
        break
    else
        echo "kibana is starting"
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    sleep 5
done

sleep 10

RETRY_COUNT=0

while [ $RETRY_COUNT -lt 30 ]; do
    RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" -X POST "$KIBANA/api/saved_objects/_import?overwrite=true" -H "kbn-xsrf: true" --form file=@/data/init.ndjson)

    HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE" | cut -d':' -f2)
    BODY=$(echo "$RESPONSE" | sed '/HTTP_CODE/d')

    if [ "$HTTP_CODE" = "200" ]; then
        echo "import completed successfully"
        echo "$BODY"
        break
    elif [ "$HTTP_CODE" = "503" ]; then
        echo "import failure with HTTP code: $HTTP_CODE"
        echo "Retrying due to service being unavailable..."
        sleep 10
    else
        echo "import failure with HTTP code: $HTTP_CODE"
        echo "$BODY"
        exit 1
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))    
done
