#!/bin/bash

source scripts/export_env.sh \
&& ./venv/bin/gunicorn app:app -b '127.0.0.1:8080' --access-logfile=- -w 4
