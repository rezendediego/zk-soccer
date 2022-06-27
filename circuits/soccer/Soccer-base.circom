pragma circom 2.0.4;


include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";
include "./Soccer-logic.circom";
include "./RangeProof.circom";
include "./MatrixToNode.circom";



template Soccer() {
    /* <<<<< THE SOCCER FIELD IS A MATRIX 9x9 >>>>> */

    /*
    ██╗███╗   ██╗██████╗ ██╗   ██╗████████╗
    ██║████╗  ██║██╔══██╗██║   ██║╚══██╔══╝
    ██║██╔██╗ ██║██████╔╝██║   ██║   ██║   
    ██║██║╚██╗██║██╔═══╝ ██║   ██║   ██║   
    ██║██║ ╚████║██║     ╚██████╔╝   ██║   
    ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝    ╚═╝   
    */

    //PUBLIC SIGNALS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    //The value 0(zero) means that Player1 Attacks while Player2 or Generated Autoplay 
    //defends, while value 1 is represents the opposite turn. 
    signal input fieldLayerMode;
    assert(fieldLayerMode>=0);
    assert(fieldLayerMode<=1);

    //PRIVATE SIGNALS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    //Input signal for defense players on the field
    signal input defenseField[9][9];
    //Input signal for attack players on the field
    signal input attackField[9][9];


    //Flatened matrix holds position from Input signal for Goal Keeper body 
    //positioning while defending under the goal matrix
    signal input goalMatrixDefense[9];
    //Flatened matrix holds position Input signal for the goal kick  
    signal input goalMatrixAttack[9];

    
    









    /*
     ██████╗ ██╗   ██╗████████╗██████╗ ██╗   ██╗████████╗
    ██╔═══██╗██║   ██║╚══██╔══╝██╔══██╗██║   ██║╚══██╔══╝
    ██║   ██║██║   ██║   ██║   ██████╔╝██║   ██║   ██║   
    ██║   ██║██║   ██║   ██║   ██╔═══╝ ██║   ██║   ██║   
    ╚██████╔╝╚██████╔╝   ██║   ██║     ╚██████╔╝   ██║   
     ╚═════╝  ╚═════╝    ╚═╝   ╚═╝      ╚═════╝    ╚═╝   
    */

    signal output goal;
    signal output fault;
    signal output penalty;
    signal output interception;
    signal output goal_keeper_defense;





  
  
  
  
  
    /*
    ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
    ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
    ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
    ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
     ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
      ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝
    */
    
    //VARIABLES >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //Penalty Mark Area
    var penaltyAreaNodesLayer1[6] = [ 3,  4,  5, 12, 13, 14];
    var penaltyAreaNodesLayer2[6] = [66, 67, 68, 75, 76, 77];

    //Ball coordinates(x|ball[0], y|ball[1])
    var ball[2];

    // Player's position 
    // Defense Players (x|index_0, y|index_1) 
    var matrixPosDefensePlayer_01[2];
    var matrixPosDefensePlayer_02[2];
    var matrixPosDefensePlayer_03[2];

    // Attack Players (x|index_0, y|index_1)
    var matrixPosAttackPlayer_01[2];
    var matrixPosAttackPlayer_02[2];
    var matrixPosAttackPlayer_03[2];

    // Support for Penalty and Fault verification on the 3 moments of the match:
    // Get Attack and Defense Positions whether they are over Penalty Area or not
    var saveNodeAttackPenaltyCheck[3]= [0,0,0];
    var saveNodeDefensePenaltyCheck[3]= [0,0,0];

    // Get Attack and Defense Positions whether they are outside Penalty Area 
    var saveNodeAttackFaultCheck[3]= [0,0,0];
    var saveNodeDefenseFaultCheck[3]= [0,0,0];

    //Interpret whether there is Penalty or Fault and assign to value holders below
    // Value 1 is confirmation and 0 the opposite.
    var penaltyConfirmed = 0;
    var faultConfirmed = 0;
    
    //Variables to hold final values for Game Logic input 
    var input_A = 0;
    var input_E = 0; 

    //Goal helper variables to keep constraints known
    var checkKick = 1;
    var checkGoalKeeperBody = 0;
    var input_F = 1;
    var input_G = 0;








    /*
     ██████╗ ██████╗ ███╗   ███╗██████╗  ██████╗ ███╗   ██╗███████╗███╗   ██╗████████╗███████╗
    ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██╔═══██╗████╗  ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
    ██║     ██║   ██║██╔████╔██║██████╔╝██║   ██║██╔██╗ ██║█████╗  ██╔██╗ ██║   ██║   ███████╗
    ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║   ██║██║╚██╗██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║
    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ╚██████╔╝██║ ╚████║███████╗██║ ╚████║   ██║   ███████║
     ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
    */

    // COMPONENT SOCCER GAME WHICH WILL PASS VALUES FOR GAME LOGIC VERIFICATION
    component SoccerGame = SoccerLogic();
    
    // COMPONENTS TO GET CONVERSION VALUES FROM MATRIX NOTATION TO NODE NOTATION
    component getNodeDef1 =  Matrix2Node();
    component getNodeDef2 =  Matrix2Node();
    component getNodeDef3 =  Matrix2Node();

    component getNodeAtta1 =  Matrix2Node();
    component getNodeAtta2 =  Matrix2Node();
    component getNodeAtta3 =  Matrix2Node();

    //Defender Nodes 
    component nodeDefensePlayer[3];
    nodeDefensePlayer[0] = BUFFER();
    nodeDefensePlayer[1] = BUFFER();
    nodeDefensePlayer[2] = BUFFER();
    //Attacker Nodes
    component nodeAttackPlayer[3];
    nodeAttackPlayer[0] = BUFFER();
    nodeAttackPlayer[1] = BUFFER();
    nodeAttackPlayer[2] = BUFFER();

    // NAND component wasItGoal? GOAL (out=1) or DEFENSE (out=0) 
    component wasItGoal = NAND();

    //
    component equalityChecker[9];

    //Penalty will be checked 3**3 times --> 3 attack players to the power of 3 defense players 
    component penaltyChecker[9];
    component penaltyCheckerTWO[9];



    




    /*
    ██╗███╗   ██╗██╗████████╗██╗ █████╗ ██╗         
    ██║████╗  ██║██║╚══██╔══╝██║██╔══██╗██║         
    ██║██╔██╗ ██║██║   ██║   ██║███████║██║         
    ██║██║╚██╗██║██║   ██║   ██║██╔══██║██║         
    ██║██║ ╚████║██║   ██║   ██║██║  ██║███████╗    
    ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝╚══════╝    
                                                

     ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗
    ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝
    ██║     ███████║█████╗  ██║     █████╔╝ 
    ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ 
    ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗
     ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝
    */                                    





    /* 
     ° ///////////////////////////////////////////////////////////////////////////////////////
     °   PRE COMPUTE AND EXTRACT DATA FROM INPUT FOR VERIFICATIONS OF GAMEPLAY >>>>>>>>>>>>>>>
     ° ///////////////////////////////////////////////////////////////////////////////////////   
    */
    
    /*
     ° WHERE ARE THE PLAYERS POSITIONED ON THE FIELD? >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
     °
     ° Read attack and defense soccer fields then:
     °   1) Check all positions for rangeProof it has a valid value  between 0 and 3 
     °      where zero is empty space and 1, 2, and 3 are the player´s position except 
     °      the goal keaper that will be treated in separate.
     °
     °   2) Assign player position to its variable for later computation     
    */ 

    component virtualDefenseField[9][9];
    component virtualAttackField[9][9];

    for (var i = 0; i < 9; i++) {
       for (var j = 0; j < 9; j++) {
            //DEFENSE check
            virtualDefenseField[i][j] = RangeProof(4);
            virtualDefenseField[i][j].range[0] <== 0;
            virtualDefenseField[i][j].range[1] <== 3;
            virtualDefenseField[i][j].in <== defenseField[i][j];
            assert(virtualDefenseField[i][j].out == 1);

            var positionTempDefense = defenseField[i][j];
                
            //Check if position is not empty (ZERO VALUE) , hence, has a Defense player positioned in it 
            if(positionTempDefense != 0){
                    //Where is defense player 01? 
                    if (positionTempDefense == 1){
                        matrixPosDefensePlayer_01[0] = i;
                        matrixPosDefensePlayer_01[1] = j;
                    }
                    //Where is defense player 02?
                    if (positionTempDefense == 2){
                        matrixPosDefensePlayer_02[0] = i;
                        matrixPosDefensePlayer_02[1] = j;
                    }
                    //Where is defense player 03?
                    if (positionTempDefense == 3){
                        matrixPosDefensePlayer_03[0] = i;
                        matrixPosDefensePlayer_03[1] = j;
                    }                  
            }//End 

            
            //ATTACK check 
              
            virtualAttackField[i][j] = RangeProof(4);
            virtualAttackField[i][j].range[0] <== 0;
            virtualAttackField[i][j].range[1] <== 3;
            virtualAttackField[i][j].in <== attackField[i][j];
            assert(virtualAttackField[i][j].out == 1);

            var positionTempAttack = attackField[i][j];

            //Check if position is not empty, hence, has a Attack player positioned in it 
            if(positionTempAttack != 0){
                    //Where is the attack player 01?
                    if (positionTempAttack == 1){
                            matrixPosAttackPlayer_01[0] = i;
                            matrixPosAttackPlayer_01[1] = j;
                         
                    }
                    //Where is the attack player 02?
                    if (positionTempAttack == 2){
                            matrixPosAttackPlayer_02[0] = i;
                            matrixPosAttackPlayer_02[1] = j;
                    }
                    //Where is the attack player 03?
                    if (positionTempAttack == 3){
                            matrixPosAttackPlayer_03[0] = i;
                            matrixPosAttackPlayer_03[1] = j;
                    }


            }
        
        }// End FOR LOOP variable j
    
    }// End FOR LOOP variable i


    //#################################################
    //Convert Matrix position to node position
    //#################################################
        
    //Defender Nodes Calculation
    getNodeDef1.line <-- matrixPosDefensePlayer_01[0];
    getNodeDef1.column <-- matrixPosDefensePlayer_01[1];
    nodeDefensePlayer[0].in <--  getNodeDef1.outNodeNumber;
    
    getNodeDef2.line <-- matrixPosDefensePlayer_02[0];
    getNodeDef2.column <-- matrixPosDefensePlayer_02[1];
    nodeDefensePlayer[1].in <--  getNodeDef2.outNodeNumber;

    getNodeDef3.line <-- matrixPosDefensePlayer_03[0];
    getNodeDef3.column <-- matrixPosDefensePlayer_03[1];
    nodeDefensePlayer[2].in <--  getNodeDef3.outNodeNumber;
    
    //Defender Nodes each player in a different position
    component nodeDefenderSamePositionChecker[3];
    nodeDefenderSamePositionChecker[0] = IsEqual();
    nodeDefenderSamePositionChecker[1] = IsEqual();
    nodeDefenderSamePositionChecker[2] = IsEqual();

    nodeDefenderSamePositionChecker[0].in[0] <== nodeDefensePlayer[0].out;
    nodeDefenderSamePositionChecker[0].in[1] <== nodeDefensePlayer[1].out;

    nodeDefenderSamePositionChecker[1].in[0] <== nodeDefensePlayer[0].out;
    nodeDefenderSamePositionChecker[1].in[1] <== nodeDefensePlayer[2].out;

    nodeDefenderSamePositionChecker[2].in[0] <== nodeDefensePlayer[1].out;
    nodeDefenderSamePositionChecker[2].in[1] <== nodeDefensePlayer[2].out;

    assert(nodeDefenderSamePositionChecker[0].out == 0);
    assert(nodeDefenderSamePositionChecker[1].out == 0);
    assert(nodeDefenderSamePositionChecker[2].out == 0);

    nodeDefenderSamePositionChecker[0].out === 0;
    nodeDefenderSamePositionChecker[1].out === 0;
    nodeDefenderSamePositionChecker[2].out === 0;

  
    





    //Attacker Nodes Calculation
    getNodeAtta1.line <-- matrixPosAttackPlayer_01[0];
    getNodeAtta1.column <-- matrixPosAttackPlayer_01[1];
    nodeAttackPlayer[0].in <--  getNodeAtta1.outNodeNumber;


    getNodeAtta2.line <-- matrixPosAttackPlayer_02[0];
    getNodeAtta2.column <-- matrixPosAttackPlayer_02[1];
    nodeAttackPlayer[1].in <--  getNodeAtta2.outNodeNumber;
    

    getNodeAtta3.line <-- matrixPosAttackPlayer_03[0];
    getNodeAtta3.column <-- matrixPosAttackPlayer_03[1];
    nodeAttackPlayer[2].in <--  getNodeAtta3.outNodeNumber;
    

    //Attacker Nodes each player in a different position
    component nodeAttackerSamePositionChecker[3];
    nodeAttackerSamePositionChecker[0] = IsEqual();
    nodeAttackerSamePositionChecker[1] = IsEqual();
    nodeAttackerSamePositionChecker[2] = IsEqual();


    nodeAttackerSamePositionChecker[0].in[0] <== nodeAttackPlayer[0].out;
    nodeAttackerSamePositionChecker[0].in[1] <== nodeAttackPlayer[1].out;

    nodeAttackerSamePositionChecker[1].in[0] <== nodeAttackPlayer[0].out;
    nodeAttackerSamePositionChecker[1].in[1] <== nodeAttackPlayer[2].out;

    nodeAttackerSamePositionChecker[2].in[0] <== nodeAttackPlayer[1].out;
    nodeAttackerSamePositionChecker[2].in[1] <== nodeAttackPlayer[2].out;

    assert(nodeAttackerSamePositionChecker[0].out == 0);
    assert(nodeAttackerSamePositionChecker[1].out == 0);
    assert(nodeAttackerSamePositionChecker[2].out == 0);

    nodeAttackerSamePositionChecker[0].out === 0;
    nodeAttackerSamePositionChecker[1].out === 0;
    nodeAttackerSamePositionChecker[2].out === 0;


    //#######################################################










    /*

    ███████╗ █████╗ ██╗   ██╗██╗  ████████╗
    ██╔════╝██╔══██╗██║   ██║██║  ╚══██╔══╝
    █████╗  ███████║██║   ██║██║     ██║   
    ██╔══╝  ██╔══██║██║   ██║██║     ██║   
    ██║     ██║  ██║╚██████╔╝███████╗██║   
    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝   
                                       


    ██████╗ ███████╗███╗   ██╗ █████╗ ██╗  ████████╗██╗   ██╗
    ██╔══██╗██╔════╝████╗  ██║██╔══██╗██║  ╚══██╔══╝╚██╗ ██╔╝
    ██████╔╝█████╗  ██╔██╗ ██║███████║██║     ██║    ╚████╔╝ 
    ██╔═══╝ ██╔══╝  ██║╚██╗██║██╔══██║██║     ██║     ╚██╔╝  
    ██║     ███████╗██║ ╚████║██║  ██║███████╗██║      ██║   
    ╚═╝     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝      ╚═╝   
    */                                                     
    



    //FAULT DETECTION  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    /*
     ° FAULT = If the Player that attacks choose a position already taken by Defender Player 
     °         anywhere on the field with excepetion of PENALTY MARKING AREA.
     ° 
     ° PENALTY = If the Player that attacks choose a position already taken by Defender Player
     °           but both are inside the PENALTY MARKING AREA, then, its PENALTY**.
     °           
     °           **TO BE CONFIRMED, MUST HAVE NO PRIOR INTERCEPTION HAPPENED
     °
     */



    //Is there an Attack Player over the Penalty Area? 
    for(var j = 0; j<3; j++){  
        if(nodeAttackPlayer[j].out == 3 || nodeAttackPlayer[j].out == 4 || nodeAttackPlayer[j].out == 5 || nodeAttackPlayer[j].out == 12 || nodeAttackPlayer[j].out == 13 || nodeAttackPlayer[j].out == 14){
            saveNodeAttackPenaltyCheck[j] = nodeAttackPlayer[j].out;
        }else{
            saveNodeAttackFaultCheck[j] = nodeAttackPlayer[j].out;
        }
    
    }

    //Is there an Defense Player over the Penalty Area? 
    for(var i = 0; i<3; i++){  
        if(nodeDefensePlayer[i].out == 3 || nodeDefensePlayer[i].out == 4 || nodeDefensePlayer[i].out == 5 || nodeDefensePlayer[i].out == 12 || nodeDefensePlayer[i].out == 13 || nodeDefensePlayer[i].out == 14){
            saveNodeDefensePenaltyCheck[i] = nodeDefensePlayer[i].out;
        }else{
            saveNodeDefenseFaultCheck[i] = nodeDefensePlayer[i].out;
        }
    
    }

    //Are there an Attack and Defense Player over the same quadrant within Penalty Area? 
    for(var i=0; i<3; i++){
        if(saveNodeAttackPenaltyCheck[i]!=0){
            for(var j=0; j<3; j++){
                if (saveNodeAttackPenaltyCheck[i] == saveNodeDefensePenaltyCheck[j]){
                    penaltyConfirmed = 1;
                }
                
            }
        }
    }

    
    
    //Are there an Attack and Defense Player over the same quadrant outside Penalty Area? 
    for(var i=0; i<3; i++){
        if(saveNodeAttackFaultCheck[i]!=0){
            for(var j=0; j<3; j++){
                if (saveNodeAttackFaultCheck[i] == saveNodeDefenseFaultCheck[j]){
                    faultConfirmed = 1;
                }
                
            }
        }
    }

    //Assign the variable which will store the value 1 or 0 whether exists or not the Fault  
    input_A = faultConfirmed;
    


    //Assign the variable which will store the value 1 or 0 whether exists or not the Penalty  
    input_E = penaltyConfirmed; 
    
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    // LOGIC CIRCUIT INPUT ASSIGNMENT @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //
    // Get for Logic fault values
    SoccerGame.a <-- input_A;
    // Get for Logic penalty values
    SoccerGame.e <-- input_E;
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@










     



    /*
     ██████╗  ██████╗  █████╗ ██╗     
    ██╔════╝ ██╔═══██╗██╔══██╗██║     
    ██║  ███╗██║   ██║███████║██║     
    ██║   ██║██║   ██║██╔══██║██║     
    ╚██████╔╝╚██████╔╝██║  ██║███████╗
     ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝
    */




    

    // GOAL OR GOAL KEEPER DEFENSE VERIFICATION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    //<<< If Goal cannot be scored, no need for further calculation >>> 
    //First of all check if is it possible to score a goal
    for(var i=0; i<9; i++){
        //Find the target quadrant choosen by attack user
        if(goalMatrixAttack[i] == 1){
            if(goalMatrixDefense[i]==1){
                  //Check wether the choosen quadrant is empty to make possible score 
                  //the goal.
                  checkGoalKeeperBody = 1; 
            }
         
        }
    } //END LOOP FOR
              
            
            // Since Here, inside this if condition, the Goal Kick is already value 1, 
            // if the Goal Keeper is there to defend its value will be also 1
            // Therefore NAND will produce 0 (zero) as output, meaning 
            // NO GOAL WAS POSSIBLE AND DEFENSE WAS MADE.
            // Otherwise, the Goal Keeper by not being there will have value 0 and the NAND will produce output 1
            // Which means GOAL SCORED!
            wasItGoal.a <-- checkKick;
            wasItGoal.b <-- checkGoalKeeperBody;
                   

            if (wasItGoal.out){
                 input_F = 0;
                 input_G = 1;
            }
            
            SoccerGame.f <-- input_F;
            SoccerGame.g <-- input_G;
    //END GOAL OR GOAL KEEPER DEFENSE VERIFICATION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  


    // TEMPORARY ASSIGNMENTS FOR COMPILE CHECK
    SoccerGame.b <-- 0;
    SoccerGame.c <-- 0;
    SoccerGame.d <-- 0;






  
    /*
     ██████╗ ██╗   ██╗████████╗                                                         
    ██╔═══██╗██║   ██║╚══██╔══╝                                                         
    ██║   ██║██║   ██║   ██║                                                            
    ██║   ██║██║   ██║   ██║                                                            
    ╚██████╔╝╚██████╔╝   ██║                                                            
     ╚═════╝  ╚═════╝    ╚═╝                                                            
                                                                                    
     █████╗ ███████╗███████╗██╗ ██████╗ ███╗   ██╗███╗   ███╗███████╗███╗   ██╗████████╗
    ██╔══██╗██╔════╝██╔════╝██║██╔════╝ ████╗  ██║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
    ███████║███████╗███████╗██║██║  ███╗██╔██╗ ██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
    ██╔══██║╚════██║╚════██║██║██║   ██║██║╚██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
    ██║  ██║███████║███████║██║╚██████╔╝██║ ╚████║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
    ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
    */

    
    fault <== SoccerGame.result[0];
    goal <== SoccerGame.result[1];
    penalty <== SoccerGame.result[2];
    interception <== SoccerGame.result[3];
    goal_keeper_defense <== SoccerGame.result[4];


  
}//END TEMPLATE SOCCER