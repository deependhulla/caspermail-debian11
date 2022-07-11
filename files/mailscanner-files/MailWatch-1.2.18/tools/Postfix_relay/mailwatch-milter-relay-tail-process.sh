#!/bin/bash

# @asuweb
## updated new Code  by -Deepen with maillog-import-for-delivery.php
if ps -C php -o args h | grep maillog-import-for-delivery.php
then true ## maillog-import-for-delivery.php running
else /usr/bin/php -q /usr/local/bin/maillog-import-for-delivery.php > /dev/null &
fi

if ps -C php -o args h | grep mailwatch_milter_relay.php
then true ## mailwatch_milter_relay.php running
else /usr/bin/php -q /usr/local/bin/mailwatch_milter_relay.php > /dev/null &
fi

