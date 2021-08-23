#!/bin/bash

gcloud auth activate-service-account cert-renew-patch-lb@bitpodtest.iam.gserviceaccount.com --key-file=/opt/certbot/dns/google.json --project=bitpodtest &&

certbot certonly \
  --dns-google \
  --dns-google-credentials /opt/certbot/dns/google.json \
  --dns-google-propagation-seconds 30 \
  -d *.star.workpay.io \
  -d *.mvc.workpay.io --register-unsafely-without-email --non-interactive --agree-tos &&

gcloud compute ssl-certificates create bitpod-cert-$(printf '%(%Y-%m-%d)T\n' -1) --certificate /etc/letsencrypt/live/$CERT_PATH/fullchain.pem --private-key /etc/letsencrypt/live/$CERT_PATH/privkey.pem &&

gcloud compute target-https-proxies update bitpod-test-lb-target-proxy-3 --ssl-certificates bitpod-cert-$(printf '%(%Y-%m-%d)T\n' -1)
