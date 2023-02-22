#!/usr/bin/env bash
#
SEARX=~/.local/repositories/
cd $SEARX

# clone searx repository
git clone https://github.com/asciimoo/searx
# cd into it
cd searx
# create virual environment
python3 -mvenv env

. env/bin/activate
# upgrade pip
pip install --upgrade pip
# Further dependencies
pip install -r requirements.txt

# Edit the settings.yml file to add secure key and new name.
sed -i -e "s/ultrasecretkey/$(openssl rand -hex 16)/g" "$SEARX/settings.yml"
sed -i -e "s/{instance_name}/br5/g" "$SEARX/settings.yml"

# Install supporting programs
sudo -H apt-get install -y \
    python3-dev python3-babel python3-venv \
    uwsgi uwsgi-plugin-python3 \
    git build-essential libxslt-dev zlib1g-dev libffi-dev libssl-dev \
    shellcheck
    #
# Install uwsgi
pip install uwsgi


