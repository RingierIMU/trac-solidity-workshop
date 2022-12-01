// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./EllipticCurve.sol";

contract SecretNft is
ERC721,
Ownable
{
    // Secp256k1 Elliptic Curve
    uint256 public constant GX = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
    uint256 public constant GY = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
    uint256 public constant AA = 0;
    uint256 public constant BB = 7;
    uint256 public constant PP = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

    uint256 public PublicKeyX = 47399295923737332203128740400332200352486735970329032736545628082136236052321;
    uint256 public PublicKeyY = 75544403844492027281818771006325144237319432445740198063231645656336960748985;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    string private baseURI;
    bytes32 private merkleRoot;
    event PrivateTransfer(address indexed stealthRecipient, string _sharedSecret);

    constructor() ERC721("Secret NFT", "SHH") {}

    function mint(address _stealthAddress, string calldata _sharedSecret) public onlyOwner {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(_stealthAddress, tokenId);

        emit PrivateTransfer(_stealthAddress, _sharedSecret);
    }

    function canMint(address _address, bytes32[] calldata merkleProof) public view returns (bool) {
        bytes32 node = keccak256(
            abi.encodePacked(_address)
        );

        return MerkleProof.verifyCalldata(
            merkleProof,
            merkleRoot,
            node
        );
    }

    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    function addressFromPoints(uint Qx, uint Qy) public view returns (address) {
        return address(uint160(uint256(keccak256(abi.encodePacked(Qx, Qy)))));
    }

    /**
    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        if (bytes(baseURI).length != 0) {
            return baseURI;
        }

        return "https://ipfs.io/ipfs/QmchKUshCbfshdC378EZ55Cg7kVdYJzdRH5Nygu8ZZqCFS/";
    }

    function generateStealthAddress(uint256 secret) public view returns (uint256, uint256, address){
        //  s*G = S
        (uint256 pubDataX,uint256 pubDataY) = EllipticCurve.ecMul(secret, GX, GY, AA, PP);
        //  s*P = q
        (uint256 Qx,uint256 Qy) = EllipticCurve.ecMul(secret, PublicKeyX, PublicKeyY, AA, PP);
        // hash(sharedSecret)
        bytes32 hQ = keccak256(abi.encodePacked(Qx, Qy));
        // hash value to public key
        (Qx, Qy) = EllipticCurve.ecMul(uint(hQ), GX, GY, AA, PP);
        // derive new public key
        (Qx, Qy) = EllipticCurve.ecAdd(PublicKeyX, PublicKeyY, Qx, Qy, AA, PP);
        // generate stealth address
        address stealthAddress = address(uint160(uint256(keccak256(abi.encodePacked(Qx, Qy)))));
        // return public key coordinates and stealthAddress
        return (pubDataX, pubDataY, stealthAddress);
    }
}
