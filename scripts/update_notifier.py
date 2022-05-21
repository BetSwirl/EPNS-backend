#!/usr/bin/env python

from brownie import (
    Notifier,
    TransparentUpgradeableProxy,
    ProxyAdmin,
    config,
    network,
    Contract,
)
from scripts.helpful_scripts import get_account, encode_function_data, upgrade


def main():
    account = get_account()
    notifier = Notifier.deploy({"from": account})
    proxy = TransparentUpgradeableProxy[-1]
    proxy_admin = ProxyAdmin[-1]

    upgrade(
        account,
        proxy,
        notifier,
        proxy_admin_contract=proxy_admin,
    )
    print("Proxy has been upgraded")
    proxy_notifier = Contract.from_abi("Notifier", proxy, Notifier.abi)
    print(f"CID: {proxy_notifier.identity(2)}")
