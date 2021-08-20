#!/bin/bash

gcloud auth activate-service-account cert-renew-patch-lb@bitpodtest.iam.gserviceaccount.com --key-file=/opt/certbot/dns/google.json --project=bitpodtest

certbot certonly \
  --dns-google \
  --dns-google-credentials /opt/certbot/dns/google.json \
  --dns-google-propagation-seconds 30 \
  -d *.gfive.workpay.io \
  -d *.lcv.workpay.io

gcloud compute ssl-certificates create mynewcert --certificate /etc/letsencrypt/live/gfive.workpay.io/fullchain.pem --private-key /etc/letsencrypt/live/gfive.workpay.io/privkey.pem

gcloud compute target-https-proxies update bitpod-test-lb-target-proxy-3 --ssl-certificates mynewcert

gcloud compute target-https-proxies update bitpod-lb-production-target-proxy-2 --ssl-certificates mynewcert