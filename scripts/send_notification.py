from brownie import accounts, config, interface

EPNS_ADDR = "0x87da9Af1899ad477C67FeA31ce89c1d2435c77DC"
# 50 Matic notification
IPFS_CID="bafybeicciwa4wkh7pfkcum7jgmpx7darblnmnjvccmdludc35bxorgugcm"

# identity: ${notification_type}+${IPFS CID}
IDENTITY = b"3" + b"+" + IPFS_CID.encode("utf-8")

def main(channel, recipient):
    me = accounts.add(config["wallets"]["from_key"])
    epns = interface.IEPNSComV1(EPNS_ADDR)
    tx = epns.sendNotification(channel, recipient, IDENTITY, {"from": me})
    print(tx)
