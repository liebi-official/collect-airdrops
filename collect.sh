# !/bin/sh
# 
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. 
# By liebi.com
#

# Configuration
#
node="https://api.eosnewyork.io"										# Node peer
wallet_pass="PW5KPH5NpCCxxc54axSSsdfajDSFSDqNhvASdu2UAQ6QfkL1Be7WPX" 	# Wallet password (recommended: Temporary wallet)
wallet_name="collect-wallet" 											# Wallet name (recommended: Temporary wallet)
collect_account="collectacct1" 											# Receive transfer account
airdrop_contract="eosio.token" 											# Airdrop token contract name
airdrop_symbol="EOS" 													# Airdrop token symbol


# Unlock Wallet
#	- Unlock your temporary eos wallet
#
function unlockWallet()
{
	alias cleos-collect="/usr/local/bin/cleos -u ${node}"
	echo $wallet_pass | cleos-collect wallet unlock -n $wallet_name
}

# Clear Private Key
#	- Empty the environment to prepare for this collection
#	- When you use the script and the parameters is `clear`, the previously imported private key will be cleared
#	- Do not pass this parameter when you are not sure
#
#	- Example: `sh collect.sh clear`
#
function clearPrivateKey()
{
	public_key=$(cleos-collect wallet keys | python -c "import json, sys; [sys.stdout.write(x + '\n') for x in json.load(sys.stdin)]")
	for public in `echo ${public_key}`
	do
		cleos-collect wallet remove_key $public -n $wallet_name --password $wallet_pass
	done
}

# Import Private Key
#	- Import a private key from `private_key` file
#	- All accounts associated with these private keys will transfer the specified currency to collect account
#
function importPrivateKey()
{
	cat private_key | while read private
	do
		echo $private | cleos-collect wallet import -n $wallet_name
	done
}

# Collect Airdrops
#	- Query all associated accounts from the private key you imported, check the account balance and transfer to collect account
#
function transferAirdrop()
{
	public_key=$(cleos-collect wallet keys | python -c "import json, sys; [sys.stdout.write(x + '\n') for x in json.load(sys.stdin)]")

	total_amount=0
	for public in `echo ${public_key}`
	do
		account=$(cleos-collect get accounts ${public} | python -c "import json, sys; [sys.stdout.write(account + '\n') for account in json.load(sys.stdin)['account_names']]")
		if [ $account ]
		then
			balance=$(cleos-collect get currency balance ${airdrop_contract} ${account} ${airdrop_symbol})

			if [ "$balance" ]
			then
				transfer=$(cleos-collect transfer ${account} ${collect_account} "$balance")
				amount=$(echo $balance | awk -F' ' '{print $1}')
				total_amount=$(echo "scale=4; $total_amount + $amount" | bc)
	
				echo "[Collect Success]: $account transfer $balance to $collect_account \n"
			fi
		fi
	done

	echo "[Collect Done]: $collect_account collected total $total_amount $airdrop_symbol \n"
}

unlockWallet

if [[ $1 == clear && -n $wallet_name ]]
then
	clearPrivateKey
fi

importPrivateKey
transferAirdrop