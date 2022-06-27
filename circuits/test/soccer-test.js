const chai = require("chai");
const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

//FAULT -  meaning the attack is cancelled in favor of defensor

describe("FAULT ---  meaning the attack is cancelled in favor of defensor", function () {
    this.timeout(100000000);
    
    it("FAULT DETECTED", async () => {
        const circuit = await wasm_tester("soccer/Soccer.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "fieldLayerMode": 0,
            "defenseField": [			
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  3,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  1,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  2,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],
		
			"attackField": [
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  3,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 2,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  1,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],

            "goalMatrixDefense": [ 1,  0,  1,  0,  1,  0,  0,  1,  0],

            "goalMatrixAttack":  [ 0,  1,  0,  0,  0,  0,  0,  0,  0]
            
        }
        
        const witness = await circuit.calculateWitness(INPUT, true);
        await circuit.checkConstraints(witness);
        //console.log(witness);

        
        await circuit.assertOut(witness, {
            fault:1n,
            goal:1n,
			penalty:0n,
			interception:0n,
			goal_keeper_defense:0n
        });
        
    });
});









/*
//INTERCEPTION - Defender intercepted attack
describe("FAULT -  meaning the attack is cancelled in favor of defensor", function () {
    this.timeout(100000000);
    
    it("Correct Input", async () => {
        const circuit = await wasm_tester("./circuits/soccer/Soccer.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "fieldLayerMode": 0,
            "defenseField": [			
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],
		
			"attackField": [
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],

            "goalMatrixDefense": [ 0,  0,  0,  0,  0,  0,  0,  0,  0],

            "goalMatrixAttack":  [ 0,  0,  0,  0,  0,  0,  0,  0,  0]
            
        }
        
        const witness = await circuit.calculateWitness(INPUT, true);
        await circuit.checkConstraints(witness);
        //console.log(witness);

        
        await circuit.assertOut(witness, {
            fault: 1n,
            goal:0n,
			penalty:0n,
			interception:0n,
			goal_keeper_defense:0n
        });
        
    });
});

*/






/*

//INTERCEPTION - Defender intercepted attack before penalty 
describe("FAULT -  meaning the attack is cancelled in favor of defensor", function () {
    this.timeout(100000000);
    
    it("Correct Input", async () => {
        const circuit = await wasm_tester("./circuits/soccer/Soccer.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "fieldLayerMode": 0,
            "defenseField": [			
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],
		
			"attackField": [
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],

            "goalMatrixDefense": [ 0,  0,  0,  0,  0,  0,  0,  0,  0],

            "goalMatrixAttack":  [ 0,  0,  0,  0,  0,  0,  0,  0,  0]
            
        }
        
        const witness = await circuit.calculateWitness(INPUT, true);
        await circuit.checkConstraints(witness);
        //console.log(witness);

        
        await circuit.assertOut(witness, {
            fault: 1n,
            goal:0n,
			penalty:0n,
			interception:0n,
			goal_keeper_defense:0n
        });
        
    });
});
*/









//PENALTY - play a new routine to kick to goal
describe("PENALTY --- play a new routine to kick to goal", function () {
    this.timeout(100000000);
    
    it("PENALTY DETECTED", async () => {
        const circuit = await wasm_tester("soccer/Soccer.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "fieldLayerMode": 0,
            "defenseField": [			
					[ 0,  0,  0,  3,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  1,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  2,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],
		
			"attackField": [
					[ 0,  0,  0,  2,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  3,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  1,  0,  0,  0,  0,  0,  0,  0]
			],
  
            "goalMatrixDefense": [ 1,  0,  1,  0,  1,  0,  0,  1,  0],

            "goalMatrixAttack":  [ 1,  0,  0,  0,  0,  0,  0,  0,  0]
            
        }
        
        const witness = await circuit.calculateWitness(INPUT, true);
        await circuit.checkConstraints(witness);
        //console.log(witness);

        
        await circuit.assertOut(witness, {
            fault: 0n,
            goal:0n,
			penalty:1n,
			interception:0n,
			goal_keeper_defense:0n
        });
        
    });
});











//GOAL plus PENALTY - prevails GOAL.
describe("GOAL plus PENALTY --- prevails GOAL", function () {
    this.timeout(100000000);
    
    it("GOAL DETECTED", async () => {
        const circuit = await wasm_tester("soccer/Soccer.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "fieldLayerMode": 0,
            "defenseField": [			
					[ 0,  0,  0,  3,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  1,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  2,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],
		
			"attackField": [
					[ 0,  0,  0,  2,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  3,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  1,  0,  0,  0,  0,  0,  0,  0]
			],
  
            "goalMatrixDefense": [ 1,  0,  1,  0,  1,  0,  0,  1,  0],

            "goalMatrixAttack":  [ 0,  1,  0,  0,  0,  0,  0,  0,  0]
            
        }
        
        const witness = await circuit.calculateWitness(INPUT, true);
        await circuit.checkConstraints(witness);
        //console.log(witness);

        
        await circuit.assertOut(witness, {
            fault: 0n,
            goal:1n,
			penalty:0n,
			interception:0n,
			goal_keeper_defense:0n
        });
        
    });
});










//GOAL
describe("GooOOOOAL !!!", function () {
    this.timeout(100000000);
    
    it("GOAL DETECTED", async () => {
        const circuit = await wasm_tester("soccer/Soccer.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "fieldLayerMode": 0,
            "defenseField": [			
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  1,  2,  3,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],
		
			"attackField": [
					[ 0,  0,  0,  0,  0,  3,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  2,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  1,  0,  0]
			],

			"goalMatrixDefense": [ 1,  0,  1,  0,  1,  0,  0,  1,  0],

            "goalMatrixAttack":  [ 0,  0,  0,  0,  0,  0,  1,  0,  0]
        }
        
        const witness = await circuit.calculateWitness(INPUT, true);
        await circuit.checkConstraints(witness);
        //console.log(witness);

        
        await circuit.assertOut(witness, {
            fault: 0n,
            goal:1n,
			penalty:0n,
			interception:0n,
			goal_keeper_defense:0n
        });
        
    });
});










//GOAL KEEPER DEFENSE
describe("uuUHHH !!! GOAL KEEPER DEFENSE", function () {
    this.timeout(100000000);
    
    it("GOAL KEEPER DEFENSE DETECTED", async () => {
        const circuit = await wasm_tester("soccer/Soccer.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "fieldLayerMode": 0,
            "defenseField": [			
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  1,  2,  3,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],
		
			"attackField": [
					[ 0,  0,  0,  0,  0,  3,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  2,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  1,  0,  0]
			],

			"goalMatrixDefense": [ 1,  0,  1,  0,  1,  0,  0,  1,  0],

            "goalMatrixAttack":  [ 0,  0,  0,  0,  1,  0,  0,  0,  0]
        }
        
        const witness = await circuit.calculateWitness(INPUT, true);
        await circuit.checkConstraints(witness);
        //console.log(witness);

        
        await circuit.assertOut(witness, {
            fault: 0n,
            goal:0n,
			penalty:0n,
			interception:0n,
			goal_keeper_defense:1n
        });
        
    });
});








/*

//FAULT plus any combination - FAULT prevails
describe("FAULT -  meaning the attack is cancelled in favor of defensor", function () {
    this.timeout(100000000);
    
    it("Correct Input", async () => {
        const circuit = await wasm_tester("./circuits/soccer/Soccer.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "fieldLayerMode": 0,
            "defenseField": [			
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],
		
			"attackField": [
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0],
					[ 0,  0,  0,  0,  0,  0,  0,  0,  0]
			],

            "goalMatrixDefense": [ 0,  0,  0,  0,  0,  0,  0,  0,  0],

            "goalMatrixAttack":  [ 0,  0,  0,  0,  0,  0,  0,  0,  0]
            
        }
        
        const witness = await circuit.calculateWitness(INPUT, true);
        await circuit.checkConstraints(witness);
        //console.log(witness);

        
        await circuit.assertOut(witness, {
            fault: 1n,
            goal:0n,
			penalty:0n,
			interception:0n,
			goal_keeper_defense:0n
        });
        
    });
});


*/