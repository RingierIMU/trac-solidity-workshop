// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SecretNft is
ERC721,
Ownable
{
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
}
