from Crypto.Hash import keccak
from eth_account import Account
from py_ecc.secp256k1 import *

k = keccak.new(digest_bits=256)

# address: 0xefe069d5383CD50c814d1041727d6329A3f67445
senderPrivate = int(0x337e94a1be46364ac3e011a71090a68ad108ccbfd2616288d47fff3ac5e9e7e3) # private key
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
print(f'shared secret: {Q_hex}')
print(f'stealth private key: {hex(p_stealth)}')
print(f'stealth address: {Account.from_key((p_stealth).to_bytes(32, "big")).address}')
