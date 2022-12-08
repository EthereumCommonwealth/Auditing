// SPDX-License-Identifier: GPL

pragma solidity ^0.8.16;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface ICallistoSBT {

    event Transfer     (address indexed from, address indexed to, uint256 indexed tokenId);
    event TransferData (bytes data);
    
    struct Properties {
        
        // In this example properties of the given SBT are stored
        // in a dynamically sized array of strings
        // properties can be re-defined for any specific info
        // that a particular SBT is intended to store.
        
        /* Properties could look like this:
        bytes   property1;
        bytes   property2;
        address property3;
        */
        
        string[] properties;
    }
    
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function standard() external view returns (string memory);
    function balanceOf(address _who) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    
    function getTokenProperties(uint256 _tokenId) external view returns (Properties memory);
    function getTokenProperty(uint256 _tokenId, uint256 _propertyId) external view returns (string memory);

    function getUserContent(uint256 _tokenId) external view returns (string memory _content);
    function setUserContent(uint256 _tokenId, string calldata _content) external returns (bool);
}

abstract contract TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external virtual returns(bytes4);
}

abstract contract CallistoSBT is ICallistoSBT, Ownable {
    
    mapping (uint256 => Properties)                internal _tokenProperties;
    mapping (address => mapping (uint256 => mapping (uint256 => bool))) internal _writingPermission; // address_of_writer => tokenID => propertyID => Permission (Yes / No)
    mapping (address => bool) management_permission; // defines writing permissions for auditing department managers

    modifier onlyOwnerOrManager
    {
        require(owner() == msg.sender || management_permission[msg.sender], "Permission management: caller is not the owner or manager");
        _;
    }

    // Token name
    string internal _name;

    // Token symbol
    string internal _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) internal _owners;

    // Mapping owner address to token count
    mapping(address => uint256) internal _balances;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name   = name_;
        _symbol = symbol_;
    }

    function setPermission(address _who, bool _permission) public onlyOwner
    {
        management_permission[_who] = _permission;
    }
    
    function standard() public pure override returns (string memory)
    {
        return "CallistoSBT";
    }
    
    function getTokenProperties(uint256 _tokenId) public view override returns (Properties memory)
    {
        return _tokenProperties[_tokenId];
    }
    
    function getTokenProperty(uint256 _tokenId, uint256 _propertyId) public view override returns (string memory)
    {
        return _tokenProperties[_tokenId].properties[_propertyId];
    }

    function getUserContent(uint256 _tokenId) public view override returns (string memory _content)
    {
        return (_tokenProperties[_tokenId].properties[0]);
    }

    function setUserContent(uint256 _tokenId, string calldata _content) public override returns (bool success)
    {
        require(msg.sender == ownerOf(_tokenId), "SBT: only owner can change SBT content");
        _tokenProperties[_tokenId].properties[0] = _content;
        return true;
    }
    
    function balanceOf(address owner) public view override returns (uint256) {
        require(owner != address(0), "SBT: balance query for the zero address");
        return _balances[owner];
    }
    
    function ownerOf(uint256 tokenId) public view override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "SBT: owner query for nonexistent token");
        return owner;
    }
    
    function name() public view override returns (string memory) {
        return _name;
    }
    
    function symbol() public view override returns (string memory) {
        return _symbol;
    }
    
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function configureSBT(uint256 tokenId) internal
    {
        if(_tokenProperties[tokenId].properties.length == 0)
        {
            _tokenProperties[tokenId].properties.push("");
        }
    }

/*
    function checkPermission(address writer, uint256 tokenId, uint256 propertyId) internal
    {
        require(_writingPermission[writer][tokenId][propertyId]);
    }
*/

    function setProperty(uint256 tokenId, uint256 propertyId, string calldata content) public
    {
        require(_writingPermission[msg.sender][tokenId][propertyId]);
        _tokenProperties[tokenId].properties[propertyId] = content;
    }

    function setPermission(address who, uint256 tokenId, uint256 propertyId, bool permission) public onlyOwnerOrManager
    {
        _writingPermission[who][tokenId][propertyId] = permission;
    }

    function addProperties(uint256 tokenId, uint8 propertiesCount) public onlyOwnerOrManager
    {
        for (; propertiesCount > 0; propertiesCount--)
        {
            _tokenProperties[tokenId].properties.push("");
        }
    }

    function addPropertyWithContent(uint256 tokenId, string calldata _content) public onlyOwnerOrManager
    {
        _tokenProperties[tokenId].properties.push("");
        _tokenProperties[tokenId].properties[_tokenProperties[tokenId].properties.length] = _content;
    }

    function mintWithProperties(address to, uint256 tokenId, uint8 propertiesCount) public onlyOwnerOrManager
    {
        _mint(to, tokenId);

        for (; propertiesCount > 0; propertiesCount--)
        {
            _tokenProperties[tokenId].properties.push("");
        }
    }

    function burn(address from, uint256 tokenId, bytes calldata reason) public onlyOwnerOrManager
    {
        _burn(tokenId);
        emit TransferData (reason);
    }
    
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "SBT: mint to the zero address");
        require(!_exists(tokenId), "SBT: token already minted");

        configureSBT(tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }
    
    function _burn(uint256 tokenId) internal {
        address owner = CallistoSBT.ownerOf(tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    // This function could be used to call arbitrary functions on behalf of the contract by the owner.
    // It has two main purposes - extraction of ERC20 tokens
    // and minting "template tokens"

    // Template tokens are special contracts that implement complex minting logic,
    // for example minting a token then configuring 2 properties with writing permission for address A,
    // another 2 properties with writing permission for address B and 1 more property with writing permission for address C

    function delegatecall(address _source, string calldata _func) public onlyOwner
    {
        (bool success, bytes memory data) = _source.delegatecall(
            abi.encodeWithSignature(_func)
        );
    }
}

contract SecurityDepartmentSBT is CallistoSBT("Sec.Dep. SBT", "SecDep")
{
    
}
