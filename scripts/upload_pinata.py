import os
import pdb
import sys
import requests
import json
import logging

logger = logging.getLogger("upload_pinata")

try:
    PINATA_API_KEY = os.environ["PINATA_API_KEY"]
except KeyError:
    logger.error("PINATA_API_KEY must be defined in your environment")
    sys.exit(42)
try:
    PINATA_SECRET_API_KEY = os.environ["PINATA_SECRET_API_KEY"]
except KeyError:
    logger.error("PINATA_SECRET_API_KEY must be defined in your environment")
    sys.exit(42)


def upload_ipfs(body, name=None):
    headers = {
        "pinata_api_key": f"{PINATA_API_KEY}",
        "pinata_secret_api_key": f"{PINATA_SECRET_API_KEY}",
    }
    url = "https://api.pinata.cloud/pinning/pinJSONToIPFS"
    logger.info("POST to pinata")
    if name is not None:
        data = {
            "pinataMetadata": {"name": name},
            "pinataContent": body,
        }
    else:
        data = body
    resp = requests.post(url, json=data, headers=headers)
    ret = resp.json()
    return ret


def main(filepath):
    if not os.path.isfile(filepath):
        logger.error(f"{filepath} need to be a file")
        sys.exit(2)
    with open(filepath, "r") as f:
        payload = f.read()
    try:
        body = json.loads(payload)
    except json.JSONDecodeError:
        logger.error(f"Failed to parse {filepath}")
        sys.exit(3)
    name = os.path.basename(filepath)
    data = upload_ipfs(body, name)
    print(f"CID: {data['IpfsHash']}")
