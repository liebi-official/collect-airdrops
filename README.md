## EOS/BOS 空投归集脚本

### 前言
账号太多，空投太乱，一键将其他账号的指定代币转账到一个账号中。

### 使用说明
1. 配置脚本

```
node="https://api.eosnewyork.io"	# 节点服务器地址（主网任意一个就行，如果是 BOS 等侧链，需要配置侧链的节点）
wallet_name="collect-wallet" 		# 本地钱包名称（建议使用临时钱包）
wallet_pass="walletpassword" 		# 本地钱包密码（建议使用临时钱包）
collect_account="collectacct1" 		# 接收空投归集的账号（其他账号空投将转账到该账号，请认真填写）
airdrop_contract="eosio.token" 		# 需要归集空投 Token 的合约名称，下面会列出几个主流常用，其他的可上 eospark.com 查询
airdrop_symbol="EOS" 				# 需要归集空投 Token 的简称
```

2. 配置私钥

> 将需要归集账号的私钥填写入 `private_key` 文件中（删除原先示例），一行一个，值得注意的是脚本会将私钥关联的所有账号查询出来并进行转账归集到 `collect_account`，如果一个私钥捆绑了多个账号，请注意这些账号是否是需要归集的目标账号。
>
> *注意：脚本跑完，归集完成后，请记得清理 `private_key` 文件内容，以免不慎泄露私钥*

3. 执行脚本

```
sh collect.sh
```

如需删除老私钥，重新导入新私钥，执行时请带上参数 `clear`，该操作会清理 `collect-wallet` 下导入的所有私钥后重新导入 `private_key` 文件中的私钥，请谨慎操作。

```
sh collect.sh clear
```

### 其他

> 部分主流空投的合约名称和简称

| 简称 | 合约名称  |
|----------|:-------------:|
| EOS | eosio.token |
| BLACK | eosblackteam |
| SEED | parslseed123 |
| BG | bgbgbgbgbgbg |
| ADD | eosadddddddd |
| LUCKY | eoslucktoken |
| MEETONE | eosiomeetone |
| TPT | tokendapppub |
| FAST | fastecoadmin |
| TGC | eostgctoken1 |

更多请访问（查看持有代币）：https://eospark.com/account/newdexpocket