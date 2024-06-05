# Base image
FROM willhallonline/ansible:2.8-alpine-3.10 as base

#needed for azure_rm
RUN apk add build-base python3-dev libffi-dev
COPY requirements-ansible.txt /ansible/
RUN apk add curl --no-cache \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py \
    && rm get-pip.py \
    && apk del curl --no-cache \
    && pip install --upgrade pip
RUN pip install -r requirements-ansible.txt
RUN pip install jmespath

COPY roles /usr/share/ansible/roles
