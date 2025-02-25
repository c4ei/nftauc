// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function setApprovalForAll(address operator, bool _approved) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);
}

library Address {

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }


    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function toString(uint256 value) internal pure returns (string memory) {
    
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

library Counters {
    struct Counter {
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }


    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}

contract C4eiNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("C4EI NFT", "CNTF") {}

    // NFTs
    mapping(uint256 => string) public getNFTname; // getNFTname[tokenID] => name
    mapping(uint256 => string) public getNFTphotoURL; // getNFTphotoURL[tokenID] => photoURL
    mapping(uint256 => string) public getNFTdescription; // getNFTdescription[tokenID] => description

    mapping(address => uint256[]) public getNFTsIDsByAddress; // getTokenIDsByAddress[wallet] => [0, 3, 42, 90, 32, ...]
    mapping(uint256 => address) public getNFTowner; // getNFTowner[tokenID] => address of the owner.

    // Offers
    mapping(uint256 => uint256) public getOfferID; // getOfferID[tokenID] => offerID (actual amount of Offers that this NFT have)
    mapping(uint256 => uint256) public lastOfferIDAccepted; // lastOfferIDAccepted[tokenID] => offerID

    mapping(uint256 => mapping(uint256 => uint256)) public getOfferAmount; // getOfferAmount[tokenID][offerID] => uint256
    mapping(uint256 => mapping(uint256 => address)) public getOfferOwner; // getOfferOwner[tokenID][offerID] => address
    mapping(uint256 => mapping(uint256 => bool)) public isOfferAvailable; // isOfferAvailable[tokenID][offerID] => bool

    mapping(address => uint256) public offersBalance; // offersBalance[wallet] => uint256

    // This two arrays have to have the same length ALLWAYS.
    mapping(address => uint256[]) public getOffersIDof; // getOffersIDof[wallet] => [offerID]
    mapping(address => uint256[]) public getTokensIDoffertedOf; // getTokensIDoffertedOf[wallet] => [tokenID]

    // Aux
    uint256[] private emptyArray;

    // Funcs
    function getTokenID() public view returns(uint256) {
        return _tokenIds.current();
    }

    function createNFT(
        string memory name, 
        string memory description, 
        string memory photoURL
    ) public {
        uint256 tokenID = _tokenIds.current();
        _tokenIds.increment();
        _safeMint(msg.sender, tokenID);

        // Track the NFT
        getNFTname[tokenID] = name;
        getNFTphotoURL[tokenID] = photoURL;
        getNFTdescription[tokenID] = description;
        getNFTowner[tokenID] = msg.sender;

        uint256[] storage myNFTs = getNFTsIDsByAddress[msg.sender];
        myNFTs.push(tokenID);
        getNFTsIDsByAddress[msg.sender] = myNFTs;

    }

    function makeOffer(uint256 tokenID) public payable {
        require(tokenID <= _tokenIds.current(), "This NFT ID that you are trying to buy, doesn't exist. Make sure that you select an existing NFT.");

        // Set the values of the offer
        getOfferOwner[tokenID][getOfferID[tokenID]] = msg.sender;
        isOfferAvailable[tokenID][getOfferID[tokenID]] = true;
        getOfferAmount[tokenID][getOfferID[tokenID]] = msg.value;

        // Increase the total amount that this user offert to any NFT
        offersBalance[msg.sender] += msg.value;

        // Update the list of NFT offerted by this user
        addOfferToTracker(msg.sender, tokenID, getOfferID[tokenID]);

        // Increment by one the offerID of this NFT
        getOfferID[tokenID]++;
    }

    function deleteOffer(uint256 tokenID, uint256 offerID) public payable {
        require(msg.sender == getOfferOwner[tokenID][offerID], "You don't have the rights to delete this offer.");
        require(isOfferAvailable[tokenID][offerID] == true, "This offer isn't available.");
        payable(msg.sender).transfer(getOfferAmount[tokenID][offerID]);

        // Set the offer as unavailable
        isOfferAvailable[tokenID][offerID] = false;

        // Reduce the total amount that this user has offers to any NFT
        offersBalance[msg.sender] -= getOfferAmount[tokenID][offerID];

        // Update the list of NFT offerted by this user
        removeOfferToTracker(msg.sender, tokenID, offerID);
    }

    function deleteAllOffers() public {
        require(offersBalance[msg.sender] > 0, "You don't have offersBalance to claim");
        require(getOffersIDof[msg.sender].length > 0, "You don't have offers to claim");
        payable(msg.sender).transfer(offersBalance[msg.sender]);

        // This two arrays have to have the same length ALLWAYS.
        uint256[] memory offersList = getOffersIDof[msg.sender];
        uint256[] memory tokenOffersList = getTokensIDoffertedOf[msg.sender];
        
        // Set to false all the offers of the user
        for (uint256 i = 0; i < offersList.length; i++) 
            isOfferAvailable[tokenOffersList[i]][offersList[i]] = false;

        // Update the list of NFT offerted by this user
        removeAllOffersToTracker(msg.sender);
        
        offersBalance[msg.sender] = 0;
    }

    function acceptOffer(uint256 tokenID, uint256 offerID) public {
        require(msg.sender == getNFTowner[tokenID], "You don't have the rights to accept this offer.");
        require(isOfferAvailable[tokenID][offerID] == true, "This offer isn't available.");

        transferFrom(msg.sender, getOfferOwner[tokenID][offerID], tokenID); // si no funciona usar _transfer

        updateTokensOwners(msg.sender, getOfferOwner[tokenID][offerID], tokenID);

        payable(msg.sender).transfer(getOfferAmount[tokenID][offerID]);

        lastOfferIDAccepted[tokenID] = offerID;
        isOfferAvailable[tokenID][offerID] = false;

    }

    function updateTokensOwners(address from, address to, uint256 tokenID) private {
        uint256[] storage fromNFTs = getNFTsIDsByAddress[from];
        uint256[] storage newFromNFTs = emptyArray;

        uint256[] storage toNFTs = getNFTsIDsByAddress[to];

        for (uint256 i = 0; i < fromNFTs.length; i++) {
            if (fromNFTs[i] != tokenID) newFromNFTs.push(fromNFTs[i]);
        }

        toNFTs.push(tokenID);

        getNFTsIDsByAddress[from] = newFromNFTs;
        getNFTsIDsByAddress[to] = toNFTs;
        getNFTowner[tokenID] = to;
    }

    function addOfferToTracker(address wallet, uint256 tokenID, uint256 offerID) private {
        uint256[] storage offersIDof = getOffersIDof[wallet];
        uint256[] storage tokensIDoffertedOf = getTokensIDoffertedOf[wallet];

        offersIDof.push(offerID);
        tokensIDoffertedOf.push(tokenID);

        getOffersIDof[wallet] = offersIDof;
        getTokensIDoffertedOf[wallet] = tokensIDoffertedOf;

    }

    function removeOfferToTracker(address wallet, uint256 tokenID, uint256 offerID) private {
        // This two arrays have to have the same length ALLWAYS.
        uint256[] memory offersIDof = getOffersIDof[wallet];
        uint256[] memory tokensIDoffertedOf = getTokensIDoffertedOf[wallet];

        uint256[] storage newOffersIDof = emptyArray;
        uint256[] storage newTokensIDoffertedOf = emptyArray;

        for(uint256 i = 0; i < offersIDof.length; i++) {

            if (tokenID != tokensIDoffertedOf[i] && offerID != offersIDof[i]){
                newOffersIDof.push(offersIDof[i]);
                newTokensIDoffertedOf.push(tokensIDoffertedOf[i]);
            }

        }

        getOffersIDof[wallet] = newOffersIDof;
        getTokensIDoffertedOf[wallet] = newTokensIDoffertedOf;

    }

    function removeAllOffersToTracker(address wallet) private {
        delete getOffersIDof[wallet];
        delete getTokensIDoffertedOf[wallet];
    }

}