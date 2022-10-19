# rtc-solidity-workshop
Code for the RTC solidity workshop
Here we will look at privacy (using basic cryptography) in Ethereum from the lens of an NFT smart contract.
## Setup
No setup is required for this workshop. We will be using the Remix IDE to write and deploy our smart contracts.
https://remix.ethereum.org/
## Merkle tree setup
To add addresses to the Merkel tree edit the file 4_merkel_tree/merkle_proof.js
```javascript
let addresses = [
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    "0xea674fdde714fd979de3edf0f56aa9716b898ec8",
    "0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf",
    "0x3CB39EA2f14B16B69B451719A7BEd55e0aFEcE8F"
];
```
Be sure to run npm install before running the script.

## IPFS Setup
We will be using IPFS to store our NFTs. You can download the IPFS desktop app here: https://ipfs.io/#install
You can also just use this as your token `uri` `https://ipfs.io/ipfs/QmaHvtFEn1B3f7u9TtfLAkyBrRSoKrCF646BjmDum4sL4s?filename=`
## Stealth Address Setup
The scripts for stealth addresses are in 5_stealth_address/
Be sure to run `pip install -r requirements.txt` before running the script.
