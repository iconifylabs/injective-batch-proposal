#!/bin/bash

# CHANGE FROM WALLET

injectived tx wasm store ./cw_xcall_manager.wasm --from main --chain-id injective-888 --node https://injective-testnet-rpc.publicnode.com:443 --gas auto --gas-adjustment 1.5 --gas-prices 500000000inj  --yes
injectived tx wasm store ./cw_xcall_2.1.1.wasm --from main --chain-id injective-888 --node https://injective-testnet-rpc.publicnode.com:443 --gas auto --gas-adjustment 1.5 --gas-prices 500000000inj  --yes

injectived tx wasm store ./cw_hub_bnusd.wasm --from main --chain-id injective-888 --node https://injective-testnet-rpc.publicnode.com:443 --gas auto --gas-adjustment 1.5 --gas-prices 500000000inj  --yes
injectived tx wasm store ./cw_asset_manager.wasm --from main --chain-id injective-888 --node https://injective-testnet-rpc.publicnode.com:443 --gas auto --gas-adjustment 1.5 --gas-prices 500000000inj  --yes