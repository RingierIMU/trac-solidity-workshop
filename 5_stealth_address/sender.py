from py_ecc.secp256k1 import *
from eth_account import Account
from Crypto.Hash import keccak
k = keccak.new(digest_bits=256)

# address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
senderPrivate = int(0x503f38a9c967ed597e47fe25643985f032b072db8075426a92110f82df48dfcb)
SenderPublic = secp256k1.privtopub(senderPrivate.to_bytes(32, "big")) # public key

# address: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
ReceiverPublic = int(0x0468cb0cffc92a03959e6fdc99a24f8c94143050099ca104863528c25e3c024f61a7049e09e669397f43d0fd63432b5b358f3d0caaf03b34acbcdc7f2cbe227db9)
ReceiverPublic = secp256k1.multiply(G, ReceiverPublic)

Q = secp256k1.multiply(ReceiverPublic, senderPrivate)
# hex the shared screct
Q_hex = k.update(Q[0].to_bytes(32, "big")+Q[1].to_bytes(32, "big")).hexdigest() # note, toStr conversion
Q_hashed = bytearray.fromhex(Q_hex)
# Sender sends to ...
stealthAddress = secp256k1.add(ReceiverPublic, secp256k1.privtopub(Q_hashed))
print(hex(stealthAddress[0]))
