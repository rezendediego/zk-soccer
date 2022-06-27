pragma circom 2.0.4;

   template Matrix2Node(){
        signal input line;
        signal input column;
        
        signal output outNodeNumber; 
        
        var nodeNumber;

        if(line != 0){
            //Find node from matrix point(x,y)
            //nodeNumber = ( (x-1) * row.length) + y
            nodeNumber = ((line - 1)*9) + column;
        }else{
            nodeNumber = column;
        }

        outNodeNumber <-- nodeNumber;
        
    }
