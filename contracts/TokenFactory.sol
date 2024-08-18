// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./EduLaunchBoxToken.sol";

contract EduLaunchBoxFactory {
    mapping(address => address[]) public deployedLaunchBoxes;

    event NewLaunchBoxToken(address indexed creator, address indexed token);

    function newLaunchBox(
        string memory name,
        string memory symbol,
        uint256 supply
    ) public returns (address) {
        address newLaunch = address(
            new EduLaunchBoxToken{
                salt: bytes32(deployedLaunchBoxes[msg.sender].length)
            }(name, symbol, supply)
        );
        deployedLaunchBoxes[msg.sender].push(newLaunch);

        emit NewLaunchBoxToken(msg.sender, newLaunch);

        return address(newLaunch);
    }

    function getAddressCreate2(
        bytes memory bytecode,
        uint256 salt
    ) public view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(bytecode)
            )
        );

        return address(uint160(uint(hash)));
    }

    function getBytecode(
        string memory name,
        string memory symbol,
        uint256 supply
    ) public pure returns (bytes memory) {
        bytes memory bytecode = type(EduLaunchBoxToken).creationCode;

        return abi.encodePacked(bytecode, abi.encode(name, symbol, supply));
    }

    function getdeployedLaunchBoxesLen(
        address creator
    ) public view returns (uint256) {
        return deployedLaunchBoxes[creator].length;
    }

    function getdeployedLaunchBoxes(
        address creator
    ) public view returns (address[] memory) {
        return deployedLaunchBoxes[creator];
    }
}
