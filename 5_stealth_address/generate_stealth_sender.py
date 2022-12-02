from Crypto.Hash import keccak
from py_ecc.secp256k1 import *

k = keccak.new(digest_bits=256)

# address: 0xefe069d5383CD50c814d1041727d6329A3f67445
senderPrivate = int(0x337e94a1be46364ac3e011a71090a68ad108ccbfd2616288d47fff3ac5e9e7e3)
SenderPublic = secp256k1.privtopub(senderPrivate.to_bytes(32, "big"))

# address: 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf
receiverPublic = (89565891926547004231252920425935692360644145829622209833684329913297188986597, 12158399299693830322967808612713398636155367887041628176798871954788371653930)
Q = secp256k1.multiply(receiverPublic, senderPrivate)
Q_hex = k.update(Q[0].to_bytes(32, "big")+Q[1].to_bytes(32, "big")).hexdigest() # note, toStr conversion
Q_hashed = bytearray.fromhex(Q_hex)

# Sender sends to ...
points = secp256k1.add(receiverPublic, secp256k1.privtopub(Q_hashed))
k = keccak.new(digest_bits=256)
publicKey = k.update(points[0].to_bytes(32, "big")+points[1].to_bytes(32, "big")).hexdigest()

print(f'shared secret: {Q_hex}')
print(f'stealth address : 0x{publicKey[-40:]}')

