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

    constructor() ERC721("Secret NFT", "SHH") {}

    function mint(bytes32[] calldata merkleProof) public {
        bool valid = canMint(msg.sender, merkleProof);
        require(valid, "Invalid proof.");

        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(msg.sender, tokenId);
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
