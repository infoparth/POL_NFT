// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract dNFT is ERC721 {

    string s_base_URI;
    address public s_owner;

    address[]  can_mint;

    event ownerChanged(address indexed prevOwner, address indexed newOwner);
    event newMinterAdded(address indexed newMinter);
    event minterRemoved(address indexed minter);

    uint256 private _tokenIdCounter;

    modifier onlyOwner(){
        require(msg.sender == s_owner, "You are not the owner");
        _;
    }

    modifier ownerOrMinter(){
        require(msg.sender == s_owner || _isApproved(msg.sender) != 0, "You are not authorized to access this");
        _;
    }

    constructor() ERC721("Decentra", "DCS") {
    s_owner = msg.sender;

    }

    function setBaseURI(string memory _URI)
    external
    onlyOwner(){

        s_base_URI = _URI;
    }

    function safeMint(address to)
    external
    ownerOrMinter()
    {

        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter += 1;
        _safeMint(to, tokenId);

    }

    function addMinter(address _add)
    external
    onlyOwner()
    {

        can_mint.push(_add);
        emit newMinterAdded(_add);

    }

    function removeMemebers(address _remove)
    public
    onlyOwner()
    {

        uint index = _isApproved(_remove);
        require(index != 0, "Minter does not exist");
        index -= 1;
        require(index < can_mint.length);
        can_mint[index] = can_mint[can_mint.length-1];
        can_mint.pop();

        emit minterRemoved(_remove);

    }


    function _isApproved(address _add)
    internal
    view
    onlyOwner()
    returns(uint)
    {

        uint len = can_mint.length;
        for(uint i = 0; i < len; i++){

            if(can_mint[i] == _add){
                return (i + 1);
            }
        }

        return (0);

    }

    function changeOwner(address _newOwner)
    external
    onlyOwner()
    {

        address oldOwner = s_owner;
        s_owner = _newOwner;

        emit ownerChanged(oldOwner, _newOwner);
 
    }

    //The following functions are overrides

    function _update(address to, uint256 tokenId, address zero)
    internal
    virtual
    override(ERC721)
    returns(address)
    {

        address _from = ownerOf(tokenId);

        require(to != address(0), "This NFT can't be burnt");
        require(_from == address(0), "This NFT is non-transferable");
        super._update(to, tokenId, zero);

        return _from;

    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721)
    returns (string memory)
    {

        require(_exists(tokenId), "Token ID does not exist");
        return s_base_URI;

    }

    function _exists(uint256 _tokenId)
    internal 
    view
    returns(bool){

        return ownerOf(_tokenId) != address(0);
    }

    function supportsInterface(bytes4 interfaceId)
    public 
    view
    override(ERC721)
    returns(bool)
    {

        return super.supportsInterface(interfaceId);

    }
}