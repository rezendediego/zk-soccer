pragma circom 2.0.4;
include "../node_modules/circomlib/circuits/gates.circom";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Helper Template to organize soccer circuit input
template BUFFER(){
    signal input in;
    signal output out;
    out <-- in;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////




template SoccerLogic(){
    signal input a;
    signal input b;
    signal input c;
    signal input d;
    signal input e;
    signal input f;
    signal input g;

    // The Result Array is the final output of the game circuit after all checks 
    signal output result[5];
 
  
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    //LOGIC COMPONENTS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        
    /* 
     ° ///////////////////////////////////////////////////////////////////////////////////////
     °  CIRCUIT'S COMPONENTS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><>>>>>>>>>>>>>>>>>>>>>>>>>>
     ° ///////////////////////////////////////////////////////////////////////////////////////   
    */

    /*
     ° INPUTs THAT FEED THE GAME AND TRIGGER GAMEPLAY CIRCUIT LOGIC VERIFICATIONS   
    */

    // A - BUFFER/YES - FAULT CONDITION. 
    // THE VALUE IS 1 IF FAULT IS DETECTED WHICH MEANS AN ATTACKER PLAYER IS POSITIONED 
    // AT SAME QUADRANT ALREADY OCCUPIED BY DEFFENSE PLAYER
    component BUFFER_A_Fault = BUFFER();
    
     
    // B - BUFFER/YES - INTERCEPTION POSITION 1 TO POSITION 2 CONDITION. 
    // THE VALUE IS 1 IF INTERCEPTION BY DEFENSOR IS DETECTED WHICH MEANS THAT THERE IS A DEFENSOR 
    // POSITIONED IN THE LINE OF PASS FROM POSITION 1 TO POSITION 2
    component BUFFER_B_Interception_1to2 = BUFFER();
    

    // C - BUFFER/YES - INTERCEPTION POSITION 2 TO POSITION 3 CONDITION. 
    // THE VALUE IS 1 IF INTERCEPTION BY DEFENSOR IS DETECTED WHICH MEANS THAT THERE IS A DEFENSOR 
    // POSITIONED IN THE LINE OF PASS FROM POSITION 2 TO POSITION 3
    component BUFFER_C_Interception_2to3 = BUFFER();
    

    // D - BUFFER/YES - INTERCEPTION POSITION 3 TO POSITION GOAL CONDITION. 
    // THE VALUE IS 1 IF INTERCEPTION BY DEFENSOR IS DETECTED WHICH MEANS THAT THERE IS A DEFENSOR 
    // POSITIONED IN THE LINE OF PASS FROM POSITION 3 TO POSITION GOAL
    component BUFFER_D_Interception_3toGoal = BUFFER();
    

    // E - BUFFER/YES - PENALTY CONDITION. 
    // THE VALUE IS 1 IF PENALTY IS DETECTED WHICH MEANS AN ATTACKER PLAYER IS POSITIONED 
    // AT SAME QUADRANT ALREADY OCCUPIED BY DEFFENSE PLAYER WITHIN THE PENALTY AREA
    component BUFFER_E_Penalty = BUFFER();
    
    
    // F - BUFFER/YES - GOAL KEEPER BODY CONDITION. 
    // THE VALUE IS 1 IF GOAL KEEPER BODY IS POSITIONED IN A WAY TO DEFEND/AVOID THE GOAL
    // WHICH MEANS THAT A PART OF GOAL KEEPER BODY IS POSITIONED AT SAME QUADRANT CHOOSEN 
    // AS GOAL KICK TARGET
    component BUFFER_F_Goal_Keeper = BUFFER();
    
    
    // G - BUFFER/YES - GOAL KICK/ GOAL CONDITION. 
    // THE VALUE IS 1 IF GOAL KICK TARGET QUADRANT IS EMPTY WICH MEANS THAT HAS NO GOAL 
    // KEEPER POSITIONED OVER THE CHOOSEN TARGET 
    component BUFFER_G_Goal_Kick = BUFFER();
    
        
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    ////////////////////////////////////////////
   
    BUFFER_A_Fault.in <== a;
    BUFFER_B_Interception_1to2.in <== b;
    BUFFER_C_Interception_2to3.in <== c;
    BUFFER_D_Interception_3toGoal.in <== d;
    BUFFER_E_Penalty.in <== e;
    BUFFER_F_Goal_Keeper.in <== f;
    BUFFER_G_Goal_Kick.in <== g;
   ////////////////////////////////////////////
   ////////////////////////////////////////////
   ////////////////////////////////////////////


    /*
     °
     ° ZK SOCCER GAMEPLAY CIRCUIT LOGIC
     °  
    */
    // 01 - OR GATE - ATTACKER FROM POSITION 1 TO POSITION 2 && 
    // ATTACKER FROM POSITION 2 TO POSITION 3 INTERCEPTION CHECK
    component OR_01_Defense_Intercept_1to2_2to3 = OR();
    
    // 02 - NOT/INVERTER GATE - PENALTY CONDITION INVERTER.IT REINFORCES THE PENALTY 
    // SUPERIOR HIERARCHY ON POSSIBLE CASE OF INTERCEPTION INSIDE PENALTY AREA FROM 
    // POSITION 3 TO GOAL
    component NOT_02_Penalty_Condition_Inverter = NOT();
    
    // 03 - AND GATE - ATTACKER FROM 3 TO GOAL INTERCEPTION && PENALTY CHECK. 
    // REINFORCES RULE THAT IF THERE IS A PENALTY, AN INTERCEPTION BETWEEN 
    // PATH PLAYER 3 TO GOAL WILL NOT BE CONSIDERED  
    component AND_03_Defense_Intercept_3toGOAL_Penalty = AND();
    
    // 04 - OR GATE - INTERCEPTION AT ANY OF 3 MOMENTS CHECK: 
    // IS THERE AN INTERCEPTION (DEFENSE PLAYER IN THE MIDDLE OF THE PATH OF THE PASS BETWEEN ATTACK PLAYERS)
    // 1 - ATTACKER 1 TO ATTACKER 2 || 2 - ATTACKER 2 TO ATTACKER 3 || 3 - ATTACKER 3 TO ATTACKER GOAL 
    component OR_04_Defense_Intercept_Checker_1to2_2to3_3toGoal = OR();

    // 05 - NOT/INVERTER GATE - GOAL KEEPER BODY TO BE CHECKED AGAINST CHOICE OF GOAL KICK
    // IF THE BODY DOES NOT AVOID THE GOAL KICK BEING VALUE ZERO, IT IS INVERTED TO COMPOSE
    // WITH GOAL KICK AND ACTIVATE AND_6 THAT CHECKS FOR GOAL
    component NOT_05_Goal_Keeper_Body_Defense_Checker = NOT();

    // 06 - AND GATE - GOAL CHECK. IT HAS VALUE 1 IF GOAL KEEPER BODY POSITION DOES NOT AVOID 
    // GOAL KICK; THEN ITS GOAL. OTHERWISE, VALUE IS ZERO, MEANING DEFENSE BY GOAL KEEPER WAS MADE.
    component AND_06_Goal_Check = AND();
    
    // 07 - NOT/INVERTER GATE - GOAL INVERTER TO REINFORCE RULE OF GOAL SUPERIOR HIERARCHY WITH 
    // RELATION TO PENALTY CONDITION. SO IF THERE IS A GOAL AND A PENALTY CONDITION SIMULTANEOUSLY
    // PREVAILS THE GOAL, AND IF THERE IS NO GOAL, BUT EXIST A PENALTY CONDITION, THE PENALTY 
    // ROUTINE MUST BE TRIGGERED 
    component NOT_07_GoalCheck_3toGOAL_Penalty_Inverter = NOT();
    
    // 08 - NOT/INVERTER GATE - INTERCEPTION INVERTER. ITS FUNCTION IS REINFORCE RULE THAT IF 
    // THERE IS AN INTERCEPTION DURING THE FIRST TWO MOVIMENTS, BEFORE THE PENALTY, THEN 
    // PREVAILS INTERCEPTION OVER THE PENALTY 
    component NOT_08_Interception_Inverter = NOT();
    
    // 09 - AND GATE - INTERCEPTION OR PENALTY CHECK
    component AND_09_Interception_or_Penalty_Check = AND();
    
    // 10 - AND GATE - GOAL OR PENALTY CHECK. IF THERE IS A GOAL AND PENALTY SIMULTANEOUS.
    // INVERTER NOT_07_GoalCheck_3toGOAL_Penalty_Inverter WILL VALUE ZERO REINFORCING THAT 
    // GOAL PREVAILS OVER PENALTY
    component AND_10_Goal_or_Penalty_Check = AND();
    
    // 11 - AND GATE - GOAL OR FAULT CHECK. REINFORCE RULE THAT FAULT PREVAILS OVER GOAL
    component AND_11_Goal_or_Fault_Check = AND();
    
    // 12 - AND GATE - INTERCEPTION OR FAULT CHECK. REINFORCE RULE THAT FAULT PREVAILS OVER INTERCEPTION
    component AND_12_Interception_or_Fault_Check = AND();
    
    // 13 - AND GATE - PENALTY OR FAULT CHECK. REINFORCE RULE THAT FAULT PREVAILS OVER PENALTY
    component AND_13_Penalty_or_Fault_Check = AND();
    
    // 14 - OR GATE - ACCUMULLATE WETHER AN INTERCEPTION, PENALTY OR FAULT HAPPENED
    component OR_14_Certify_Interception_Penalty_or_Fault = OR();
    
    // 15 - XOR GATE - IDENTIFY IF INTERCEPTION OR PENALTY HAPPENED
    component XOR_15_Identify_Interception_or_Penalty_Happened = XOR();
    
    // 16 - NOR GATE - GOAL KEEPER DEFENSE CHECK. THE GATE RECEIVES THE PREVIOUS GATE XOR_15 WHICH IDENTIFIES 
    // IF AN INTERCEPTION OR PENALTY HAPPENED. ALSO RECEIVE GOAL CHECK FROM AND_06. SO IF THERE IS NO INTERCEPTION, 
    // NO PENALTY AND NO GOAL IT MEANS THE GOAL KEPPER DEFENDED
    component NOR_16_Goal_Keeper_Deffense_Check = NOR();
    
    // 17 - AND GATE - GOAL KEEPER DEFENSE OR FAULT CHECK. REINFORCE RULE THAT FAULT PREVAILS OVER GOAL KEEPER DEFENSE
    component AND_17_Goal_Keeper_Defense_or_Fault_Check = AND();
    
    // 18 - OR GATE - ACCUMULLATE WETHER AN INTERCEPTION, PENALTY, GOAL KEEPER DEFENSE OR FAULT HAPPENED
    component OR_18_Certify_Interception_Penalty_Goal_Keeper_Defense_or_Fault = OR();
    
    // 19 - OR GATE - ACCUMULLATE WETHER AN INTERCEPTION, PENALTY, GOAL KEEPER DEFENSE, GOAL OR FAULT HAPPENED 
    component OR_19_Certify_Interception_Penalty_Goal_Keeper_Defense_Goal_or_Fault = OR();
    
    // 20 - NOT/INVERTER GATE - FAULT CHECKER INVERTER. 
    component NOT_20_Fault_Checker_Inverter = NOT();
    
    // 21 - AND GATE - REINFORCE FAULT OVER GOAL KEEPER DEFENSE
    component AND_21_Fault_or_Goal_Keeper_Defense = AND();


    ////////////////////////////////////////////
    ////////////////////////////////////////////
    ////////////////////////////////////////////

    //#########################################################################################################
    // CIRCUIT CONNECTIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //#########################################################################################################

    /*
     °
     ° ZK SOCCER GAMEPLAY CIRCUIT LOGIC
     ° Circuit is within the pdf. Soonly it will also be here in ascii 
    */
    
    OR_01_Defense_Intercept_1to2_2to3.a <== BUFFER_B_Interception_1to2.out;
    OR_01_Defense_Intercept_1to2_2to3.b <== BUFFER_C_Interception_2to3.out;



    NOT_02_Penalty_Condition_Inverter.in <== BUFFER_E_Penalty.out;



    AND_03_Defense_Intercept_3toGOAL_Penalty.a <== BUFFER_D_Interception_3toGoal.out;
    AND_03_Defense_Intercept_3toGOAL_Penalty.b <== NOT_02_Penalty_Condition_Inverter.out;
    


    OR_04_Defense_Intercept_Checker_1to2_2to3_3toGoal.a <== OR_01_Defense_Intercept_1to2_2to3.out;
    OR_04_Defense_Intercept_Checker_1to2_2to3_3toGoal.b <== AND_03_Defense_Intercept_3toGOAL_Penalty.out;



    NOT_05_Goal_Keeper_Body_Defense_Checker.in <== BUFFER_F_Goal_Keeper.out;



    AND_06_Goal_Check.a <== NOT_05_Goal_Keeper_Body_Defense_Checker.out;
    AND_06_Goal_Check.b <== BUFFER_G_Goal_Kick.out;
    
    
   
    NOT_07_GoalCheck_3toGOAL_Penalty_Inverter.in <== AND_06_Goal_Check.out;
    


    NOT_08_Interception_Inverter.in <== OR_04_Defense_Intercept_Checker_1to2_2to3_3toGoal.out;
    


    AND_09_Interception_or_Penalty_Check.a <== NOT_08_Interception_Inverter.out;
    AND_09_Interception_or_Penalty_Check.b <== BUFFER_E_Penalty.out;
    


    AND_10_Goal_or_Penalty_Check.a <== AND_09_Interception_or_Penalty_Check.out;
    AND_10_Goal_or_Penalty_Check.b <== NOT_07_GoalCheck_3toGOAL_Penalty_Inverter.out;
    
    

    AND_11_Goal_or_Fault_Check.a <== AND_06_Goal_Check.out;
    AND_11_Goal_or_Fault_Check.b <== BUFFER_A_Fault.out;
    


    AND_12_Interception_or_Fault_Check.a <== BUFFER_A_Fault.out;
    AND_12_Interception_or_Fault_Check.b <== OR_04_Defense_Intercept_Checker_1to2_2to3_3toGoal.out;



    AND_13_Penalty_or_Fault_Check.a <== BUFFER_A_Fault.out;
    AND_13_Penalty_or_Fault_Check.b <== AND_10_Goal_or_Penalty_Check.out;



    OR_14_Certify_Interception_Penalty_or_Fault.a <== AND_13_Penalty_or_Fault_Check.out;
    OR_14_Certify_Interception_Penalty_or_Fault.b <== AND_12_Interception_or_Fault_Check.out;



    XOR_15_Identify_Interception_or_Penalty_Happened.a <== OR_04_Defense_Intercept_Checker_1to2_2to3_3toGoal.out;
    XOR_15_Identify_Interception_or_Penalty_Happened.b <== AND_10_Goal_or_Penalty_Check.out;



    NOR_16_Goal_Keeper_Deffense_Check.a <== XOR_15_Identify_Interception_or_Penalty_Happened.out;
    NOR_16_Goal_Keeper_Deffense_Check.b <== AND_06_Goal_Check.out;



    AND_17_Goal_Keeper_Defense_or_Fault_Check.a <== BUFFER_A_Fault.out;
    AND_17_Goal_Keeper_Defense_or_Fault_Check.b <== NOR_16_Goal_Keeper_Deffense_Check.out;



    OR_18_Certify_Interception_Penalty_Goal_Keeper_Defense_or_Fault.a <== OR_14_Certify_Interception_Penalty_or_Fault.out;
    OR_18_Certify_Interception_Penalty_Goal_Keeper_Defense_or_Fault.b <== AND_17_Goal_Keeper_Defense_or_Fault_Check.out;



    OR_19_Certify_Interception_Penalty_Goal_Keeper_Defense_Goal_or_Fault.a <== AND_11_Goal_or_Fault_Check.out;
    OR_19_Certify_Interception_Penalty_Goal_Keeper_Defense_Goal_or_Fault.b <== OR_18_Certify_Interception_Penalty_Goal_Keeper_Defense_or_Fault.out;



    NOT_20_Fault_Checker_Inverter.in <== OR_19_Certify_Interception_Penalty_Goal_Keeper_Defense_Goal_or_Fault.out;



    AND_21_Fault_or_Goal_Keeper_Defense.a <== NOT_20_Fault_Checker_Inverter.out;   
    AND_21_Fault_or_Goal_Keeper_Defense.b <== NOR_16_Goal_Keeper_Deffense_Check.out;


    //####################################################################################################
    // RESULT OF GAME CIRCUIT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //####################################################################################################

    //FAULT
    result[0] <== OR_19_Certify_Interception_Penalty_Goal_Keeper_Defense_Goal_or_Fault.out;
    //GOAL
    result[1] <== AND_06_Goal_Check.out;
    //PENALTY
    result[2] <== AND_10_Goal_or_Penalty_Check.out;
    //DEFENDER INTERCEPTION
    result[3] <== OR_04_Defense_Intercept_Checker_1to2_2to3_3toGoal.out;
    //GOAL KEEPER DEFENSE
    result[4] <== AND_21_Fault_or_Goal_Keeper_Defense.out;
    
    /*
    
        +---------+---------+---------+-----------------------+----------------------+---------------------------------------------------------------+
        |  FAULT  |  GOAL   | PENALTY | DEFENDER INTERCEPTION | GOAL KEEPER DEFENSE  |                            RESULT                             |
        +---------+---------+---------+-----------------------+----------------------+---------------------------------------------------------------+
        | INDEX 0 | INDEX 1 | INDEX 2 | INDEX 3               | INDEX 4              | MESSAGE                                                       |
        | 1       | 1       | 1       | 1                     | 1                    | FAULT -  meaning the attack is cancelled in favor of defensor |
        | 0       | 1       | 1       | 1                     | 0                    | INTERCEPTION - Defender intercepted attack                    |
        | 0       | 0       | 1       | 1                     | 0                    | INTERCEPTION - Defender intercepted attack before penalty     |
        | 0       | 0       | 1       | 0                     | 0                    | PENALTY - play a new routine to kick to goal                  |
        | 0       | 1       | 1       | 0                     | 0                    | GOAL plus PENALTY - prevails GOAL.                            |
        | 0       | 1       | 0       | 0                     | 0                    | GOAL                                                          |
        | 0       | 0       | 0       | 0                     | 1                    | GOAL KEEPER DEFENSE                                           |
        | 1       | X       | X       | X                     | X                    | FAULT plus any combination - FAULT prevails                   |
        +---------+---------+---------+-----------------------+----------------------+---------------------------------------------------------------+


    
    
    */







}