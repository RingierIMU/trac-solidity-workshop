// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SecretNft is
ERC721,
Ownable
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    string private baseURI;
    mapping(address => bool) allowList;

    constructor() ERC721("Secret NFT", "SHH") {}

    function mint() public {
        require(canMint(msg.sender), "You are not allowed to mint");
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(msg.sender, tokenId);
    }

    function canMint(address _address) public view returns (bool) {
        return allowList[_address];
    }

    function addToAllowList(address _address) public onlyOwner {
        allowList[_address] = true;
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
        return baseURI;
    }
}
