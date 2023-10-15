//"16 Parchi Thap" is an enjoyable card game where four friends aim to collect four chits, called parchis, of the same type without revealing their hand to one another. They take turns passing chits, and the first to gather four of a kind wins the game!
//Rules of 16 Parchi Thap:
//There are total 16 parchis(chits), with each parchi being categorized as type 1, 2, 3, or 4. Four parchis of each type are available.
//Before the game commences, the four participating players start with no parchis.
//In the following examples, the convention for representing chits is as follows:
//Parchis held by a player are represented by an array of length 4, where the nth element in the array indicates the number of parchis of type n.
//For example, the representation [1,2,0,1] means that the player has
//1 parchi of type 1,
//2 parchis of type 2,
//0 parchis of type 3, and
//1 parchi of type 4.
//Representation of all the distributed parchis in the game will be an array of representation of array of ‘arrays of parchis of players
//For example, the representation [1,2,0,1] means that the player has
//the array [0,1,1,1] corresponds to the parchis held by 1st player (who started the game),
//the array [3,0,1,1] corresponds to the parchis held by 2nd player,
//the array [0,2,1,1] corresponds to the parchis held by 3rd player, and
//the array [1,1,1,1] corresponds to the parchis held by 4th player.
//The game then begins with random distribution of 4 parchis to each participant.
//Example - [[0,2,1,1],[1,0,2,1],[3,0,0,1],[0,2,1,1]]
//Players do not reveal the types of their parchis to others. To win the game, a player must collect 4 parchis of any single type.
//The game runs in cyclic manner, with the first player passing one chit to the next player. For example, consider the state of the game after the initial distribution: [[0,2,1,1],[1,0,2,1],[3,0,0,1],[0,2,1,1]]. In this state, player 1 passes a parchi of type 3 to player 2.
//The next player then sees the type of parchi he/she has and then keeping in mind that he wants to gather 4 parchis of any one type, strategically passes one of the parchis he/she has to the next player.
//Example - now the state of game is [[0,2,0,1],[1,0,3,1],[3,0,0,1],[0,2,1,1]] and its turn of player 2 who passes parchi of type 1 to player 3. The new state of the game will be [[0,2,0,1],[0,0,3,1],[4,0,0,1],[0,2,1,1]]
//As soon as a player gathers 4 parchis of a type, the player can claim the win buy showing his/her parchis to the other players.
//Example - Player 3 can claim win now since the player has 4 parchis of type 1.
//In the event that multiple players collect 4 parchis of a single type, the player who first claims victory is declared the winner.
//Please note that at any point during the game, a player can not have more than 5 parchis and less than 3 parchis.
//Implement a smart contract of the above game with the following public function such that :
//The deployer of the smart contract (let’s call him/her owner) can start the game whose purpose is to manage the game.
//Any player can end the game either by claiming a valid win, or , by directly choosing to end the game given that at least 1 hour has passed since the start of the game.
//Players can see how many time any player corresponding to some address has won the game.
//After the end of the game, new game can be started again by the owner.
//Input:
//setState(address[4] _players, uint8[4][4] _state) : Using this function, owner can start a game by assigning parchis to the players, given that there is currently no game in progress.
//_players is the array of addresses of the players. All the addesses must be valid addresses and owner can not be a player. The order of the turns of players is same as the order of the players in the _players array in a cyclic manner starting with the first address having first turn.
//_state is an array of ‘arrays of uint8’ (ranging from 0 to 4 inclusive). This represents a state of the game at any particular point. The state should be valid state, which is attainable in a real game through the above rules mentioned. The representation of state is same as the 3rd point in game rules mentioned above. For an invalid state, the transaction must revert.
//Example -
//[[0,1,1,1],[0,2,2,1],[1,1,1,1],[3,0,0,1]] - is a valid state, where 3rd player has the current turn
//[[1,1,1,1],[2,0,1,1],[0,2,1,1],[1,1,1,1]] - is a valid state, where 1st player has the current turn.
//passParchi(uint8 _type) : This function is only accessible to a valid player during the game in his/her own turn. The player must have at least one parchi of type ‘_type’.
//endGame() : Any player can access this during the game after at least 1 hour has passed since the start of the game. This will end the game abruptly without concluding any winner. This is to prevent cases where player either delay their turn, or try to keep 1 parchi of all 4 types with them to prevent anyone from winning the game.
//claimWin() : Any player can access this during the game given that the player has 4 parchis of same type. This will end the game and record a win corresponding to the player who has called this function.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SolahParchiThap {

    address public owner;
    address[4] public players;
    address public turn;
    uint256 public startTime;
    uint8[4][4] public game;

    mapping(address=>uint) public wins;
    mapping(address=>bool) public parchiPassedInThisRound;

    modifier onlyOwner(){
        require(msg.sender == owner,"Only owner can call this function");
        _;
    }

    modifier onlyPlayers(){
        bool isPlayer = false;
        for(uint8 i = 0;i<4;i++)
        {
            if(msg.sender == players[i])
            {
                isPlayer = true;
                break;
            }
        }
        require(isPlayer,"Only Valid players can call this function");
        _; 
    }   

    modifier onlyDuringGame(){
        require(startTime!=0,"No game in progress");
        _;
    }

    constructor(){
        owner = msg.sender;
    }


    // To set and start the game
    function setState(address[4] memory _players, uint8[4][4] memory parchis) public onlyOwner
    {
        for(uint8 i=0;i<4;i++)
        {
            require(_players[i]!=address(0),"Invalid Player Address");
            require(_players[i]!=owner,"Owner can never be played");
            uint8 totalParchis = 0;
            for(uint8 j=0;j<4;j++)
            {
                require(parchis[i][j]<=4,"Invalid Parchi Count");
                totalParchis+=parchis[i][j];
            }
            require(totalParchis == 4,"Invalid Parchi Count for a player");
        }
        players = _players;
        game = parchis;
        turn = players[0];
        startTime = block.timestamp;
    }

    // To pass the parchi to next player
    function passParchi(uint8 parchi) public onlyPlayers onlyDuringGame
    {
        uint8 senderIndex;
        for(uint8 i=0;i<4;i++)
        {
            if(msg.sender == players[i])
            {
                senderIndex = i;
                break;
            }
        }
        //Check 1:Ensure sender has parchis of the specified type to pass
        require(game[senderIndex][parchi-1]>0,"Sender does not have the parchis of the specified type.");

        //Check 2:Ensure sender has not already passed a parchi in this round
        require(!parchiPassedInThisRound[msg.sender],"Sender has already passed a parchi in this round.");

        //Calculate the Receiver Index in a cyclic manner
        uint8 receiverIndex = (senderIndex + 1)%4;    

        //Pass the parchi from the sender to the receiver
        game[senderIndex][parchi-1]--;
        game[receiverIndex][parchi-1]++;
        turn = players[receiverIndex];//Update the turn to the next player

        //Mark that the sender has already passed a parchi in this round
        parchiPassedInThisRound[msg.sender] = true;
    }

    // To claim win
    function claimWin() public onlyPlayers onlyDuringGame
    {
        uint senderIndex;
        for(uint8 i=0;i<4;i++)
        {
            if(game[senderIndex][i] == 4)
            {
                wins[msg.sender]++;
                startTime = 0;
                return;
            }
        }
        revert("Players does not have 4 parchis of the same type.");
    }

    // To end the game
    function endGame() public onlyPlayers onlyDuringGame
    {
        require(block.timestamp >= startTime + 1 hours,"At least 1 hour must pass since the start of the game.");
        startTime = 0;
    }

    // To see the number of wins
    function getWins(address add) public view returns (uint256)
    {
        return wins[add];
    }

    // To see the parchis held by the caller of this function
    function myParchis() public view onlyPlayers onlyDuringGame returns (uint8[4] memory)
    {
        uint8 playerIndex;
        for(uint8 i=0;i<4;i++)
        {
            if(msg.sender == players[i])
            {
                playerIndex = i;
                break;
            }
        }
        return game[playerIndex];
    }

    // To get the state of the game
    function getState() public view onlyOwner onlyDuringGame returns (address[4] memory, address, uint8[4][4] memory)
    {
        return (players,turn,game);
    }

}
