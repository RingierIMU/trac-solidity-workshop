// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RtcNft is
ERC721,
Ownable
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    mapping(address => bool) allowList;
    
    constructor() ERC721("NFT Workshop", "RtcNft") {}

    function canMint(address _address) public view returns (bool) {
        return allowList[_address];
    }

    function mint() public {
        bool valid = canMint(msg.sender);
        require(valid, "Cannot mint");
        
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(msg.sender, tokenId);
    }
    
    function addToAllowList(address _address) public onlyOwner {
        allowList[_address] = true;
    }
}
