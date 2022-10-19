from Crypto.PublicKey import ECC
from py_ecc.secp256k1 import *
from eth_account import Account
from Crypto.Hash import keccak
from eth_abi.packed import encode_packed

k = keccak.new(digest_bits=256)

# privkey: 0xd952fe0740d9d14011fc8ead3ab7de3c739d3aa93ce9254c10b0134d80d26a30
# address: 0x3CB39EA2f14B16B69B451719A7BEd55e0aFEcE8F
senderPrivate = int(0xd952fe0740d9d14011fc8ead3ab7de3c739d3aa93ce9254c10b0134d80d26a30) # private key
SenderPublic = secp256k1.privtopub(senderPrivate.to_bytes(32, "big")) # public key

# privkey: 0x0000000000000000000000000000000000000000000000000000000000000001
# address: 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf
receiverPrivate = int(0x0000000000000000000000000000000000000000000000000000000000000002) # private key
receiverPublic = secp256k1.privtopub(receiverPrivate.to_bytes(32, "big")) # public key

Q = secp256k1.multiply(SenderPublic, receiverPrivate)
assert Q == secp256k1.multiply(receiverPublic, senderPrivate)
Q_hex = k.update(Q[0].to_bytes(32, "big")+Q[1].to_bytes(32, "big")).hexdigest() # note, toStr conversion
Q_hashed = bytearray.fromhex(Q_hex)

# Sender sends to ...
points = secp256k1.add(receiverPublic, secp256k1.privtopub(Q_hashed))
print(points)


p_stealth = receiverPrivate + int(Q_hex, 16)

# Recipient has private key to ...
P_stealth = secp256k1.privtopub(p_stealth.to_bytes(32, "big"))
print(f'private key: {hex(p_stealth)}')
print(f'address: {Account.from_key((p_stealth).to_bytes(32, "big")).address}')
