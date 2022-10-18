from py_ecc.secp256k1 import *
from eth_account import Account
from Crypto.Hash import keccak
k = keccak.new(digest_bits=256)

# address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
SenderPublic = int(0x0468cb0cffc92a03959e6fdc99a24f8c94143050099ca104863528c25e3c024f61a7049e09e669397f43d0fd63432b5b358f3d0caaf03b34acbcdc7f2cbe227db9)
SenderPublic = secp256k1.multiply(G, SenderPublic)

# address: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
receiverSecret = int(0x7e5bfb82febc4c2c8529167104271ceec190eafdca277314912eaabdb67c6e5f)


Q = secp256k1.multiply(SenderPublic, receiverSecret)
# hex the shared scerect
Q_hex = k.update(Q[0].to_bytes(32, "big")+Q[1].to_bytes(32, "big")).hexdigest() # note, toStr conversion
p_stealth = receiverSecret + int(Q_hex, 16)
print(hex(p_stealth))

# Recipient has private key to ...
P_stealth = secp256k1.privtopub(p_stealth.to_bytes(32, "big"))

print(Account.from_key(p_stealth.to_bytes(32, "big")).address)
