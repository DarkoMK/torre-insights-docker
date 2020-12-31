#!/bin/sh
echo "yes" | php /src/artisan migrate
php /src/artisan serve --host=0.0.0.0
