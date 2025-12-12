// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

import "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";
import "erc721a-upgradeable/contracts/extensions/ERC721AQueryableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";
import "./OnChainMetadataUP.sol";

contract AGAGAGAUP is
    Initializable,
    ERC721AUpgradeable,
    ERC721AQueryableUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    ERC2981Upgradeable,
    OnChainMetadata
{
    using ECDSA for bytes32;
    address private signerAddress;

    struct Statistic {
        uint256 _enemyKill;
        uint256 _damageDealt;
        uint256 _damageTaken;
        uint256 _playerDied;
        uint256 _playerRevived;
        uint256 _missionCompleted;
        uint256 _keystoneCompleted;
        bytes32 _messageHash;
        bytes _signature;
    }

    event NftMinted(
        address indexed _from,
        uint256 _tokenId,
        uint256 _createdAt,
        uint256 _enemyKill,
        uint256 _damageDealt,
        uint256 _damageTaken,
        uint256 _playerDied,
        uint256 _playerRevived,
        uint256 _missionCompleted,
        uint256 _keystoneCompleted
    );

    event MetadataUpdated(address indexed _from, uint256 _tokenId);

    constructor() {
        _disableInitializers();
    }

    function initialize(
        address initialOwner
    ) public initializerERC721A initializer {
        __ERC721A_init("AGAGAGAUP", "AGAGAGAUP");
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();

        signerAddress = 0xEb929B9231Bf6e5A2034F929037d8939F922BCfF;
    }

    modifier checkSigned(address _address, Statistic calldata _stats) {
        require(
            _stats._messageHash ==
                ECDSA.toEthSignedMessageHash(
                    hashPacked(
                        _address,
                        _stats._enemyKill,
                        _stats._damageDealt,
                        _stats._damageTaken,
                        _stats._playerDied,
                        _stats._playerRevived,
                        _stats._missionCompleted,
                        _stats._keystoneCompleted
                    )
                ),
            "Invalid message hash"
        );
        require(
            signerAddress ==
                ECDSA.recover(_stats._messageHash, _stats._signature),
            "Invalid signature"
        );
        _;
    }

    function mint(
        Statistic calldata _stats
    ) external checkSigned(msg.sender, _stats) {
        require(balanceOf(msg.sender) < 1, "User already have the NFT");
        uint256 _tokenId = totalSupply() + 1;

        _mint(msg.sender, 1);

        _updateTokenName(_tokenId);
        _updateTokenDescription(_tokenId, "AEGAEGAEGAEGAEGAEGAEGAEGAEG");
        _updateTokenImage(
            _tokenId,
            "ipfs://QmPbxeGcXhYQQNgsC6a36dDyYUcHgMLnGKnF8pVFmGsvqi"
        );
        _updateEnemyKill(_tokenId, _stats._enemyKill);
        _updateDamageDealt(_tokenId, _stats._damageDealt);
        _updateDamageTaken(_tokenId, _stats._damageTaken);
        _updatePlayerDied(_tokenId, _stats._playerDied);
        _updatePlayerRevived(_tokenId, _stats._playerRevived);
        _updateMissionCompleted(_tokenId, _stats._missionCompleted);
        _updateKeystoneCompleted(_tokenId, _stats._keystoneCompleted);

        emit NftMinted(
            msg.sender,
            _tokenId,
            block.timestamp,
            _stats._enemyKill,
            _stats._damageDealt,
            _stats._damageTaken,
            _stats._playerDied,
            _stats._playerRevived,
            _stats._missionCompleted,
            _stats._keystoneCompleted
        );
    }

    function updateEnemyKillTrait(
        uint256 _tokenId,
        Statistic calldata _stats
    ) external checkSigned(msg.sender, _stats) {
        require(_exists(_tokenId), "NFT is not exists");
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only owner of the nft can call this function"
        );
        _updateEnemyKill(_tokenId, _stats._enemyKill);
        emit MetadataUpdated(msg.sender, _tokenId);
    }

    function updateDamageDealtTrait(
        uint256 _tokenId,
        Statistic calldata _stats
    ) external checkSigned(msg.sender, _stats) {
        require(_exists(_tokenId), "NFT is not exists");
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only owner of the nft can call this function"
        );
        _updateDamageDealt(_tokenId, _stats._damageDealt);
        emit MetadataUpdated(msg.sender, _tokenId);
    }

    function updateDamageTakenTrait(
        uint256 _tokenId,
        Statistic calldata _stats
    ) external checkSigned(msg.sender, _stats) {
        require(_exists(_tokenId), "NFT is not exists");
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only owner of the nft can call this function"
        );
        _updateDamageTaken(_tokenId, _stats._damageTaken);
        emit MetadataUpdated(msg.sender, _tokenId);
    }

    function updatePlayerDiedTrait(
        uint256 _tokenId,
        Statistic calldata _stats
    ) external checkSigned(msg.sender, _stats) {
        require(_exists(_tokenId), "NFT is not exists");
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only owner of the nft can call this function"
        );
        _updatePlayerDied(_tokenId, _stats._playerDied);
        emit MetadataUpdated(msg.sender, _tokenId);
    }

    function updatePlayerRevivedTrait(
        uint256 _tokenId,
        Statistic calldata _stats
    ) external checkSigned(msg.sender, _stats) {
        require(_exists(_tokenId), "NFT is not exists");
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only owner of the nft can call this function"
        );
        _updatePlayerRevived(_tokenId, _stats._playerRevived);
        emit MetadataUpdated(msg.sender, _tokenId);
    }

    function updateMissionCompletedTrait(
        uint256 _tokenId,
        Statistic calldata _stats
    ) external checkSigned(msg.sender, _stats) {
        require(_exists(_tokenId), "NFT is not exists");
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only owner of the nft can call this function"
        );
        _updateMissionCompleted(_tokenId, _stats._missionCompleted);
        emit MetadataUpdated(msg.sender, _tokenId);
    }

    function updateKeystoneCompletedTrait(
        uint256 _tokenId,
        Statistic calldata _stats
    ) external checkSigned(msg.sender, _stats) {
        require(_exists(_tokenId), "NFT is not exists");
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only owner of the nft can call this function"
        );
        _updateKeystoneCompleted(_tokenId, _stats._keystoneCompleted);
        emit MetadataUpdated(msg.sender, _tokenId);
    }

    function hashPacked(
        address _address,
        uint256 _enemyKill,
        uint256 _damageDealt,
        uint256 _damageTaken,
        uint256 _playerDied,
        uint256 _playerRevived,
        uint256 _missionCompleted,
        uint256 _keystoneCompleted
    ) private pure returns (bytes32) {
        bytes memory hashData = abi.encodePacked(
            _address,
            _enemyKill,
            _damageDealt,
            _damageTaken,
            _playerDied,
            _playerRevived,
            _missionCompleted,
            _keystoneCompleted
        );
        bytes32 hash = keccak256(hashData);
        return hash;
    }

    // override
    function tokenURI(
        uint256 _tokenId
    )
        public
        view
        virtual
        override(ERC721AUpgradeable, IERC721AUpgradeable)
        returns (string memory)
    {
        return _createTokenURI(_tokenId);
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal virtual override {
        require(from == address(0), "NFT is Soulbound");
        super._beforeTokenTransfers(from, to, tokenId, batchSize);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC721AUpgradeable, IERC721AUpgradeable, ERC2981Upgradeable)
        returns (bool)
    {
        return
            super.supportsInterface(interfaceId) ||
            ERC721AUpgradeable.supportsInterface(interfaceId) ||
            ERC2981Upgradeable.supportsInterface(interfaceId);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
