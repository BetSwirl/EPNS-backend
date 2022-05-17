// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IEPNSComV1 {
    event SendNotification(
        address indexed channel,
        address indexed recipient,
        bytes identity
    );
    
    function sendNotification(
        address _channel,
        address _recipient,
        bytes memory _identity
    ) external;
}
