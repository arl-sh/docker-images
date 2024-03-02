#!/usr/bin/env bash

SESSION_ID=`uuidgen`
USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0'
URL_REGEX='href="(https://software\.download\.prss\.microsoft\.com/[^"]+)"'

# Necessary request otherwise Microsoft rejects the next query
curl -s "https://vlscppe.microsoft.com/tags?org_id=y6jn8c31&session_id=$SESSION_ID" -A "$USER_AGENT" -H 'Referer: https://www.microsoft.com/' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: iframe' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-site' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' > /dev/null
curl -s "https://www.microsoft.com/en-us/api/controls/contentinclude/html?pageId=a8f8f489-4c7f-463a-9ca6-5cff94d8d041&host=www.microsoft.com&segments=software-download%2cwindows11&query=&action=getskuinformationbyproductedition&sessionId=$SESSION_ID&productEditionId=2935&sdVersion=2" --compressed -X POST -A "$USER_AGENT" -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'X-Requested-With: XMLHttpRequest' -H 'Origin: https://www.microsoft.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://www.microsoft.com/software-download/windows11' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'TE: trailers' --data-raw 'controlAttributeMapping=' > /dev/null

# Fetch the HTML frame which contains the download link
HTML=`curl -s "https://www.microsoft.com/en-us/api/controls/contentinclude/html?pageId=6e2a1789-ef16-4f27-a296-74ef7ef5d96b&host=www.microsoft.com&segments=software-download%2cwindows11&query=&action=GetProductDownloadLinksBySku&sessionId=$SESSION_ID&skuId=17442&language=English&sdVersion=2" --compressed -X POST -A "$USER_AGENT" -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'X-Requested-With: XMLHttpRequest' -H 'Origin: https://www.microsoft.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://www.microsoft.com/software-download/windows11' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'TE: trailers' --data-raw 'controlAttributeMapping='`

if ! [[ "$HTML" =~ $URL_REGEX ]]
then
    echo 'Failed to fetch Windows 11 ISO download URL:' >&2
    echo "$HTML" >&2
    exit 1
fi

URL="${BASH_REMATCH[1]}"

curl -s -o Win11_English.iso "$URL"
