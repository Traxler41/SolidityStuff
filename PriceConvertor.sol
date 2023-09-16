//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConvertor{
    function getPrice() public view returns(uint256){
             //ABI
            //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306

            AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
            (,int price,,,) = pricefeed.latestRoundData();
            return uint256(price * 1e18);

        }

        function getVersion() public view returns(uint256){
            AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
            return pricefeed.version();//Returns ETH in USD

        }

        function getConversionRate(uint256 ethAmount) public view returns(uint256){
            uint256 ethPrice = getPrice();
            uint256 ethAmountInUSD = (ethPrice * ethAmount)/1e18;
            return ethAmountInUSD;
        }
}
