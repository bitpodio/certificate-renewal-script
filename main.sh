#!/bin/bash
date_format='+%Y-%m-%d'
cert_name=bitpod-cert-$(date "$date_format")
echo "$cert_name"
gcloud auth activate-service-account cert-renew-patch-lb@bitpodtest.iam.gserviceaccount.com --key-file=/opt/certbot/dns/google.json --project=bitpodtest &&

certbot certonly \
  --dns-google \
  --dns-google-credentials /opt/certbot/dns/google.json \
  --dns-google-propagation-seconds 30 \
  $domains --register-unsafely-without-email --non-interactive --agree-tos &&

gcloud compute ssl-certificates create $cert_name --certificate /etc/letsencrypt/live/$CERT_PATH/fullchain.pem --private-key /etc/letsencrypt/live/$CERT_PATH/privkey.pem &&

gcloud compute target-https-proxies update bitpod-test-lb-target-proxy-3 --ssl-certificates $cert_name &&
gcloud compute target-https-proxies update bitpod-lb-production-target-proxy-2 --ssl-certificates $cert_name
