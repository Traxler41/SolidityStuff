//In mathematical terms, the sequence Fn of Fibonacci numbers is defined by the recurrence relation: Fn = Fn-1 + Fn-2 with seed values and F0 = 0 and F1 = 1 .
//Create a smart contract as follows which calculates the value of Fn in the fibonacci sequence:
//function fibonacci(uint n) public returns (uint): This function should take 1 parameter of type uint256, n, as input and output the value of Fn in the fibonacci sequence as described above.



//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

contract Fibonacci{
    function fibonacci(uint n)public pure returns (uint){
        uint f0=0;
        uint f1=1;
        uint s=0;
        if(n>1)
        {
            for(uint x=3;x<=n;x++)
            {
                s=f0+f1;
                f0=f1;
                f1=s;
            }
            return s;
        }
        else if(n==1)
        {
            return 1;
        }
        else{
            return 0;
        }
    }
}
