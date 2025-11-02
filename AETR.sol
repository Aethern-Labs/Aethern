// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AETR is ERC721, Ownable {
    uint256 public nextId;
    mapping(uint256 => string) private _tokenMetadata;

    constructor() ERC721("Aethern Reputation", "AETR") {}

    function mintTo(address to, string calldata metadata) external onlyOwner returns (uint256) {
        uint256 id = ++nextId;
        _safeMint(to, id);
        _tokenMetadata[id] = metadata;
        return id;
    }

    // Prevent transfers
    function _transfer(address, address, uint256) internal pure override {
        revert("AETR: soulbound, non-transferable");
    }

    // Allow revoke by owner (DAO)
    function revoke(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
    }

    function tokenMetadata(uint256 tokenId) external view returns (string memory) {
        return _tokenMetadata[tokenId];
    }
}
