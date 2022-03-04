//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./Base64.sol";

contract CoolNFT {
    mapping (uint256 => string) private nftName;
    mapping (uint256 => string) private nftDescription;
    mapping (uint256 => string) private nftImage;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    modifier contractOrTokenOwner(uint256 token) {
        require(owner() == _msgSender() || ownerOf(token) == _msgSender(), "Access-Restricted: Contract or token owner");
        _;
    }

    function mint(address recipient, string memory name, string memory description, string memory image)
    public
    onlyOwner
    nonReentrant
    {
        nftName[totalSupply() + 1] = name;
        nftDescription[totalSupply() + 1] = description;
        nftImage[totalSupply() + 1] = image;

        _mint(recipient, totalSupply() + 1);
    }

    function updateName(uint256 token, string memory name)
    public
    onlyOwner
    nonReentrant
    {
        nftName[token] = name;
    }

    function updateDescription(uint256 token, string memory description)
    public
    contractOrTokenOwner
    nonReentrant
    {
        nftDescription[token] = description;
    }

    function updateImage(uint256 token, string memory image)
    public
    onlyOwner
    nonReentrant
    {
        nftImage[token] = image;
    }

    function tokenURI(uint256 token) public view override returns (string memory)
    {
        return string(abi.encodePacked("data:application/json;base64,",
                        Base64.encode(
                            abi.encodePacked(
                                '{"name":"', nftName[token],
                                '",{"description":"', nftDescription[token],
                                '",{"image":"data:image/svg+xml;base64', nftImage[token],
                                '"}'
                            )
                        )
                    )
                );
    }

    function deleteContract(address payable recipient)
    public
    onlyOwner
    nonReentrant
    {
        selfDestruct(recipient);
    }
}
