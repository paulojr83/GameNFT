pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract GameNFT is ERC721{

    enum Status {
       Alive, 
       Dead, 
       Blocked
    }

    enum Elements {
        Water, 
        Fire, 
        Earth, 
        Wind 
    }

    struct Monster{
        string name;
        uint level;
        string img;
        uint hp;
        Elements element;
        Status status;
    }

    Monster[] public monsters;
    address public gameOwner;

    constructor () ERC721 ("GameNFT", "GNFT"){

        gameOwner = msg.sender;

    } 

    modifier onlyOwnerOf(uint _monsterId) {

        require(ownerOf(_monsterId) == msg.sender,"Apenas o dono pode batalhar com este monster");
        _;

    }

    function battle(uint _attackingmonster, uint _defendingmonster) public onlyOwnerOf(_attackingmonster){
        Monster storage attacker = monsters[_attackingmonster];
        Monster storage defender = monsters[_defendingmonster];

        if( defender.status == status.Alive ){
            uint xp = 1;
            uint attackerPoint = increasedAttackByElement(attacker, defender);
            if (attackerPoint >= defender.level) {
                defender.hp += attackerPoint - defender.level;
                if( defender.hp <= 0 ) {
                    defender.status = status.Dead;
                    xp +=2;
                }else {
                    defender.level +=1;
                }                
                attacker.level += xp;
            }else{
                attacker.hp += -1;
                if( attacker.hp <= 0 ) {
                    attacker.status = status.Dead;
                    xp +=2;
                }
                defender.level += xp;
            }
        }
        
    }

    function increasedAttackByElement( Monster attacker, Monster defender) private view returns (uint) {
        uint attackerPoint = 0;
        Elements attElement = defender.element;

        if ( attElement == Elements.Water) {
            return attackByElementWater(attacker.level, defender);
        }
         
        if ( attElement == Elements.Fire ) {
            return attackByElementFire(attacker.level, defender);
        }

        if ( attElement == Elements.Earth) {
            return attackByElementEarth(attacker.level, defender);
        }

        if ( attElement == Elements.Wind) {
            return attackByElementWind(attacker.level, defender);
        }
    }

    function attackByElementWater( uint attackerLevel, Monster defender) private view returns (uint) {
        Elements defElement = defender.element;
        if ( defElement == Elements.Water) {
            return attackerLevel;
        }
         
        if ( defElement == Elements.Fire ) {
            return attackerLevel + 1;
        }

        if ( defElement == Elements.Earth) {
            return attackerLevel + 1;
        }

        if ( defElement == Elements.Wind) {
            return attackerLevel;
        }
    }

    function attackByElementFire( uint attackerLevel, Monster defender) private view returns (uint) {
        Elements defElement = defender.element;
        if ( defElement == Elements.Water) {
            return attackerLevel - 1;
        }
         
        if ( defElement == Elements.Fire ) {
            return attackerLevel;
        }

        if ( defElement == Elements.Earth) {
            return attackerLevel;
        }

        if ( defElement == Elements.Wind) {
            return attackerLevel + 1;
        }
    }

    function attackByElementEarth( uint attackerLevel, Monster defender) private view returns (uint) {
        Elements defElement = defender.element;
        if ( defElement == Elements.Water) {
            return attackerLevel - 1;
        }
         
        if ( defElement == Elements.Fire ) {
            return attackerLevel + 1;
        }

        if ( defElement == Elements.Earth) {
            return attackerLevel;
        }

        if ( defElement == Elements.Wind) {
            return attackerLevel + 1;
        }
    }

    function attackByElementWind( uint attackerLevel, Monster defender) private view returns (uint) {
        Elements defElement = defender.element;
        if ( defElement == Elements.Water) {
            return level;
        }
         
        if ( defElement == Elements.Fire ) {
            return attackerLevel + 1;
        }

        if ( defElement == Elements.Earth) {
            return attackerLevel - 1;
        }

        if ( defElement == Elements.Wind) {
            return attackerLevel;
        }
    }

    function createNewmonster(string memory _name, address _to, string memory _img, Elements element) public {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos monsters");
        uint id = monsters.length;
        monsters.push(Monster(_name, 1,_img, element, 10, Status.Alive));
        _safeMint(_to, id);
    }


}